from src.application.dtos.session_dto import AttendanceSummaryResponse
from src.infrastructure.models.session_models import AttendanceStatus


class GetAttendanceSummaryUseCase:
    def __init__(self, session_repository, attendance_repository, academic_repository):
        self.session_repository = session_repository
        self.attendance_repository = attendance_repository
        self.academic_repository = academic_repository

    async def execute(self, session_id: str) -> AttendanceSummaryResponse:
        # Validar que la sesión existe
        session = await self.session_repository.get_by_id(session_id)
        if session is None:
            raise SessionNotFoundError()

        # Contar por status
        present = await self.attendance_repository.count_by_session_and_status(
            session_id, AttendanceStatus.PRESENT
        )
        absent = await self.attendance_repository.count_by_session_and_status(
            session_id, AttendanceStatus.ABSENT
        )
        late = await self.attendance_repository.count_by_session_and_status(
            session_id, AttendanceStatus.LATE
        )
        justified = await self.attendance_repository.count_by_session_and_status(
            session_id, AttendanceStatus.JUSTIFIED
        )

        # Total inscriptos
        total_enrolled = await self.academic_repository.count_enrollments_by_class(
            session.id_class
        )

        return AttendanceSummaryResponse(
            id_session=session_id,
            total_enrolled=total_enrolled,
            present=present,
            absent=absent,
            late=late,
            justified=justified,
        )


class SessionNotFoundError(Exception):
    pass