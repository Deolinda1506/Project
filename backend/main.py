"""FastAPI app: SQLAlchemy · Pydantic v2 · JWT. SQLite (dev) / PostgreSQL (prod)."""
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from backend.database import engine, Base
import backend.models  # noqa: F401 — register models
from backend.routers import auth, patients, scans


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Create DB tables on startup (use Alembic in prod for migrations)."""
    Base.metadata.create_all(bind=engine)
    yield
    # shutdown if needed


app = FastAPI(
    title="StrokeLink API",
    description="Carotid ultrasound analysis for stroke triage. FastAPI · SQLAlchemy · Pydantic v2 · JWT.",
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
