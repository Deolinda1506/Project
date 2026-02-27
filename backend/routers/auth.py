"""Firebase authentication and user data management."""
from uuid import uuid4
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session

from backend.database import get_db
from backend.models import User
from backend.schemas.user import UserCreate, UserResponse
from backend.auth import get_current_user
from backend.firebase_config import verify_firebase_token

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/register", response_model=UserResponse)
def register(
    firebase_token: str,
    body: UserCreate,
    db: Annotated[Session, Depends(get_db)]
):
    """
    Register user with Firebase ID token.
    Client must first authenticate with Firebase SDK, then send ID token.
    """
    try:
        firebase_uid = verify_firebase_token(firebase_token)
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Invalid Firebase token: {str(e)}"
        )
    
    # Check if user already exists
    if db.query(User).filter(User.firebase_uid == firebase_uid).first():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User already registered"
        )
    
    user = User(
        id=str(uuid4()),
        firebase_uid=firebase_uid,
        email=body.email,
        display_name=body.display_name,
        role=body.role,
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user


@router.get("/me/export", description="Data portability: Download all personal data as JSON")
def export_user_data(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
):
    """
    Export all user data including patients, scans, and results.
    Complies with Rwanda DPA Law N°058/2021 (Right to Data Portability).
    """
    user = db.query(User).get(current_user.id)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    
    # Build portable data structure
    data_export = {
        "user": {
            "id": user.id,
            "email": user.email,
            "display_name": user.display_name,
            "role": user.role,
            "created_at": user.created_at.isoformat(),
            "updated_at": user.updated_at.isoformat(),
        },
        "patients": [
            {
                "id": p.id,
                "identifier": p.identifier,
                "facility": p.facility,
                "created_at": p.created_at.isoformat(),
                "updated_at": p.updated_at.isoformat(),
                "scans": [
                    {
                        "id": s.id,
                        "image_path": s.image_path,
                        "created_at": s.created_at.isoformat(),
                        "result": {
                            "id": s.result.id,
                            "imt_mm": s.result.imt_mm,
                            "risk_level": s.result.risk_level,
                            "created_at": s.result.created_at.isoformat(),
                        } if s.result else None,
                    }
                    for s in p.scans
                ],
            }
            for p in user.patients
        ],
    }
    
    return JSONResponse(
        content=data_export,
        headers={"Content-Disposition": f"attachment; filename=strokelink_export_{user.id}.json"},
    )


@router.delete("/me", status_code=status.HTTP_204_NO_CONTENT, description="Right to be forgotten: Mark account as deleted (soft delete)")
def delete_account(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
):
    """
    Mark user account and all associated data as deleted (soft delete).
    Data remains in database but is hidden from normal queries.
    Complies with Rwanda DPA Law N°058/2021 (Right to be Forgotten).
    Data will be permanently purged after 30 days.
    """
    user = db.query(User).get(current_user.id)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    
    # Soft delete: mark user and all patients as deleted
    from datetime import datetime
    user.is_deleted = True
    user.deleted_at = datetime.utcnow()
    
    # Mark all patients as deleted
    for patient in user.patients:
        patient.is_deleted = True
        patient.deleted_at = datetime.utcnow()
        # Mark all scans as deleted
        for scan in patient.scans:
            scan.is_deleted = True
            scan.deleted_at = datetime.utcnow()
    
    db.commit()
    
    return None
