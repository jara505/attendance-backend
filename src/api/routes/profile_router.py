from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel

from src.api.dependencies import get_current_user_id, get_user_profile_use_case, get_session
from src.application.use_cases.get_user_profile_use_case import GetUserProfileUseCase
from src.infrastructure.models.user_models import User, Teacher, Student, UserRole
from sqlalchemy import select

router = APIRouter(prefix="/profile", tags=["profile"])


class PhotoUpdateRequest(BaseModel):
    url: str


@router.get("/me")
async def get_my_profile(
    user_id: str = Depends(get_current_user_id),
    use_case: GetUserProfileUseCase = Depends(get_user_profile_use_case),
):
    profile = await use_case.execute(user_id)
    if profile is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User profile not found",
        )
    return profile


@router.put("/photo")
async def update_photo(
    photo_request: PhotoUpdateRequest,
    user_id: str = Depends(get_current_user_id),
    session=Depends(get_session),
):
    result = await session.execute(
        select(User).where(User.id_user == user_id)
    )
    user = result.scalar_one_or_none()

    if user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )

    if user.role == UserRole.TEACHER:
        result = await session.execute(
            select(Teacher).where(Teacher.id_user == user_id)
        )
        teacher = result.scalar_one_or_none()
        if teacher is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Teacher profile not found",
            )
        teacher.photo_url = photo_request.url
    elif user.role == UserRole.STUDENT:
        result = await session.execute(
            select(Student).where(Student.id_user == user_id)
        )
        student = result.scalar_one_or_none()
        if student is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Student profile not found",
            )
        student.photo_url = photo_request.url
    else:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Admin users do not have photo",
        )

    await session.commit()
    return {"photo_url": photo_request.url}