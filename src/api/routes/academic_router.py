from fastapi import APIRouter, Depends

from src.application.dtos.academic_dto import TodayClassesResponse
from src.application.use_cases.get_today_classes_use_case import GetTodayClassesUseCase
from src.api.dependencies import get_today_classes_use_case, get_current_teacher_id


router = APIRouter(prefix="/academic", tags=["Academic"])


@router.get("/my-classes", response_model=TodayClassesResponse)
async def get_my_classes(
    teacher_id: str = Depends(get_current_teacher_id),
    use_case: GetTodayClassesUseCase = Depends(get_today_classes_use_case),
) -> TodayClassesResponse:
    """
    Obtiene las clases del teacher para el día de hoy.
    
    Retorna lista de clases con estado (ACTIVE/FUTURE/PAST) y
    disponibilidad de QR.
    """
    return await use_case.execute(teacher_id)