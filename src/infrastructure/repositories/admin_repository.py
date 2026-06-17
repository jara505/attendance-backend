from uuid import uuid4
from datetime import time
from sqlalchemy import text, select
from sqlalchemy.ext.asyncio import AsyncSession

from src.infrastructure.models.class_models import WeekDay, Shift, Schedule


class AdminRepository:
    def __init__(self, session: AsyncSession):
        self._session = session

    async def update_schedule(
        self,
        class_id: str,
        weekday: WeekDay,
        start_time: time,
        end_time: time,
        classroom: str | None = None,
    ) -> Schedule:
        """Update or create schedule for a class."""
        stmt = select(Schedule).where(Schedule.id_class == class_id).limit(1)
        existing = (await self._session.execute(stmt)).scalar_one_or_none()

        if existing:
            existing.weekday = weekday
            existing.start_time = start_time
            existing.end_time = end_time
            if classroom:
                existing.id_classroom = classroom
            return existing

        shift = Shift.MORNING if start_time.hour < 12 else Shift.AFTERNOON
        new_schedule = Schedule(
            id_schedule=str(uuid4()),
            id_class=class_id,
            weekday=weekday,
            start_time=start_time,
            end_time=end_time,
            shift=shift,
            id_classroom=classroom or "A101",
            end_next_day=False,
        )
        self._session.add(new_schedule)
        return new_schedule

    async def purge_sessions_and_attendance(self, class_id: str) -> int:
        """Delete all attendance records and sessions for a class.
        Returns number of deleted sessions."""
        # 1. attendance_event (FK -> attendance)
        await self._session.execute(
            text("""
                DELETE FROM attendance_event
                WHERE id_attendance IN (
                    SELECT a.id_attendance FROM attendance a
                    JOIN sessions s ON a.id_session = s.id_session
                    WHERE s.id_class = :cid
                )
            """),
            {"cid": class_id},
        )
        # 2. justification_attachment (FK -> attendance)
        await self._session.execute(
            text("""
                DELETE FROM justification_attachment
                WHERE id_attendance IN (
                    SELECT a.id_attendance FROM attendance a
                    JOIN sessions s ON a.id_session = s.id_session
                    WHERE s.id_class = :cid
                )
            """),
            {"cid": class_id},
        )
        # 3. teacher_flags (FK -> sessions)
        await self._session.execute(
            text("""
                DELETE FROM teacher_flags
                WHERE session_id IN (
                    SELECT id_session FROM sessions WHERE id_class = :cid
                )
            """),
            {"cid": class_id},
        )
        # 4. attendance (FK -> sessions)
        await self._session.execute(
            text("""
                DELETE FROM attendance
                WHERE id_session IN (
                    SELECT id_session FROM sessions WHERE id_class = :cid
                )
            """),
            {"cid": class_id},
        )
        # 5. sessions
        result = await self._session.execute(
            text("DELETE FROM sessions WHERE id_class = :cid"),
            {"cid": class_id},
        )
        return result.rowcount
