from fastapi import APIRouter, Depends, HTTPException, status

from src.application.dtos.auth_dto import LoginRequest, LoginResponse
from src.application.use_cases.login_use_case import LoginUseCase
from src.api.dependencies import get_login_use_case
from src.domain.exceptions.auth_exceptions import InactiveUserError, InvalidCredentialsError

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
