from fastapi import APIRouter, Depends, HTTPException, status

from src.application.dtos.auth_dto import (
    ChangePasswordRequest,
    ChangePasswordResponse,
    LoginRequest,
    LoginResponse,
)
from src.application.use_cases.change_password_use_case import ChangePasswordUseCase
from src.application.use_cases.login_use_case import LoginUseCase
from src.api.dependencies import get_change_password_use_case, get_current_user_id, get_login_use_case
from src.domain.exceptions.auth_exceptions import (
    InactiveUserError,
    InvalidCredentialsError,
    SamePasswordError,
    UserNotFoundError,
)

router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.post("/login", response_model=LoginResponse)
async def login(
    request: LoginRequest,
    use_case: LoginUseCase = Depends(get_login_use_case),
) -> LoginResponse:
    try:
        return await use_case.execute(request)
    except InvalidCredentialsError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password",
        )
    except InactiveUserError:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="User account has been deactivated",
        )


@router.post("/change-password", response_model=ChangePasswordResponse)
async def change_password(
    request: ChangePasswordRequest,
    user_id: str = Depends(get_current_user_id),
    use_case: ChangePasswordUseCase = Depends(get_change_password_use_case),
) -> ChangePasswordResponse:
    try:
        return await use_case.execute(user_id, request)
    except InvalidCredentialsError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Current password is incorrect",
        )
    except SamePasswordError:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="New password must be different from the current password",
        )
    except UserNotFoundError:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )
