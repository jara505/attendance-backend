from uuid import uuid4
from datetime import date

from src.application.dtos.session_dto import SessionResponse, SessionStatusEnum
from src.domain.exceptions.session_exceptions import (
    SessionNotFoundError,
    UnauthorizedSessionAccessError,
    InvalidSessionStateError,
)
from src.infrastructure.models.session_models import SessionStatus


class ActivateSessionUseCase:
    def __init__(self, session_repository, academic_repository, flag_repository=None):
        self.session_repository = session_repository
        self.academic_repository = academic_repository
        self.flag_repository = flag_repository

    async def execute(self, session_id: str, teacher_id: str, qr_duration_minutes: int = 10) -> SessionResponse:
        # Obtener sesión
        session = await self.session_repository.get_by_id(session_id)
        if session is None:
            raise SessionNotFoundError(session_id)

        # Verificar si es del mismo día
        is_today = session.date == date.today()

        # Si ya está ACTIVE, devolver el QR actual sin regenerar
        if session.status == SessionStatus.ACTIVE:
            total_students = await self.academic_repository.count_enrollments_by_class(session.id_class)
            return SessionResponse(
                id_session=session.id_session,
                id_class=session.id_class,
                id_classroom=session.id_classroom,
                date=session.date,
                status=SessionStatusEnum(session.status.value),
                actual_start_time=session.actual_start_time,
                qr_token=session.qr_token,
                qr_expires=session.closes_at.isoformat() if session.closes_at else None,
                total_students=total_students,
            )

        # Solo permitir activar si está SCHEDULED o si es FINISHED de hoy (reabrir)
        if session.status not in (SessionStatus.SCHEDULED, SessionStatus.FINISHED):
            raise InvalidSessionStateError(
                session.status.value, 
                f"{SessionStatus.SCHEDULED.value} or {SessionStatus.FINISHED.value}"
            )

        if not is_today:
            raise InvalidSessionStateError(session.status.value, "past days")

        # Si está FINISHED, reopen + crear flag para modo extendido
        if session.status == SessionStatus.FINISHED:
            was_extended = session.extended_mode
            
            await self.session_repository.reopen(session_id)
            
            # Si NO estaba extendido, marcar ahora como extendido + crear flag
            if not was_extended and self.flag_repository:
                await self.session_repository.update_extended_mode(session_id, True)
                await self.flag_repository.create_flag(
                    id_teacher=teacher_id,
                    reason="REOPEN_MODE",
                    session_id=session_id,
                )

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