"""Patients CRUD (protected)."""
from uuid import uuid4
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from backend.database import get_db
from backend.models import User, Patient
from backend.schemas.patient import PatientCreate, PatientUpdate, PatientResponse
from backend.auth import get_current_user

router = APIRouter(prefix="/patients", tags=["patients"])


def _get_patient_or_404(patient_id: str, user_id: str, db: Session) -> Patient:
    patient = db.get(Patient, patient_id)
    if not patient or patient.user_id != user_id or patient.is_deleted:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Patient not found")
    return patient


@router.post("", response_model=PatientResponse, status_code=status.HTTP_201_CREATED)
def create_patient(
    body: PatientCreate,
    db: Annotated[Session, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_user)],
):
    patient = Patient(
        id=str(uuid4()),
        user_id=current_user.id,
        identifier=body.identifier,
        facility=body.facility,
    )
    db.add(patient)
    db.commit()
    db.refresh(patient)
    return patient


@router.get("", response_model=list[PatientResponse])
def list_patients(
    db: Annotated[Session, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_user)],
):
    # Only return non-deleted patients
    return db.query(Patient).filter(
        (Patient.user_id == current_user.id) & (Patient.is_deleted == False)
    ).all()


@router.get("/{patient_id}", response_model=PatientResponse)
def get_patient(
    patient_id: str,
    db: Annotated[Session, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_user)],
):
    return _get_patient_or_404(patient_id, current_user.id, db)


@router.patch("/{patient_id}", response_model=PatientResponse)
def update_patient(
    patient_id: str,
    body: PatientUpdate,
    db: Annotated[Session, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_user)],
):
    patient = _get_patient_or_404(patient_id, current_user.id, db)
    if body.identifier is not None:
        patient.identifier = body.identifier
    if body.facility is not None:
        patient.facility = body.facility
    db.commit()
    db.refresh(patient)
    return patient


@router.delete("/{patient_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_patient(
    patient_id: str,
    db: Annotated[Session, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_user)],
):
    """Soft delete: Mark patient as deleted (data hidden but recoverable)."""
    patient = _get_patient_or_404(patient_id, current_user.id, db)
    
    from datetime import datetime
    patient.is_deleted = True
    patient.deleted_at = datetime.utcnow()
    
    # Mark all associated scans as deleted
    for scan in patient.scans:
        scan.is_deleted = True
        scan.deleted_at = datetime.utcnow()
    
    db.commit()
    return None
