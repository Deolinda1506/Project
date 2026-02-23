# StrokeLink API

**Stack:** FastAPI · SQLAlchemy · Pydantic v2 · JWT  
**DB:** SQLite (dev) · PostgreSQL (prod via `DATABASE_URL`)

## Run

From **project root**:

```bash
pip install -r requirements.txt
uvicorn backend.main:app --reload --host 0.0.0.0 --port 8000
```

- Docs: http://localhost:8000/docs  
- **POST /auth/register** — body: `{ "email", "password", "display_name?" }`  
- **POST /auth/login** — form: `username` (email), `password` → returns `access_token`  
- Use **Authorize** in Swagger with `Bearer <access_token>` for protected routes.

## Env

- **DATABASE_URL** — optional. Default: `sqlite:///data/strokelink.db`. For prod: `postgresql://user:pass@host:5432/dbname`.  
- **SECRET_KEY** — optional. Default dev key; set in prod (e.g. `openssl rand -hex 32`).

Tables are created on app startup if they don’t exist.
