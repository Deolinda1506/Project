"""App config. SQLite (dev) by default; PostgreSQL (prod) via DATABASE_URL."""
import os
from pathlib import Path

from dotenv import load_dotenv

_root = Path(__file__).resolve().parent.parent
load_dotenv(_root / ".env")

# Local SQLite in data/ for dev
_data_dir = _root / "data"
_data_dir.mkdir(parents=True, exist_ok=True)
_default_sqlite = f"sqlite:///{_data_dir / 'strokelink.db'}"


def get_database_url() -> str:
    url = os.getenv("DATABASE_URL", _default_sqlite)
    if url.startswith("postgres://"):
        url = url.replace("postgres://", "postgresql://", 1)
    return url


# JWT
SECRET_KEY = os.getenv("SECRET_KEY", "change-me-in-production-use-openssl-rand")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60 * 24  # 24 hours
