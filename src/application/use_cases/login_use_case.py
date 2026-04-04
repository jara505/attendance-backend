from src.application.dtos.auth_dto import LoginRequest, LoginResponse
from src.application.interfaces.password_service import PasswordServicePort
from src.application.interfaces.token_service import TokenServicePort
from src.domain.exceptions.auth_exceptions import InactiveUserError, InvalidCredentialsError
from src.domain.repositories.auth_repository import AuthRepositoryPort


class LoginUseCase:
    def __init__(
        self,
        auth_repository: AuthRepositoryPort,
        password_service: PasswordServicePort,
        token_service: TokenServicePort,
    ) -> None:
        self._auth_repository = auth_repository
        self._password_service = password_service
        self._token_service = token_service

    async def execute(self, request: LoginRequest) -> LoginResponse:
        user = await self._auth_repository.get_user_by_email(request.email)
        if not user:
            raise InvalidCredentialsError
        if user.deleted_at:
            raise InactiveUserError
        if not self._password_service.verify_password(request.password, user.password_hash):
            raise InvalidCredentialsError
        access_token = self._token_service.create_access_token(user.id_user, user.role.value)
        return LoginResponse(
            access_token=access_token,
            role=user.role.value,
            must_change_password=user.must_change_password,
        )
