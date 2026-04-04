from abc import ABC, abstractmethod


class PasswordServicePort(ABC):
    @abstractmethod
    def hash_password(self, password: str) -> str:
        raise NotImplementedError

    @abstractmethod
    def verify_password(self, plain: str, hashed: str) -> bool:
        raise NotImplementedError
