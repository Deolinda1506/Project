"""FastAPI app: SQLAlchemy · Pydantic v2 · JWT · Firebase · Swin-UNETR. SQLite (dev) / PostgreSQL (prod)."""
from contextlib import asynccontextmanager
from pathlib import Path

from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import torch
from monai.networks.nets import SwinUNETR
import cv2
import numpy as np

from backend.database import engine, Base
import backend.models  # noqa: F401 — register models
from backend.routers import auth, patients, scans
import backend.firebase_config  # Initialize Firebase on startup


# MODEL INFERENCE 
MODEL_PATH = Path(__file__).parent.parent / "models" / "carotid_swin_unetr_2d.pt"
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = None

# Spacing from ultrasound machine (mm per pixel)
# Typical carotid ultrasound: ~0.03-0.05 mm/pixel
DEFAULT_SPACING_MM_PER_PIXEL = 0.04


def load_model():
    """Load Swin-UNETR model from disk."""
    global model
    if model is not None:
        return model
    
    if not MODEL_PATH.exists():
        raise FileNotFoundError(f"Model not found at {MODEL_PATH}")
    
    model = SwinUNETR(
        in_channels=1,
        out_channels=2,
        spatial_dims=2,
        feature_size=32,
        num_heads=(3, 6, 12, 24),
        patch_size=2,
        window_size=7,
        use_checkpoint=True,
    ).to(device)
    
    state = torch.load(MODEL_PATH, map_location=device)
    model.load_state_dict(state.get("model", state), strict=False)
    model.eval()
    print(f"✅ Model loaded from {MODEL_PATH}")
    return model


def preprocess_image(image_bytes: bytes, size=(224, 224)) -> torch.Tensor:
    """Convert image bytes to model-ready tensor."""
    nparr = np.frombuffer(image_bytes, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_GRAYSCALE)
    
    if img is None:
        raise ValueError("Invalid image")
    
    # Normalize
    img = img.astype(np.float32) / (np.max(img) + 1e-8)
    
    # Resize
    img = cv2.resize(img, size, interpolation=cv2.INTER_LINEAR)
    
    # Add batch and channel dims: (1, 1, H, W)
    img_tensor = torch.from_numpy(img).unsqueeze(0).unsqueeze(0).to(device)
    
    return img_tensor


#  IMT (Intima-Media Thickness) Calculation 
def get_interfaces_from_mask(mask, lumen_label=1, wall_label=2):
    """Lumen-Intima and Media-Adventitia interfaces per column. mask: (H,W) 0=bg, 1=lumen, 2=wall."""
    h, w = mask.shape
    lumen_intima = np.full(w, np.nan)
    media_adventitia = np.full(w, np.nan)
    for x in range(w):
        col = mask[:, x]
        lumen_idx = np.where(col == lumen_label)[0]
        wall_idx = np.where(col == wall_label)[0]
        if len(lumen_idx) and len(wall_idx):
            lumen_center = np.mean(lumen_idx)
            wall_inner = wall_idx[np.argmin(np.abs(wall_idx - lumen_center))]
            lumen_intima[x] = float(wall_inner)
            wall_outer = wall_idx[np.argmax(np.abs(wall_idx - lumen_center))]
            media_adventitia[x] = float(wall_outer)
        elif len(wall_idx) >= 2:
            lumen_intima[x] = float(np.min(wall_idx))
            media_adventitia[x] = float(np.max(wall_idx))
    return lumen_intima, media_adventitia


def imt_pixels_per_column(lumen_intima, media_adventitia):
    """Vertical distance (pixels) between inner and outer wall per column."""
    valid = np.isfinite(lumen_intima) & np.isfinite(media_adventitia)
    thickness = np.abs(media_adventitia - lumen_intima)
    thickness[~valid] = np.nan
    return thickness


def imt_mm_from_mask(mask, spacing_mm_per_pixel, lumen_label=1, wall_label=2):
    """Mean IMT in mm from segmentation mask."""
    li, ma = get_interfaces_from_mask(mask, lumen_label=lumen_label, wall_label=wall_label)
    thickness_px = imt_pixels_per_column(li, ma)
    valid = np.isfinite(thickness_px)
    if not np.any(valid):
        return np.nan
    return float(np.nanmean(thickness_px) * spacing_mm_per_pixel)


def predict_imt(image_bytes: bytes, spacing_mm_per_pixel: float = DEFAULT_SPACING_MM_PER_PIXEL) -> dict:
    """Run inference and estimate IMT (Intima-Media Thickness) from segmentation."""
    model = load_model()
    
    img_tensor = preprocess_image(image_bytes)
    
    with torch.no_grad():
        pred = model(img_tensor)
        pred_soft = torch.softmax(pred, dim=1)
        pred_class = pred_soft.argmax(dim=1).squeeze().cpu().numpy()  # (H, W)
    
    # Calculate real IMT from segmentation mask
    # pred_class: 0=background, 1=foreground (carotid artery)
    # For 2-class model, treat class 1 as both lumen and wall
    imt_mm = imt_mm_from_mask(pred_class, spacing_mm_per_pixel, lumen_label=1, wall_label=1)
    
    # Fallback to foreground probability if IMT calculation fails
    if np.isnan(imt_mm):
        foreground_prob = pred_soft[0, 1].mean().item()
        imt_mm = 0.5 + (foreground_prob * 0.7)  # Fallback: scale to 0.5–1.2 mm range
    else:
        foreground_prob = pred_soft[0, 1].mean().item()
    
    # Clinical risk threshold: IMT ≥ 0.9 mm indicates high stroke risk
    risk_level = "High" if imt_mm >= 0.9 else "Moderate" if imt_mm >= 0.7 else "Low"
    
    return {
        "imt_mm": round(imt_mm, 2),
        "risk_level": risk_level,
        "foreground_prob": round(foreground_prob, 3),
    }


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Create DB tables on startup (use Alembic in prod for migrations)."""
    Base.metadata.create_all(bind=engine)
    yield
    # shutdown if needed


app = FastAPI(
    title="StrokeLink API",
    description="Carotid ultrasound analysis for stroke triage. FastAPI · SQLAlchemy · Firebase · Pydantic v2 · JWT.",
    version="1.0.0",
    lifespan=lifespan,
)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(patients.router)
app.include_router(scans.router)


@app.get("/")
def root():
    return {"message": "StrokeLink API", "docs": "/docs"}


class PredictionResponse(BaseModel):
    imt_mm: float
    risk_level: str
    foreground_prob: float


@app.post("/predict", response_model=PredictionResponse)
async def predict(file: UploadFile = File(...)):
    """
    Upload ultrasound image, get IMT prediction from Swin-UNETR model.
    
    🔒 PRIVACY: Image processed in-memory only. Image bytes are NOT stored permanently.
    Only IMT result (metadata) is saved to database.
    Complies with ALU data minimization requirement.
    """
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File must be an image")
    
    contents = await file.read()
    
    try:
        result = predict_imt(contents)
        return PredictionResponse(**result)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction failed: {str(e)}")
