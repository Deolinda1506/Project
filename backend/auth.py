"""Firebase token verification and get_current_user dependency."""
from typing import Annotated

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session

from backend.database import get_db
from backend.models import User
from backend.firebase_config import verify_firebase_token

security = HTTPBearer()


async def get_current_user(
    credentials: Annotated[HTTPAuthorizationCredentials, Depends(security)],
    db: Annotated[Session, Depends(get_db)],
) -> User:
    """
    Verify Firebase ID token and return the corresponding user.
    Client must send: Authorization: Bearer <firebase_id_token>
    """
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid or expired Firebase token",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    try:
        firebase_uid = verify_firebase_token(credentials.credentials)
    except Exception:
        raise credentials_exception
    
    user = db.query(User).filter(User.firebase_uid == firebase_uid).first()
    if not user or user.is_deleted:
        raise credentials_exception
    
    return user

    payload = decode_token(token)
    if payload is None or payload.get("type") != "access":
        raise credentials_exception
    user_id = payload.get("sub")
    if not user_id:
        raise credentials_exception
    user = db.get(User, user_id)
    if user is None:
        raise credentials_exception
    return user
