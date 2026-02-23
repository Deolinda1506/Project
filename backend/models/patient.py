from datetime import datetime
from sqlalchemy import Column, DateTime, ForeignKey, String
from sqlalchemy.orm import relationship

from backend.database import Base


class Patient(Base):
    __tablename__ = "patients"

    id = Column(String(36), primary_key=True)
    user_id = Column(String(36), ForeignKey("users.id"), nullable=True, index=True)
    identifier = Column(String(255), nullable=False)
    facility = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    user = relationship("User", backref="patients")
    scans = relationship("Scan", back_populates="patient", order_by="Scan.created_at", cascade="all, delete-orphan")
