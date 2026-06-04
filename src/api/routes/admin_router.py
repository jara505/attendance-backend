from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.orm import selectinload
from sqlalchemy.ext.asyncio import AsyncSession

from src.api.dependencies import get_session, get_current_user_id
from src.application.dtos.admin_dto import (
    UpdateScheduleRequest,
    UpdateScheduleResponse,
    TeacherDTO,
    ClassDTO,
    ScheduleDTO,
    TeacherClassesDTO,
)
from src.infrastructure.models.user_models import User, UserRole
from src.infrastructure.models.class_models import Class, Schedule
from src.infrastructure.models import Teacher, Subject, Group
from src.infrastructure.repositories.admin_repository import AdminRepository

router = APIRouter(prefix="/admin", tags=["Admin"])


async def require_admin(
    user_id: str = Depends(get_current_user_id),
    session: AsyncSession = Depends(get_session),
) -> str:
    """Dependency: verify the user has ADMIN role."""
    stmt = select(User.role).where(
        User.id_user == user_id,
        User.deleted_at.is_(None),
    )
    role = (await session.execute(stmt)).scalar_one_or_none()

    if role != UserRole.ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only admins can access this resource",
        )
    return user_id


@router.get("/teachers", response_model=list[TeacherDTO])
async def list_teachers(
    _admin: str = Depends(require_admin),
    session: AsyncSession = Depends(get_session),
) -> list[TeacherDTO]:
    """List all teachers with their basic info."""
    stmt = (
        select(Teacher, User)
        .join(User, User.id_user == Teacher.id_user)
        .where(User.deleted_at.is_(None))
        .order_by(Teacher.first_name)
    )
    result = await session.execute(stmt)
    teachers = []
    for t, u in result.all():
        teachers.append(TeacherDTO(
            id_teacher=t.id_teacher,
            first_name=t.first_name,
            last_name=t.last_name,
            email=u.email,
        ))
    return teachers


@router.get(
    "/teachers/{teacher_id}/classes",
    response_model=TeacherClassesDTO,
)
async def get_teacher_classes(
    teacher_id: str,
    _admin: str = Depends(require_admin),
    session: AsyncSession = Depends(get_session),
) -> TeacherClassesDTO:
    """Get all classes for a specific teacher with schedules."""
    # Get teacher info
    stmt_t = (
        select(Teacher, User)
        .join(User, User.id_user == Teacher.id_user)
        .where(Teacher.id_teacher == teacher_id)
    )
    result = await session.execute(stmt_t)
    row = result.one_or_none()
    if not row:
        raise HTTPException(status_code=404, detail="Teacher not found")
    t, u = row

    # Get classes with schedules
    stmt_c = (
        select(Class)
        .options(
            selectinload(Class.subject).selectinload(Subject.course),
            selectinload(Class.group),
            selectinload(Class.schedules),
        )
        .where(Class.id_teacher == teacher_id)
    )
    result = await session.execute(stmt_c)
    classes = result.scalars().all()

    class_dtos = []
    for cls in classes:
        schedule_dtos = [
            ScheduleDTO(
                weekday=s.weekday,
                start_time=s.start_time,
                end_time=s.end_time,
                classroom=s.id_classroom,
            )
            for s in cls.schedules
        ]
        class_dtos.append(ClassDTO(
            id_class=cls.id_class,
            subject=cls.subject.name,
            course=cls.subject.course.name if cls.subject.course else "",
            group=cls.group.code if cls.group else "",
            schedules=schedule_dtos,
        ))

    return TeacherClassesDTO(
        teacher=TeacherDTO(
            id_teacher=t.id_teacher,
            first_name=t.first_name,
            last_name=t.last_name,
            email=u.email,
        ),
        classes=class_dtos,
    )


@router.put(
    "/classes/{class_id}/schedule",
    response_model=UpdateScheduleResponse,
)
async def update_class_schedule(
    class_id: str,
    body: UpdateScheduleRequest,
    _admin: str = Depends(require_admin),
    session: AsyncSession = Depends(get_session),
) -> UpdateScheduleResponse:
    """Update a class schedule and purge all associated sessions + attendance."""
    repo = AdminRepository(session)

    cls = await session.get(Class, class_id)
    if not cls:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Class not found",
        )

    deleted = await repo.purge_sessions_and_attendance(class_id)
    await repo.update_schedule(
        class_id=class_id,
        weekday=body.weekday,
        start_time=body.start_time,
        end_time=body.end_time,
        classroom=body.classroom,
    )
    await session.commit()

    return UpdateScheduleResponse(
        id_class=class_id,
        message=f"Schedule updated and {deleted} session(s) purged",
    )
