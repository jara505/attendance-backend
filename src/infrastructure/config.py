from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    DATABASE_URL: str
    JWT_SECRET_KEY: str
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRATION_MINUTES: int

    @property
    def JWT_ALGORITHM(self) -> str:
        return self.ALGORITHM

    @property
    def JWT_EXPIRATION_MINUTES(self) -> int:
        return self.ACCESS_TOKEN_EXPIRATION_MINUTES


settings = Settings()
