from abc import ABC, abstractmethod
from datetime import date, datetime, time
from typing import Protocol

from src.infrastructure.models.session_models import Session


class SessionRepositoryPort(ABC):
    @abstractmethod
    async def get_by_id(self, session_id: str) -> Session | None:
        raise NotImplementedError

    @abstractmethod
    async def get_by_class_and_date(
        self, class_id: str, session_date: date
    ) -> Session | None:
        raise NotImplementedError

    @abstractmethod
    async def get_active_by_class(self, class_id: str) -> Session | None:
        raise NotImplementedError

    @abstractmethod
    async def create(
        self,
        id_class: str,
        id_classroom: str,
        session_date: date,
    ) -> Session:
        raise NotImplementedError

    @abstractmethod
    async def activate(
        self,
        session_id: str,
        actual_start_time: time,
        qr_token: str,
        opens_at: datetime,
        closes_at: datetime,
    ) -> Session:
        raise NotImplementedError

    @abstractmethod
    async def finish(
        self,
        session_id: str,
        actual_end_time: time,
    ) -> Session:
        raise NotImplementedError

    @abstractmethod
    async def extend(
        self,
        session_id: str,
        extension_minutes: int,
    ) -> Session:
        raise NotImplementedError