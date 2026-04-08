from abc import ABC, abstractmethod

from src.infrastructure.models.user_models import User


class AuthRepositoryPort(ABC):
    @abstractmethod
    async def get_user_by_email(self, email: str) -> User | None:
        raise NotImplementedError

    @abstractmethod
    async def get_user_by_id(self, user_id: str) -> User | None:
        raise NotImplementedError

    @abstractmethod
    async def update_password(self, user_id: str, password_hash: str) -> None:
        raise NotImplementedError
