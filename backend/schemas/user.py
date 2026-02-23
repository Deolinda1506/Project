from datetime import datetime
from pydantic import BaseModel, EmailStr, Field


class UserCreate(BaseModel):
    email: EmailStr
    password: str = Field(..., min_length=6)
    display_name: str | None = None


class UserResponse(BaseModel):
    id: str
    email: str
    display_name: str | None
    created_at: datetime

    model_config = {"from_attributes": True}


class TokenPayload(BaseModel):
    sub: str  # user id
    exp: int
    type: str = "access"


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
