from contextlib import asynccontextmanager
from collections.abc import AsyncGenerator

from fastapi import FastAPI

from src.infrastructure.database import engine, Base
import src.infrastructure.models  # noqa: F401
from src.api.routes.auth_router import router as auth_router


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator:
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield


app = FastAPI(title="Attendance Backend", version="0.1.0", lifespan=lifespan)
app.include_router(auth_router, prefix="/api/v1")
