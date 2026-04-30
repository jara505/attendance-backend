from datetime import datetime
from uuid import uuid4

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from src.domain.repositories.attendance_repository import AttendanceRepositoryPort
from src.infrastructure.models.session_models import (
    Attendance,
    AttendanceMethod,
    AttendanceStatus,
)
from src.infrastructure.models.class_models import Enrollment


class SQLAlchemyAttendanceRepository(AttendanceRepositoryPort):
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_by_session_and_student(
        self, session_id: str, student_id: str
    ) -> Attendance | None:
        stmt = select(Attendance).where(
            Attendance.id_session == session_id,
            Attendance.id_student == student_id,
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

    async def create(
        self,
        session_id: str,
        student_id: str,
        status: AttendanceStatus,
        method: str,
        ip_address: str | None = None,
        latitude: float | None = None,
        longitude: float | None = None,
    ) -> Attendance:
        attendance = Attendance(
            id_attendance=str(uuid4()),
            id_session=session_id,
            id_student=student_id,
            status=status,
            method=AttendanceMethod(method),
            record_date=datetime.now(),
            ip_address=ip_address,
            latitude=latitude,
            longitude=longitude,
        )
        self._session.add(attendance)
        await self._session.commit()
        await self._session.refresh(attendance)
        return attendance

    async def get_by_session(self, session_id: str) -> list[Attendance]:
        stmt = select(Attendance).where(Attendance.id_session == session_id)
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def mark_absent_by_enrollment(
        self, session_id: str, enrollment_ids: list[str]
    ) -> list[Attendance]:
        # Obtener student IDs de los enrollments
        stmt = select(Enrollment.id_student).where(
            Enrollment.id_class == enrollment_ids[0] if enrollment_ids else ""
        )
        result = await self._session.execute(stmt)
        student_ids = [r for r in result.scalars().all()]

        attendances = []
        for student_id in student_ids:
            # Verificar si ya tiene registro
            existing = await self.get_by_session_and_student(session_id, student_id)
            if existing is None:
                attendance = Attendance(
                    id_attendance=str(uuid4()),
                    id_session=session_id,
                    id_student=student_id,
                    status=AttendanceStatus.ABSENT,
                    method=None,
                    record_date=datetime.now(),
                )
                self._session.add(attendance)
                attendances.append(attendance)

        if attendances:
            await self._session.commit()
            for a in attendances:
                await self._session.refresh(a)

        return attendances

    async def count_by_session_and_status(
        self, session_id: str, status: AttendanceStatus
    ) -> int:
        stmt = select(Attendance).where(
            Attendance.id_session == session_id,
            Attendance.status == status,
        )
        result = await self._session.execute(stmt)
        return len(list(result.scalars().all()))