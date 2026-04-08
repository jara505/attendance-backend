from src.application.dtos.auth_dto import ChangePasswordRequest, ChangePasswordResponse
from src.application.interfaces.password_service import PasswordServicePort
from src.domain.exceptions.auth_exceptions import (
    InvalidCredentialsError,
    SamePasswordError,
    UserNotFoundError,
)
from src.domain.repositories.auth_repository import AuthRepositoryPort


class ChangePasswordUseCase:
    def __init__(
        self,
        auth_repository: AuthRepositoryPort,
        password_service: PasswordServicePort,
    ) -> None:
        self._auth_repository = auth_repository
        self._password_service = password_service

    async def execute(self, user_id: str, request: ChangePasswordRequest) -> ChangePasswordResponse:
        user = await self._auth_repository.get_user_by_id(user_id)
        if not user:
            raise UserNotFoundError(user_id)

        if not self._password_service.verify_password(request.current_password, user.password_hash):
            raise InvalidCredentialsError

        if self._password_service.verify_password(request.new_password, user.password_hash):
            raise SamePasswordError

        new_hash = self._password_service.hash_password(request.new_password)
        await self._auth_repository.update_password(user.id_user, new_hash)

        return ChangePasswordResponse(message="Password changed successfully")
