from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from src.application.dtos.session_dto import (
    CheckInRequest,
    CheckInResponse,
    AttendanceSummaryResponse,
)
from src.application.use_cases.check_in_use_case import (
    CheckInUseCase,
    InvalidQRTokenError,
    SessionNotActiveError,
    QRExpiredError,
    AlreadyCheckedInError,
)
from src.application.use_cases.get_attendance_summary_use_case import (
    GetAttendanceSummaryUseCase,
    SessionNotFoundError,
)
from src.application.use_cases.finish_session_use_case import (
    FinishSessionUseCase,
    SessionNotFoundError as FinishSessionNotFoundError,
    InvalidSessionStateError as FinishInvalidSessionStateError,
)
from src.api.dependencies import get_session, get_current_user_id
from src.infrastructure.repositories.session_repository_impl import SQLAlchemySessionRepository
from src.infrastructure.repositories.attendance_repository_impl import SQLAlchemyAttendanceRepository
from src.infrastructure.repositories.academic_repository import AcademicRepository
from src.infrastructure.models import Student, User


router = APIRouter(prefix="/attendance", tags=["Attendance"])


async def get_current_student_id(
    user_id: str = Depends(get_current_user_id),
    session: AsyncSession = Depends(get_session),
) -> str:
    """Obtiene el id_student a partir del user_id del token."""
    stmt = (
        select(Student.id_student)
        .join(User, User.id_user == Student.id_user)
        .where(
            User.id_user == user_id,
            User.deleted_at.is_(None),
            Student.deleted_at.is_(None),
        )
    )
    student_id = (await session.execute(stmt)).scalar_one_or_none()

    if student_id is None:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only students can access this resource",
        )

    return student_id


class QRCheckInRequest(BaseModel):
    qr_token: str


@router.post("/check-in", response_model=CheckInResponse)
async def check_in(
    request: QRCheckInRequest,
    student_id: str = Depends(get_current_student_id),
    session_factory=Depends(get_session),
):
    session_repo = SQLAlchemySessionRepository(session_factory)
    attendance_repo = SQLAlchemyAttendanceRepository(session_factory)

    use_case = CheckInUseCase(session_repo, attendance_repo)
    try:
        return await use_case.execute(
            qr_token=request.qr_token,
            student_id=student_id,
        )
    except InvalidQRTokenError:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="QR token inválido",
        )
    except SessionNotActiveError as e:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=f"La sesión no está activa: {e}",
        )
    except QRExpiredError:
        raise HTTPException(
            status_code=status.HTTP_410_GONE,
            detail="El QR ha expirado",
        )
    except AlreadyCheckedInError:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Ya registraste tu asistencia",
        )


@router.get("/session/{session_id}/summary", response_model=AttendanceSummaryResponse)
async def get_attendance_summary(
    session_id: str,
    session_factory=Depends(get_session),
):
    session_repo = SQLAlchemySessionRepository(session_factory)
    attendance_repo = SQLAlchemyAttendanceRepository(session_factory)
    academic_repo = AcademicRepository(session_factory)

    use_case = GetAttendanceSummaryUseCase(session_repo, attendance_repo, academic_repo)
    try:
        return await use_case.execute(session_id)
    except SessionNotFoundError:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Sesión no encontrada",
        )
