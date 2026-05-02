from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from src.infrastructure.models.user_models import User, UserRole, Teacher, Student
from src.infrastructure.models.academic_models import Course
from src.application.dtos.profile_dto import (
    TeacherProfileDTO,
    StudentProfileDTO,
    AdminProfileDTO,
)


class GetUserProfileUseCase:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def execute(self, user_id: str) -> dict:
        result = await self._session.execute(
            select(User).where(User.id_user == user_id)
        )
        user = result.scalar_one_or_none()
        
        if user is None:
            return None
        
        if user.role == UserRole.TEACHER:
            result = await self._session.execute(
                select(Teacher)
                .options(selectinload(Teacher.user))
                .where(Teacher.id_user == user_id)
            )
            teacher = result.scalar_one_or_none()
            return TeacherProfileDTO(
                email=user.email,
                role=user.role.value,
                first_name=teacher.first_name,
                last_name=teacher.last_name,
                teacher_card=teacher.teacher_card,
                photo_url=teacher.photo_url,
            ).model_dump()
        
        elif user.role == UserRole.STUDENT:
            result = await self._session.execute(
                select(Student)
                .options(
                    selectinload(Student.user),
                    selectinload(Student.course),
                )
                .where(Student.id_user == user_id)
            )
            student = result.scalar_one_or_none()
            course_name = student.course.name if student.course else None
            return StudentProfileDTO(
                email=user.email,
                role=user.role.value,
                first_name=student.first_name,
                last_name=student.last_name,
                student_card=student.student_card,
                course=course_name,
                photo_url=student.photo_url,
            ).model_dump()
        
        else:  # ADMIN
            return AdminProfileDTO(
                email=user.email,
                role=user.role.value,
            ).model_dump()