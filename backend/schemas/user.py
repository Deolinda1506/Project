from datetime import datetime
from pydantic import BaseModel, EmailStr


class UserCreate(BaseModel):
    email: EmailStr
    display_name: str | None = None
    role: str = "chw"  # chw or clinician


class UserResponse(BaseModel):
    id: str
    firebase_uid: str
    email: str
    display_name: str | None
    role: str
    created_at: datetime

    model_config = {"from_attributes": True}

