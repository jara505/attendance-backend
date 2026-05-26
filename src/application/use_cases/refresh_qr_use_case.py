import datetime as dt
from uuid import uuid4

from src.application.dtos.session_dto import RefreshQRResponse
from src.domain.exceptions.session_exceptions import (
    SessionNotFoundError,
    InvalidSessionStateError,
)
from src.infrastructure.models.session_models import SessionStatus


QR_EXPIRES_SECONDS = 15


class RefreshQRUseCase:
    def __init__(self, session_repository):
        self.session_repository = session_repository

    async def execute(self, session_id: str, qr_duration_minutes: int = QR_EXPIRES_SECONDS) -> RefreshQRResponse:
        session = await self.session_repository.get_by_id(session_id)
        if session is None:
            raise SessionNotFoundError(session_id)

        if session.status != SessionStatus.ACTIVE:
            raise InvalidSessionStateError(session.status.value, SessionStatus.ACTIVE.value)

        now = dt.datetime.now()
        qr_token = str(uuid4())
        qr_expires = now + dt.timedelta(seconds=QR_EXPIRES_SECONDS)

        # Solo se refresca el QR. closes_at (fin de sesión) NO se toca.
        session = await self.session_repository.refresh_qr(
            session_id=session_id,
            qr_token=qr_token,
            opens_at=now,
            qr_expires=qr_expires,
        )

        return RefreshQRResponse(
            qr_token=session.qr_token,
            qr_expires=session.qr_expires.isoformat(),
            session_ends_at=session.closes_at.isoformat() if session.closes_at else None,
        )
