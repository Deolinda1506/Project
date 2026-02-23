from datetime import datetime
from pydantic import BaseModel, Field


class PatientCreate(BaseModel):
    identifier: str = Field(..., min_length=1, max_length=255)
    facility: str | None = None


class PatientUpdate(BaseModel):
    identifier: str | None = Field(None, min_length=1, max_length=255)
    facility: str | None = None


class PatientResponse(BaseModel):
    id: str
    user_id: str | None
    identifier: str
    facility: str | None
    created_at: datetime

    model_config = {"from_attributes": True}
