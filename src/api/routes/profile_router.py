from fastapi import APIRouter, Depends

from src.api.dependencies import get_current_user_id, get_user_profile_use_case
from src.application.use_cases.get_user_profile_use_case import GetUserProfileUseCase


router = APIRouter(prefix="/profile", tags=["Profile"])


@router.get("/me")
async def get_my_profile(
    user_id: str = Depends(get_current_user_id),
    use_case: GetUserProfileUseCase = Depends(get_user_profile_use_case),
) -> dict:
    """
    Get current user profile.
    Returns teacher, student, or admin specific data.
    """
    profile = await use_case.execute(user_id)
    if profile is None:
        from fastapi import HTTPException, status
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )
    return profile