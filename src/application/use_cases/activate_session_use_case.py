from uuid import uuid4

from src.application.dtos.session_dto import SessionResponse
from src.domain.exceptions.session_exceptions import (
    SessionNotFoundError,
    UnauthorizedSessionAccessError,
    InvalidSessionStateError,
)


class ActivateSessionUseCase:
    def __init__(self, session_repository, academic_repository):
        self.session_repository = session_repository
        self.academic_repository = academic_repository

    async def execute(self, session_id: str, teacher_id: str, qr_duration_minutes: int = 10) -> SessionResponse:
        # Obtener sesión
        session = await self.session_repository.get_by_id(session_id)
        if session is None:
            raise SessionNotFoundError(session_id)

        # Validar estado
        from src.infrastructure.models.session_models import SessionStatus
        if session.status != SessionStatus.SCHEDULED:
            raise InvalidSessionStateError(session.status.value, SessionStatus.SCHEDULED.value)

        # TODO: Verificar que el teacher es dueño de la clase

        # Generar QR token
        qr_token = str(uuid4())

        # Activar
        import datetime as dt
        now = dt.datetime.now()
        opens_at = now
        closes_at = now + dt.timedelta(minutes=qr_duration_minutes)

        from datetime import time
        session = await self.session_repository.activate(
            session_id=session_id,
            actual_start_time=now.time(),
            qr_token=qr_token,
            opens_at=opens_at,
            closes_at=closes_at,
        )

        # Obtener total de estudiantes inscriptos
        total_students = await self.academic_repository.count_enrollments_by_class(session.id_class)

        return SessionResponse(
            id_session=session.id_session,
            id_class=session.id_class,
            id_classroom=session.id_classroom,
            date=session.date,
            status=session.status,
            actual_start_time=session.actual_start_time,
            qr_token=session.qr_token,
            qr_expires=session.closes_at.isoformat() if session.closes_at else None,
            total_students=total_students,
        )