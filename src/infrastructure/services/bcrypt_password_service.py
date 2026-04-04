import bcrypt

from src.application.interfaces.password_service import PasswordServicePort


class BcryptPasswordService(PasswordServicePort):
    def hash_password(self, password: str) -> str:
        return bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()

    def verify_password(self, plain: str, hashed: str) -> bool:
        return bcrypt.checkpw(plain.encode(), hashed.encode())
