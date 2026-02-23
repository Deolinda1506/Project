from datetime import datetime
from sqlalchemy import Column, DateTime, ForeignKey, String
from sqlalchemy.orm import relationship

from backend.database import Base


class Scan(Base):
    __tablename__ = "scans"

    id = Column(String(36), primary_key=True)
    patient_id = Column(String(36), ForeignKey("patients.id"), nullable=False, index=True)
    image_path = Column(String(1024), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    patient = relationship("Patient", back_populates="scans")
    result = relationship("Result", back_populates="scan", uselist=False, cascade="all, delete-orphan")
