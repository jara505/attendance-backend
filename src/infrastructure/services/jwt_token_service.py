from datetime import datetime, timedelta, timezone

import jwt

from src.application.interfaces.token_service import TokenServicePort
from src.infrastructure.config import settings


class JwtTokenService(TokenServicePort):
    def create_access_token(self, subject: str, role: str) -> str:
        now = datetime.now(timezone.utc)
        payload = {
            "sub": subject,
            "role": role,
            "iat": now,
            "exp": now + timedelta(minutes=settings.JWT_EXPIRATION_MINUTES),
        }
        return jwt.encode(payload, settings.JWT_SECRET_KEY, algorithm=settings.JWT_ALGORITHM)

    def decode_token(self, token: str) -> dict:
        return jwt.decode(token, settings.JWT_SECRET_KEY, algorithms=[settings.JWT_ALGORITHM])
