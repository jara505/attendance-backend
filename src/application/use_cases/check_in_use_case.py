from datetime import datetime

from src.application.dtos.session_dto import CheckInResponse, AttendanceStatusEnum
from src.infrastructure.models.session_models import (
    AttendanceStatus,
    SessionStatus,
)


class CheckInUseCase:
    def __init__(self, session_repository, attendance_repository):
        self.session_repository = session_repository
        self.attendance_repository = attendance_repository

    async def execute(
        self,
        qr_token: str,
        student_id: str,
        ip_address: str | None = None,
        latitude: float | None = None,
        longitude: float | None = None,
    ) -> CheckInResponse:
        # Buscar sesión por QR token
        session = await self.session_repository.get_by_qr_token(qr_token)
        if session is None:
            raise InvalidQRTokenError()

        # Validar que la sesión está activa
        if session.status != SessionStatus.ACTIVE:
            raise SessionNotActiveError(session.status.value)

        # Validar que el QR no haya expirado
        if session.closes_at and datetime.now() > session.closes_at:
            raise QRExpiredError()

        # Verificar si ya tiene asistencia registrada
        existing = await self.attendance_repository.get_by_session_and_student(
            session.id_session, student_id
        )
        if existing is not None:
            raise AlreadyCheckedInError()

        # Determinar si es tardanza (más de 15 min después del inicio)
        status = AttendanceStatus.PRESENT
        if session.actual_start_time:
            start_minutes = (
                session.actual_start_time.hour * 60 + session.actual_start_time.minute
            )
            now_minutes = datetime.now().hour * 60 + datetime.now().minute
            if now_minutes - start_minutes > 15:
                status = AttendanceStatus.LATE

        # Registrar asistencia
        attendance = await self.attendance_repository.create(
            session_id=session.id_session,
            student_id=student_id,
            status=status,
            method="QR",
            ip_address=ip_address,
            latitude=latitude,
            longitude=longitude,
        )

        return CheckInResponse(
            id_attendance=attendance.id_attendance,
            id_session=attendance.id_session,
            id_student=attendance.id_student,
            status=AttendanceStatusEnum(attendance.status.value),
            record_date=attendance.record_date.isoformat(),
        )


class InvalidQRTokenError(Exception):
    pass


class SessionNotActiveError(Exception):
    pass


class QRExpiredError(Exception):
    pass


class AlreadyCheckedInError(Exception):
    pass