from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from src.application.dtos.academic_dto import (
    SemesterAttendanceResponse,
    SubjectAttendanceDetail,
)
from src.application.use_cases.get_student_attendance_use_case import (
    GetStudentAttendanceUseCase,
)
from src.api.dependencies import get_session, get_current_user_id
from src.infrastructure.models import Student, User


router = APIRouter(prefix="/student/attendance", tags=["Student Attendance"])


async def get_current_student_id(
    user_id: str = Depends(get_current_user_id),
    session: AsyncSession = Depends(get_session),
) -> str:
    """
    Obtiene el id_student a partir del user_id del token.
    Verifica que el usuario sea estudiante.
    """
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


@router.get("", response_model=SemesterAttendanceResponse)
async def get_semester_attendance(
    year: int = Query(default=datetime.now().year, description="Año del semestre"),
    student_id: str = Depends(get_current_student_id),
    session: AsyncSession = Depends(get_session),
) -> SemesterAttendanceResponse:
    """
    Obtiene el resumen de asistencia por materia para un semestre.
    
    Muestra el porcentaje de asistencia y estado (OK/ALERTA) por cada materia.
    """
    use_case = GetStudentAttendanceUseCase(session)
    return await use_case.get_semester_summary(student_id, year)


@router.get("/{subject_id}", response_model=SubjectAttendanceDetail)
async def get_subject_attendance_detail(
    subject_id: str,
    month: int = Query(..., ge=1, le=12, description="Mes (1-12)"),
    year: int = Query(default=datetime.now().year, description="Año"),
    student_id: str = Depends(get_current_student_id),
    session: AsyncSession = Depends(get_session),
) -> SubjectAttendanceDetail:
    """
    Obtiene el detalle de asistencia por día para una materia específica.
    
    Muestra cada día del mes con su estado de asistencia:
    - PRESENT:Asistió
    - ABSENT:Ausente
    - LATE:Tarde
    - JUSTIFIED:Justificado
    - null:Sin clase
    """
    use_case = GetStudentAttendanceUseCase(session)
    return await use_case.get_subject_detail(student_id, subject_id, year, month)