class InvalidCredentialsError(Exception):
    def __init__(self) -> None:
        super().__init__("Invalid email or password")


class UserNotFoundError(Exception):
    def __init__(self, email: str) -> None:
        super().__init__(f"User with email '{email}' not found")


class InactiveUserError(Exception):
    def __init__(self) -> None:
        super().__init__("User account has been deactivated")
