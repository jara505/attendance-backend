from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from src.domain.repositories.auth_repository import AuthRepositoryPort
from src.infrastructure.models.user_models import User


class SQLAlchemyAuthRepository(AuthRepositoryPort):
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_user_by_email(self, email: str) -> User | None:
        stmt = select(User).where(User.email == email)
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()
