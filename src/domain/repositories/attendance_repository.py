from abc import ABC, abstractmethod
from typing import Protocol

from src.infrastructure.models.session_models import Attendance, AttendanceStatus


class AttendanceRepositoryPort(ABC):
    @abstractmethod
    async def get_by_session_and_student(
        self, session_id: str, student_id: str
    ) -> Attendance | None:
        raise NotImplementedError

    @abstractmethod
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
        raise NotImplementedError

    @abstractmethod
    async def get_by_session(self, session_id: str) -> list[Attendance]:
        raise NotImplementedError

    @abstractmethod
    async def mark_absent_by_enrollment(
        self, session_id: str, enrollment_ids: list[str]
    ) -> list[Attendance]:
        raise NotImplementedError

    @abstractmethod
    async def count_by_session_and_status(
        self, session_id: str, status: AttendanceStatus
    ) -> int:
        raise NotImplementedError