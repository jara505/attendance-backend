from src.application.dtos.academic_dto import (
    TeacherClassesListResponse,
    TeacherClassItem,
    ClassAttendanceResponse,
    StudentAttendanceSummary,
)
from src.infrastructure.repositories.academic_repository import AcademicRepository


class GetTeacherAttendanceUseCase:
    def __init__(self, repository: AcademicRepository) -> None:
        self._repository = repository

    async def get_classes(self, teacher_id: str) -> TeacherClassesListResponse:
        """Lista todas las clases del teacher."""
        classes = await self._repository.get_teacher_classes(teacher_id)

        items = [
            TeacherClassItem(
                id_class=cls.id_class,
                subject=cls.subject.name,
                course=cls.subject.course.name if cls.subject.course else "",
                group=cls.group.code if cls.group else "",
                year=cls.period.year,
                cycle=cls.period.cycle,
                total_students=len(cls.enrollments),
            )
            for cls in classes
        ]

        return TeacherClassesListResponse(classes=items)

    async def get_class_attendance(
        self, class_id: str, teacher_id: str
    ) -> ClassAttendanceResponse:
        """Asistencia detallada de todos los alumnos en una clase."""
        cls = await self._repository.get_class_with_details(class_id)
        if cls is None:
            raise ValueError("Class not found")
        if cls.id_teacher != teacher_id:
            raise PermissionError("This class does not belong to you")

        # Conteos agregados: un solo query GROUP BY
        attendance_counts = await self._repository.get_attendance_counts_by_class(
            class_id
        )
        session_count = await self._repository.get_class_sessions_count(class_id)

        students = []
        for enrollment in cls.enrollments:
            student = enrollment.student
            counts = attendance_counts.get(student.id_student, {})

            present = counts.get("PRESENT", 0)
            absent = counts.get("ABSENT", 0)
            late = counts.get("LATE", 0)
            justified = counts.get("JUSTIFIED", 0)
            total = present + absent + late + justified

            percentage = (
                round((present + late + justified) / total * 100, 1)
                if total > 0
                else 100.0
            )

            students.append(
                StudentAttendanceSummary(
                    id_student=student.id_student,
                    first_name=student.first_name,
                    last_name=student.last_name,
                    student_card=student.student_card,
                    present=present,
                    absent=absent,
                    late=late,
                    justified=justified,
                    total=total,
                    percentage=percentage,
                )
            )

        return ClassAttendanceResponse(
            id_class=cls.id_class,
            subject=cls.subject.name,
            course=cls.subject.course.name if cls.subject.course else "",
            group=cls.group.code if cls.group else "",
            year=cls.period.year,
            cycle=cls.period.cycle,
            total_sessions=session_count,
            total_students=len(cls.enrollments),
            students=students,
        )
