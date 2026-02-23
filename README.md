# StrokeLink

AI-driven carotid ultrasound analysis for stroke triage (Rwanda). Flutter app + **FastAPI** backend + Swin-UNETR model (MONAI).

**Backend:** FastAPI · SQLAlchemy · Pydantic v2 · JWT  
**Database:** SQLite (dev) · PostgreSQL (prod)

---

## How to install and run

### 1. Run the mobile app (Flutter)

**Prerequisites:** Flutter SDK ([flutter.dev](https://flutter.dev)).

```bash
# Clone the repo (if not already)
# git clone <repo-url> Project-2 && cd Project-2

cd app
flutter pub get
flutter run
```

- **Android:** device/emulator with USB debugging or `flutter run -d android`.
- **iOS:** `cd app && flutter run -d ios` (Mac + Xcode).
- **Web:** `flutter run -d chrome`.

### 2. Run the API (backend)

**Prerequisites:** Python 3.10+, pip.

```bash
# From project root (Project-2/)
python3 -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt

# Start the server (creates SQLite DB in data/ if not set)
uvicorn backend.main:app --reload --host 0.0.0.0 --port 8000
```

- **API docs:** http://localhost:8000/docs  
- **Dev DB:** `data/strokelink.db` (SQLite). For **production**, set `DATABASE_URL` in `.env` to a PostgreSQL URL.  
- **JWT:** Use **POST /auth/login** (username = email, password) then **Authorize** with the returned `access_token`.

### 3. Run the model / notebook (optional)

For training or evaluation (e.g. Colab with GPU):

```bash
pip install -r requirements.txt
jupyter notebook model.ipynb
```

Or open `model.ipynb` in Google Colab and run the cells (mount Drive, unzip data as in the notebook).

---

## Related files to the project

| What | Where |
|------|--------|
| **Mobile app** | `app/` — Flutter (Dart), Bloc state, screens (Login, Dashboard, Scan, Analysis, Triage, Referral, Profile). |
| **App entry & routes** | `app/lib/main.dart` |
| **Bloc (auth, scan)** | `app/lib/bloc/` — `auth_*.dart`, `scan_*.dart` |
| **Backend API** | `backend/` — FastAPI app (`main.py`), routers (`auth`, `patients`, `scans`), SQLAlchemy models, Pydantic v2 schemas, JWT auth. |
| **ML model & training** | `model.ipynb` — data load, preprocessing (CLAHE/DWT), Swin-UNETR, train/val/test, save model. |
| **Carotid helpers** | `carotid/` — `imt_utils.py`, `preprocessing.py`, `data_qa.py`, `train_carotid.py` (used by notebook or scripts). |
| **Saved model** | `models/` — e.g. saved PyTorch/MONAI model. |
| **Dependencies** | `requirements.txt` — Python (torch, monai, fastapi, sqlalchemy, etc.). `app/pubspec.yaml` — Flutter. |

---

## Deployed version / installable package

- **Deployed app (web):** _[Add link when deployed, e.g. Render, Vercel, or Flutter web URL.]_
- **Installable package:** _[Add link to APK (Android) or .exe (Windows) when built.]_

Build Android APK from project root:

```bash
cd app && flutter build apk --release
# Output: app/build/app/outputs/flutter-apk/app-release.apk
```

---

## Video demo (Canvas)

A **5-minute video** demonstrating the app (focus on **core functionalities**: dashboard, scan/capture, gallery, analysis flow, triage results; minimal sign-up/sign-in) is submitted separately on Canvas.

---

## Attempt 1 checklist (submission)

- [ ] Repo with this README (install/run steps + related files).
- [ ] 5-minute video (demo, core features).
- [ ] Link to deployed version or APK/.exe in this README or in Canvas.

## Attempt 2

- [ ] Zip of the same repo and submit as required.
