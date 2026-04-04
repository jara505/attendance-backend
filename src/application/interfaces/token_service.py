from abc import ABC, abstractmethod


class TokenServicePort(ABC):
    @abstractmethod
    def create_access_token(self, subject: str, role: str) -> str:
        raise NotImplementedError

    @abstractmethod
    def decode_token(self, token: str) -> dict:
        raise NotImplementedError
