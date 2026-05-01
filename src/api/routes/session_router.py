from fastapi import APIRouter, Depends, HTTPException, status

from src.application.dtos.session_dto import (
    CreateSessionRequest,
    SessionResponse,
    ActivateSessionRequest,
    ExtendSessionResponse,
    AttendanceSummaryResponse,
)
from src.application.use_cases.create_session_use_case import CreateSessionUseCase
from src.application.use_cases.activate_session_use_case import ActivateSessionUseCase
from src.application.use_cases.extend_session_use_case import ExtendSessionUseCase
from src.application.use_cases.get_attendance_summary_use_case import GetAttendanceSummaryUseCase
from src.application.use_cases.finish_session_use_case import FinishSessionUseCase
from src.api.dependencies import get_current_teacher_id, get_session
from src.domain.exceptions.session_exceptions import (
    SessionAlreadyExistsError,
    ClassNotFoundError,
    UnauthorizedSessionAccessError,
    SessionNotFoundError,
    InvalidSessionStateError,
    SessionDateInPastError,
    ExtendedModeNotAllowedError,
)
from src.infrastructure.repositories.session_repository_impl import SQLAlchemySessionRepository
from src.infrastructure.repositories.attendance_repository_impl import SQLAlchemyAttendanceRepository
from src.infrastructure.repositories.academic_repository import AcademicRepository

router = APIRouter(prefix="/sessions", tags=["Sessions"])


@router.post("", response_model=SessionResponse)
async def create_session(
    request: CreateSessionRequest,
    teacher_id: str = Depends(get_current_teacher_id),
    session_factory=Depends(get_session),
):
    from src.infrastructure.repositories.academic_repository import AcademicRepository
    from src.infrastructure.repositories.session_repository_impl import SQLAlchemySessionRepository

    session_repo = SQLAlchemySessionRepository(session_factory)
    class_repo = AcademicRepository(session_factory)

    use_case = CreateSessionUseCase(session_repo, class_repo)
    try:
        return await use_case.execute(request, teacher_id)
    except SessionAlreadyExistsError as e:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT, 
            detail={"message": str(e), "session_id": e.session_id}
        )
    except ClassNotFoundError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
    except UnauthorizedSessionAccessError as e:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail=str(e))
    except SessionDateInPastError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))


@router.post("/{session_id}/activate", response_model=SessionResponse)
async def activate_session(
    session_id: str,
    request: ActivateSessionRequest,
    teacher_id: str = Depends(get_current_teacher_id),
    session_factory=Depends(get_session),
):
    from src.infrastructure.repositories.session_repository_impl import SQLAlchemySessionRepository
    from src.infrastructure.repositories.academic_repository import AcademicRepository
    from src.infrastructure.repositories.teacher_flag_repository_impl import SQLAlchemyTeacherFlagRepository

    session_repo = SQLAlchemySessionRepository(session_factory)
    academic_repo = AcademicRepository(session_factory)
    flag_repo = SQLAlchemyTeacherFlagRepository(session_factory)

    use_case = ActivateSessionUseCase(session_repo, academic_repo, flag_repo)
    try:
        return await use_case.execute(session_id, teacher_id, request.qr_duration_minutes)
    except SessionNotFoundError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
    except InvalidSessionStateError as e:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=str(e))


@router.post("/{session_id}/extend", response_model=ExtendSessionResponse)
async def extend_session(
    session_id: str,
    teacher_id: str = Depends(get_current_teacher_id),
    session_factory=Depends(get_session),
):
    from src.infrastructure.repositories.session_repository_impl import SQLAlchemySessionRepository
    from src.infrastructure.repositories.teacher_flag_repository_impl import SQLAlchemyTeacherFlagRepository

    session_repo = SQLAlchemySessionRepository(session_factory)
    flag_repo = SQLAlchemyTeacherFlagRepository(session_factory)

    use_case = ExtendSessionUseCase(session_repo, flag_repo)
    try:
        return await use_case.execute(session_id, teacher_id)
    except SessionNotFoundError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
    except ExtendedModeNotAllowedError as e:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=str(e))


@router.get("/{session_id}/attendance", response_model=AttendanceSummaryResponse)
async def get_session_attendance(
    session_id: str,
    teacher_id: str = Depends(get_current_teacher_id),
    session_factory=Depends(get_session),
):
    session_repo = SQLAlchemySessionRepository(session_factory)
    attendance_repo = SQLAlchemyAttendanceRepository(session_factory)
    academic_repo = AcademicRepository(session_factory)

    use_case = GetAttendanceSummaryUseCase(session_repo, attendance_repo, academic_repo)
    try:
        return await use_case.execute(session_id)
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))


@router.post("/{session_id}/finish")
async def finish_session(
    session_id: str,
    teacher_id: str = Depends(get_current_teacher_id),
    session_factory=Depends(get_session),
):
    session_repo = SQLAlchemySessionRepository(session_factory)
    attendance_repo = SQLAlchemyAttendanceRepository(session_factory)
    academic_repo = AcademicRepository(session_factory)

    use_case = FinishSessionUseCase(session_repo, attendance_repo, academic_repo)
    try:
        return await use_case.execute(session_id, teacher_id)
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=str(e))