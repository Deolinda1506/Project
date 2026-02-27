"""Scans and results CRUD (protected). Images processed in-memory only (not stored permanently)."""
from uuid import uuid4
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session

from backend.database import get_db
from backend.models import User, Patient, Scan, Result
from backend.schemas.scan import ScanCreate, ScanResponse, ResultCreate, ResultResponse
from backend.auth import get_current_user

router = APIRouter(prefix="/scans", tags=["scans"])


def _get_scan_or_404(scan_id: str, user_id: str, db: Session) -> Scan:
    scan = db.get(Scan, scan_id)
    if not scan or scan.patient.user_id != user_id or scan.is_deleted:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Scan not found")
    return scan


@router.post("", response_model=ScanResponse, status_code=status.HTTP_201_CREATED)
def create_scan(
    body: ScanCreate,
    db: Annotated[Session, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_user)],
):
    patient = db.get(Patient, body.patient_id)
    if not patient or patient.user_id != current_user.id:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Patient not found")
    scan = Scan(
        id=str(uuid4()),
        patient_id=body.patient_id,
        user_id=current_user.id,
        image_path=body.image_path,
    )
    db.add(scan)
    db.commit()
    db.refresh(scan)
    return scan


@router.get("", response_model=list[ScanResponse])
def list_scans(
    patient_id: Annotated[str | None, Query(description="Filter by patient ID")] = None,
    db: Annotated[Session, Depends(get_db)] = ...,
    current_user: Annotated[User, Depends(get_current_user)] = ...,
):
    q = db.query(Scan).join(Patient).filter(
        (Patient.user_id == current_user.id) & (Scan.is_deleted == False)
    )
    if patient_id:
        q = q.filter(Scan.patient_id == patient_id)
    return q.order_by(Scan.created_at.desc()).all()


@router.get("/{scan_id}", response_model=ScanResponse)
def get_scan(
    scan_id: str,
    db: Annotated[Session, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_user)],
):
    return _get_scan_or_404(scan_id, current_user.id, db)


@router.delete("/{scan_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_scan(
    scan_id: str,
    db: Annotated[Session, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_user)],
):
    """Soft delete: Mark scan as deleted (data hidden but recoverable)."""
    scan = _get_scan_or_404(scan_id, current_user.id, db)
    
    from datetime import datetime
    scan.is_deleted = True
    scan.deleted_at = datetime.utcnow()
    
    db.commit()
    return None


@router.post("/results", response_model=ResultResponse, status_code=status.HTTP_201_CREATED)
def create_result(
    body: ResultCreate,
    db: Annotated[Session, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_user)],
):
    scan = db.get(Scan, body.scan_id)
    if not scan:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Scan not found")
    if scan.patient.user_id != current_user.id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not your scan")
    result = Result(
        id=str(uuid4()),
        scan_id=body.scan_id,
        imt_mm=body.imt_mm,
        risk_level=body.risk_level,
        is_high_risk=body.is_high_risk,
        model_version=body.model_version,
    )
    db.add(result)
    db.commit()
    db.refresh(result)
    return result


@router.get("/{scan_id}/result", response_model=ResultResponse | None)
def get_scan_result(
    scan_id: str,
    db: Annotated[Session, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_user)],
):
    scan = _get_scan_or_404(scan_id, current_user.id, db)
    return scan.result


@router.delete("/{scan_id}/result", status_code=status.HTTP_204_NO_CONTENT)
def delete_scan_result(
    scan_id: str,
    db: Annotated[Session, Depends(get_db)],
    current_user: Annotated[User, Depends(get_current_user)],
):
    scan = _get_scan_or_404(scan_id, current_user.id, db)
    if not scan.result:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="No result for this scan")
    db.delete(scan.result)
    db.commit()
    return None
