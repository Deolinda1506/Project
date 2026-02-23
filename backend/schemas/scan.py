from datetime import datetime
from pydantic import BaseModel, Field


class ScanCreate(BaseModel):
    patient_id: str
    image_path: str = Field(..., max_length=1024)


class ScanResponse(BaseModel):
    id: str
    patient_id: str
    image_path: str
    created_at: datetime

    model_config = {"from_attributes": True}


class ResultCreate(BaseModel):
    scan_id: str
    imt_mm: float
    is_high_risk: bool
    model_version: str | None = None


class ResultResponse(BaseModel):
    id: str
    scan_id: str
    imt_mm: float
    is_high_risk: bool
    model_version: str | None
    created_at: datetime

    model_config = {"from_attributes": True}
