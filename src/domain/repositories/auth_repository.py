from abc import ABC, abstractmethod

from src.infrastructure.models.user_models import User


class AuthRepositoryPort(ABC):
    @abstractmethod
    async def get_user_by_email(self, email: str) -> User | None:
        raise NotImplementedError
