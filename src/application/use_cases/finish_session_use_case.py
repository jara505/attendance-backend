from datetime import datetime, time, date

from src.infrastructure.models.session_models import (
    SessionStatus,
    AttendanceStatus,
)


class FinishSessionUseCase:
    def __init__(self, session_repository, attendance_repository, academic_repository):
        self.session_repository = session_repository
        self.attendance_repository = attendance_repository
        self.academic_repository = academic_repository

    async def execute(self, session_id: str, teacher_id: str) -> dict:
        # Validar que la sesión existe
        session = await self.session_repository.get_by_id(session_id)
        if session is None:
            raise SessionNotFoundError()

        # Verificar si es del mismo día
        is_today = session.date == date.today()

        # Solo permitir finish si está ACTIVE o si es de hoy
        if session.status not in (SessionStatus.ACTIVE, SessionStatus.FINISHED):
            raise InvalidSessionStateError(session.status.value)

        if not is_today:
            raise InvalidSessionStateError("Cannot finish sessions from past days")

        # Si ya está FINISHED, no hacer nada (ya fue procesada)
        if session.status == SessionStatus.FINISHED:
            attendances = await self.attendance_repository.get_by_session(session_id)
            return {
                "id_session": session.id_session,
                "status": session.status.value,
                "absent_count": 0,
                "present_count": len(attendances),
            }

        # TODO: Validar que el teacher es owner de la clase

        # 1. Obtener todos los inscriptos en la clase
        enrollments = await self.academic_repository.get_enrollments_by_class(
            session.id_class
        )

        # 2. Obtener attendances registradas
        attendances = await self.attendance_repository.get_by_session(session_id)
        registered_student_ids = {a.id_student for a in attendances}

        # 3. Marcar como PENDING a los NO registrados
        pending_count = 0
        for enrollment in enrollments:
            if enrollment.id_student not in registered_student_ids:
                # Queda en espera — el docente decide después
                await self.attendance_repository.create(
                    session_id=session_id,
                    student_id=enrollment.id_student,
                    status=AttendanceStatus.PENDING,
                    method=None,
                )
                pending_count += 1

        # 4. Cerrar la sesión
        session = await self.session_repository.finish(
            session_id=session_id,
            actual_end_time=datetime.now().time(),
        )

        return {
            "id_session": session.id_session,
            "status": session.status.value,
            "pending_count": pending_count,
            "present_count": len(attendances),
        }


class SessionNotFoundError(Exception):
    pass


class InvalidSessionStateError(Exception):
    pass
