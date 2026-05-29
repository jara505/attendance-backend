from contextlib import asynccontextmanager
from collections.abc import AsyncGenerator

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.gzip import GZipMiddleware
from fastapi.responses import ORJSONResponse

from src.infrastructure.database import engine, Base
import src.infrastructure.models  # noqa: F401
from src.api.routes.auth_router import router as auth_router
from src.api.routes.academic_router import router as academic_router
from src.api.routes.profile_router import router as profile_router
from src.api.routes.session_router import router as session_router
from src.api.routes.attendance_router import router as attendance_router
from src.api.routes.student_router import router as student_router
from src.api.routes.student_router import classes_router


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator:
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield


app = FastAPI(
    title="Attendance Backend",
    version="0.1.0",
    lifespan=lifespan,
    default_response_class=ORJSONResponse,
)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)
app.add_middleware(GZipMiddleware, minimum_size=500)

app.include_router(auth_router, prefix="/api/v1")
app.include_router(academic_router, prefix="/api/v1")
app.include_router(profile_router, prefix="/api/v1")
app.include_router(session_router, prefix="/api/v1")
app.include_router(attendance_router, prefix="/api/v1")
app.include_router(student_router, prefix="/api/v1")
app.include_router(classes_router, prefix="/api/v1")
