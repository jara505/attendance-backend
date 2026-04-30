from datetime import datetime, time

from src.infrastructure.models.session_models import SessionStatus, AttendanceMethod, AttendanceStatus


class FinishSessionUseCase:
    def __init__(self, session_repository, attendance_repository, academic_repository):
        self.session_repository = session_repository
        self.attendance_repository = attendance_repository
        self.academic_repository = academic_repository

    async def execute(self, session_id: str,teacher_id: str) -> dict:
        # Validar que la sesión existe
        session = await self.session_repository.get_by_id(session_id)
        if session is None:
            raise SessionNotFoundError()

        # Validar estado (solo puede finish si está ACTIVE)
        if session.status != SessionStatus.ACTIVE:
            raise InvalidSessionStateError(session.status.value)

        # TODO: Validar que el teacher es owner de la clase

        # 1. Obtener todos los inscriptos en la clase
        enrollments = await self.academic_repository.get_enrollments_by_class(
            session.id_class
        )
        enrollment_ids = [e.id_enrollment for e in enrollments]

        # 2. Obtener attendances registradas
        attendances = await self.attendance_repository.get_by_session(session_id)
        registered_student_ids = {a.id_student for a in attendances}

        # 3. Marcar ausentes a los NO registrados
        absent_count = 0
        for enrollment in enrollments:
            if enrollment.id_student not in registered_student_ids:
                # Crear registro de ausente
                await self.attendance_repository.create(
                    session_id=session_id,
                    student_id=enrollment.id_student,
                    status=AttendanceStatus.ABSENT,
                    method="MANUAL",
                )
                absent_count += 1

        # 4. Cerrar la sesión
        session = await self.session_repository.finish(
            session_id=session_id,
            actual_end_time=datetime.now().time(),
        )

        return {
            "id_session": session.id_session,
            "status": session.status.value,
            "absent_count": absent_count,
            "present_count": len(attendances),
        }


class SessionNotFoundError(Exception):
    pass


class InvalidSessionStateError(Exception):
    pass