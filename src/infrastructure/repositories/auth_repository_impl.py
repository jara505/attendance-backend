from sqlalchemy import select, update
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

    async def get_user_by_id(self, user_id: str) -> User | None:
        stmt = select(User).where(User.id_user == user_id)
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

    async def update_password(self, user_id: str, password_hash: str) -> None:
        stmt = (
            update(User)
            .where(User.id_user == user_id)
            .values(password_hash=password_hash, must_change_password=False)
        )
        await self._session.execute(stmt)
        await self._session.commit()
