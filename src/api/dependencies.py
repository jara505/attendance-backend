from collections.abc import AsyncGenerator

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from src.application.use_cases.login_use_case import LoginUseCase
from src.infrastructure.database import async_session
from src.infrastructure.repositories.auth_repository_impl import SQLAlchemyAuthRepository
from src.infrastructure.services.bcrypt_password_service import BcryptPasswordService
from src.infrastructure.services.jwt_token_service import JwtTokenService


async def get_session() -> AsyncGenerator[AsyncSession, None]:
    async with async_session() as session:
        yield session


async def get_login_use_case(
    session: AsyncSession = Depends(get_session),
) -> LoginUseCase:
    return LoginUseCase(
        auth_repository=SQLAlchemyAuthRepository(session),
        password_service=BcryptPasswordService(),
        token_service=JwtTokenService(),
    )
