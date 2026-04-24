from fastapi import APIRouter, Depends, HTTPException, status

from src.application.dtos.session_dto import (
    CreateSessionRequest,
    SessionResponse,
    ActivateSessionRequest,
)
from src.application.use_cases.create_session_use_case import CreateSessionUseCase
from src.application.use_cases.activate_session_use_case import ActivateSessionUseCase
from src.api.dependencies import get_current_teacher_id, get_session
from src.domain.exceptions.session_exceptions import (
    SessionAlreadyExistsError,
    ClassNotFoundError,
    UnauthorizedSessionAccessError,
    SessionNotFoundError,
    InvalidSessionStateError,
    SessionDateInPastError,
)

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
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=str(e))
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

    session_repo = SQLAlchemySessionRepository(session_factory)

    use_case = ActivateSessionUseCase(session_repo)
    try:
        return await use_case.execute(session_id, teacher_id, request.qr_duration_minutes)
    except SessionNotFoundError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
    except InvalidSessionStateError as e:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=str(e))