from datetime import date, datetime
from src.application.dtos.session_dto import ExtendSessionResponse
from src.domain.exceptions.session_exceptions import (
    SessionNotFoundError,
    InvalidSessionStateError,
    ExtendedModeNotAllowedError,
)


class ExtendSessionUseCase:
    def __init__(self, session_repository, flag_repository, threshold_per_day: int = 7):
        self.session_repository = session_repository
        self.flag_repository = flag_repository
        self.threshold_per_day = threshold_per_day

    async def execute(self, session_id: str, teacher_id: str) -> ExtendSessionResponse:
        session = await self.session_repository.get_by_id(session_id)
        if session is None:
            raise SessionNotFoundError(session_id)

        # Verificar si es del mismo día
        is_today = session.date == date.today()

        # Solo permitir extender si está ACTIVE o si es de hoy (puede reopen)
        if session.status.value not in ("ACTIVE", "FINISHED"):
            raise ExtendedModeNotAllowedError()

        if not is_today:
            raise ExtendedModeNotAllowedError("Cannot extend sessions from past days")

        if session.extended_mode and session.status.value == "FINISHED":
            raise ExtendedModeNotAllowedError("Session already extended")

        # Solo permitir extendido si el QR expiró o está por expirar (1 min antes)
        if session.closes_at and session.closes_at > datetime.now():
            raise ExtendedModeNotAllowedError()

        # Verificar umbral del teacher hoy
        today = date.today()
        extensions_today = await self.flag_repository.count_extensions_today(teacher_id, today)

        if extensions_today >= self.threshold_per_day:
            raise ExtendedModeNotAllowedError()

        # Reabrir si estaba FINISHED
        if session.status.value == "FINISHED":
            from src.infrastructure.models.session_models import SessionStatus
            await self.session_repository.reopen(session_id)

        # Extender 5 minutos
        session = await self.session_repository.extend(session_id, 5)

        # Crear flag
        await self.flag_repository.create_flag(
            id_teacher=teacher_id,
            reason="EXTENDED_MODE",
            session_id=session_id,
        )

        return ExtendSessionResponse(
            id_session=session.id_session,
            extended_mode=session.extended_mode,
            qr_expires=session.closes_at.isoformat() if session.closes_at else None,
            extensions_today=extensions_today + 1,
        )