"""Firebase Admin SDK configuration for authentication only."""
import os
from pathlib import Path
import firebase_admin
from firebase_admin import credentials, auth

firebase_key_path = os.getenv("FIREBASE_KEY_PATH", "firebase-key.json")

if Path(firebase_key_path).exists():
    if not firebase_admin._apps:
        cred = credentials.Certificate(firebase_key_path)
        firebase_admin.initialize_app(cred)
    print("✅ Firebase initialized: Authentication only")
else:
    print(f"⚠️  Firebase not initialized. Create {firebase_key_path} from Firebase Console.")


def verify_firebase_token(id_token: str):
    """Verify Firebase ID token for authentication."""
    try:
        decoded_token = auth.verify_id_token(id_token)
        return decoded_token['uid']
    except Exception as e:
        raise ValueError(f"Invalid Firebase token: {str(e)}")
