from datetime import datetime
from sqlalchemy import Boolean, Column, DateTime, String
from sqlalchemy.orm import relationship

from backend.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(String(36), primary_key=True)
    firebase_uid = Column(String(128), unique=True, nullable=False, index=True)
    email = Column(String(255), unique=True, nullable=False, index=True)
    display_name = Column(String(255))
    role = Column(String(50), default="chw", nullable=False)  # chw or clinician
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    deleted_at = Column(DateTime, nullable=True)  # Soft delete: when user requested deletion
    is_deleted = Column(Boolean, default=False, index=True)  # Soft delete: flag
    
    patients = relationship("Patient", back_populates="user", cascade="all, delete-orphan")
    scans = relationship("Scan", back_populates="user")
