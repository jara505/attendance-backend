from abc import ABC, abstractmethod
from datetime import date, datetime
from uuid import uuid4

from src.infrastructure.models.audit_models import FlagLevel, FlagStatus


class TeacherFlagRepositoryPort(ABC):
    @abstractmethod
    async def create_flag(
        self,
        id_teacher: str,
        reason: str,
        session_id: str,
        level: FlagLevel = FlagLevel.LOW,
    ) -> None:
        raise NotImplementedError

    @abstractmethod
    async def count_extensions_today(self, id_teacher: str, today: date) -> int:
        raise NotImplementedError