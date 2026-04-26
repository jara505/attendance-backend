class SessionNotFoundError(Exception):
    def __init__(self, session_id: str) -> None:
        super().__init__(f"Session '{session_id}' not found")


class ClassNotFoundError(Exception):
    def __init__(self, class_id: str) -> None:
        super().__init__(f"Class '{class_id}' not found")


class UnauthorizedSessionAccessError(Exception):
    def __init__(self) -> None:
        super().__init__("Only the class teacher can manage this session")


class InvalidSessionStateError(Exception):
    def __init__(self, current: str, expected: str) -> None:
        super().__init__(f"Session state must be '{expected}', currently '{current}'")


class SessionAlreadyActiveError(Exception):
    def __init__(self) -> None:
        super().__init__("Session is already active")


class SessionAlreadyFinishedError(Exception):
    def __init__(self) -> None:
        super().__init__("Session is already finished")


class SessionAlreadyExistsError(Exception):
    def __init__(self, class_id: str, session_date: str) -> None:
        super().__init__(f"Session already exists for class '{class_id}' on date '{session_date}'")


class ExtendedModeNotAllowedError(Exception):
    def __init__(self) -> None:
        super().__init__("Extended mode not allowed: session not active or already extended")


class QRCodeExpiredError(Exception):
    def __init__(self) -> None:
        super().__init__("QR code has expired")


class QRCodeNotYetValidError(Exception):
    def __init__(self) -> None:
        super().__init__("QR code is not yet valid")


class SessionDateInPastError(Exception):
    def __init__(self, session_date: str) -> None:
        super().__init__(f"Cannot create session for past date '{session_date}'")