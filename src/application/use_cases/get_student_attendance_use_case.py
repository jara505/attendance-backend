from datetime import datetime, date
from collections import defaultdict

from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession

from src.application.dtos.academic_dto import (
    SemesterAttendanceResponse,
    SubjectAttendanceSummary,
    SubjectAttendanceDetail,
    DayAttendance,
)
from src.infrastructure.models import (
    Student,
    Enrollment,
    Class,
    Subject,
    Session,
    Attendance,
    Period,
)


class GetStudentAttendanceUseCase:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def get_semester_summary(
        self, student_id: str, year: int
    ) -> SemesterAttendanceResponse:
        """
        Obtiene el resumen de asistencia por materia para un semestre.
        """
        # Obtener el período activo según la fecha actual
        now = datetime.now()
        stmt_period = (
            select(Period)
            .where(Period.year == year)
            .where(Period.start_date <= now.date())
            .where(Period.end_date >= now.date())
        )
        period = (await self.session.execute(stmt_period)).scalar_one_or_none()

        # Si no hay período activo (ej. entre semestres), tomar el primero del año
        if not period:
            stmt_period = select(Period).where(Period.year == year).limit(1)
            period = (await self.session.execute(stmt_period)).scalar_one_or_none()

        if not period:
            return SemesterAttendanceResponse(semester=str(year), courses=[])

        # Obtener las materias del estudiante
        stmt_enrollments = select(Enrollment.id_class).where(
            Enrollment.id_student == student_id
        )
        result = await self.session.execute(stmt_enrollments)
        class_ids = [row[0] for row in result.fetchall()]

        if not class_ids:
            return SemesterAttendanceResponse(semester=str(year), courses=[])

        # Obtener las clases con sus materias del período
        stmt_classes = (
            select(Class, Subject)
            .join(Subject, Class.id_subject == Subject.id_subject)
            .where(Class.id_class.in_(class_ids))
            .where(Class.id_period == period.id_period)
        )
        result = await self.session.execute(stmt_classes)
        classes_data = result.all()

        summary_list = []

        for cls, subject in classes_data:
            # Obtener sesiones de la clase
            stmt_sessions = select(Session.id_session).where(
                Session.id_class == cls.id_class
            )
            result = await self.session.execute(stmt_sessions)
            session_ids = [row[0] for row in result.fetchall()]

            if not session_ids:
                summary_list.append(
                    SubjectAttendanceSummary(
                        subject_id=subject.id_subject,
                        subject_name=subject.name,
                        present=0,
                        absent=0,
                        late=0,
                        percentage=100,
                        status="OK",
                    )
                )
                continue

            # Contar asistencia por estado
            stmt_attendance = (
                select(Attendance.status, func.count(Attendance.id_attendance))
                .where(Attendance.id_session.in_(session_ids))
                .where(Attendance.id_student == student_id)
                .group_by(Attendance.status)
            )
            result = await self.session.execute(stmt_attendance)
            attendance_counts = {row[0]: row[1] for row in result.fetchall()}

            present = attendance_counts.get("PRESENT", 0)
            absent = attendance_counts.get("ABSENT", 0)
            late = attendance_counts.get("LATE", 0)
            justified = attendance_counts.get("JUSTIFIED", 0)

            total = present + absent + late + justified
            percentage = (
                int((present + late + justified) / total * 100) if total > 0 else 100
            )
            status = "OK" if percentage >= 80 else "ALERTA"

            summary_list.append(
                SubjectAttendanceSummary(
                    subject_id=subject.id_subject,
                    subject_name=subject.name,
                    present=present + late + justified,
                    absent=absent,
                    late=0,
                    percentage=percentage,
                    status=status,
                )
            )

        return SemesterAttendanceResponse(semester=str(year), courses=summary_list)

    async def get_subject_detail(
        self, student_id: str, subject_id: str, year: int, month: int
    ) -> SubjectAttendanceDetail:
        """
        Obtiene el detalle de asistencia por día para una materia.
        """
        # Obtener la materia
        stmt_subject = select(Subject).where(Subject.id_subject == subject_id)
        subject = (await self.session.execute(stmt_subject)).scalar_one_or_none()

        if not subject:
            return SubjectAttendanceDetail(
                subject_name="Unknown",
                month="",
                days=[],
            )

        # Obtener la clase del estudiante para esa materia
        stmt_enrollment = (
            select(Enrollment.id_class)
            .join(Class, Enrollment.id_class == Class.id_class)
            .where(Enrollment.id_student == student_id)
            .where(Class.id_subject == subject_id)
        )
        result = await self.session.execute(stmt_enrollment)
        class_id = result.scalar_one_or_none()

        if not class_id:
            return SubjectAttendanceDetail(
                subject_name=subject.name,
                month="",
                days=[],
            )

        # Obtener sesiones de la clase en el mes
        start_date = date(year, month, 1)
        if month == 12:
            end_date = date(year + 1, 1, 1)
        else:
            end_date = date(year, month + 1, 1)

        stmt_sessions = (
            select(Session)
            .where(Session.id_class == class_id)
            .where(Session.date >= start_date)
            .where(Session.date < end_date)
        )
        result = await self.session.execute(stmt_sessions)
        sessions = result.scalars().all()

        # Crear mapa de fecha -> attendance
        attendance_map = {}
        for session in sessions:
            stmt_att = (
                select(Attendance.status)
                .where(Attendance.id_session == session.id_session)
                .where(Attendance.id_student == student_id)
            )
            result = await self.session.execute(stmt_att)
            status = result.scalar_one_or_none()
            attendance_map[session.date.day] = status

        # Generar días del mes (asumiendo max 31 días)
        days_in_month = 31
        days_list = [
            DayAttendance(
                day=day,
                status=attendance_map.get(day),
            )
            for day in range(1, days_in_month + 1)
        ]

        month_names = [
            "Enero",
            "Febrero",
            "Marzo",
            "Abril",
            "Mayo",
            "Junio",
            "Julio",
            "Agosto",
            "Septiembre",
            "Octubre",
            "Noviembre",
            "Diciembre",
        ]

        return SubjectAttendanceDetail(
            subject_name=subject.name,
            month=f"{month_names[month - 1]} {year}",
            days=days_list,
        )
