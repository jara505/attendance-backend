from collections.abc import AsyncGenerator

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from src.application.use_cases.change_password_use_case import ChangePasswordUseCase
from src.application.use_cases.get_today_classes_use_case import GetTodayClassesUseCase
from src.application.use_cases.get_user_profile_use_case import GetUserProfileUseCase
from src.application.use_cases.login_use_case import LoginUseCase
from src.infrastructure.database import async_session
from src.infrastructure.models.user_models import Teacher, User, UserRole
from src.infrastructure.repositories.academic_repository import AcademicRepository
from src.infrastructure.repositories.auth_repository_impl import SQLAlchemyAuthRepository
from src.infrastructure.services.bcrypt_password_service import BcryptPasswordService
from src.infrastructure.services.jwt_token_service import JwtTokenService

_bearer_scheme = HTTPBearer()
_token_service = JwtTokenService()


async def get_session() -> AsyncGenerator[AsyncSession, None]:
    async with async_session() as session:
        yield session


async def get_current_user_id(
    credentials: HTTPAuthorizationCredentials = Depends(_bearer_scheme),
) -> str:
    try:
        payload = _token_service.decode_token(credentials.credentials)
        user_id: str | None = payload.get("sub")
        if user_id is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token payload",
            )
        return user_id
    except Exception as exc:
        if isinstance(exc, HTTPException):
            raise
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
        ) from exc


async def get_login_use_case(
    session: AsyncSession = Depends(get_session),
) -> LoginUseCase:
    return LoginUseCase(
        auth_repository=SQLAlchemyAuthRepository(session),
        password_service=BcryptPasswordService(),
        token_service=JwtTokenService(),
    )


async def get_change_password_use_case(
    session: AsyncSession = Depends(get_session),
) -> ChangePasswordUseCase:
    return ChangePasswordUseCase(
        auth_repository=SQLAlchemyAuthRepository(session),
        password_service=BcryptPasswordService(),
    )


async def get_today_classes_use_case(
    session: AsyncSession = Depends(get_session),
) -> GetTodayClassesUseCase:
    return GetTodayClassesUseCase(
        repository=AcademicRepository(session),
    )


async def get_current_teacher_id(
    user_id: str = Depends(get_current_user_id),
    session: AsyncSession = Depends(get_session),
) -> str:
    """
    Obtiene el id_teacher a partir del user_id del token.
    Verifica en una sola consulta que el usuario exista, sea TEACHER y
    tenga perfil de Teacher activo.
    """
    stmt = (
        select(Teacher.id_teacher)
        .join(User, User.id_user == Teacher.id_user)
        .where(
            User.id_user == user_id,
            User.role == UserRole.TEACHER,
            User.deleted_at.is_(None),
            Teacher.deleted_at.is_(None),
        )
    )
    teacher_id = (await session.execute(stmt)).scalar_one_or_none()

    if teacher_id is None:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only teachers can access this resource",
        )

    return teacher_id


def get_user_profile_use_case(
    session: AsyncSession = Depends(get_session),
) -> GetUserProfileUseCase:
    return GetUserProfileUseCase(session)
