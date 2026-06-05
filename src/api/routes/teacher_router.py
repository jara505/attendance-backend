from fastapi import APIRouter, Depends, HTTPException, status

from src.application.dtos.academic_dto import (
    TeacherClassesListResponse,
    ClassAttendanceResponse,
)
from src.api.dependencies import get_current_teacher_id, get_teacher_attendance_use_case
from src.application.use_cases.get_teacher_attendance_use_case import (
    GetTeacherAttendanceUseCase,
)

router = APIRouter(prefix="/teacher", tags=["Teacher"])


@router.get("/classes", response_model=TeacherClassesListResponse)
async def list_teacher_classes(
    teacher_id: str = Depends(get_current_teacher_id),
    use_case: GetTeacherAttendanceUseCase = Depends(get_teacher_attendance_use_case),
) -> TeacherClassesListResponse:
    """Lista todas las clases del docente autenticado."""
    return await use_case.get_classes(teacher_id)


@router.get(
    "/classes/{class_id}/attendance",
    response_model=ClassAttendanceResponse,
)
async def get_class_attendance(
    class_id: str,
    teacher_id: str = Depends(get_current_teacher_id),
    use_case: GetTeacherAttendanceUseCase = Depends(get_teacher_attendance_use_case),
) -> ClassAttendanceResponse:
    """Asistencia de todos los alumnos para una clase específica."""
    try:
        return await use_case.get_class_attendance(class_id, teacher_id)
    except ValueError:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Class not found",
        )
    except PermissionError:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This class does not belong to you",
        )
