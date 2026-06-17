from datetime import datetime, time, date
from sqlalchemy import select, and_, func
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from src.infrastructure.models.class_models import Class, Schedule, WeekDay, Enrollment
from src.infrastructure.models.academic_models import Course, Group, Subject
from src.infrastructure.models.class_models import Classroom
from src.infrastructure.models.session_models import (
    Attendance,
    Session,
    SessionStatus,
    AttendanceStatus,
)


class AcademicRepository:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_today_classes_by_teacher(
        self, teacher_id: str, current_time: time, current_weekday: str
    ) -> list[dict]:
        """
        Obtiene las clases del teacher para el día actual.
        Retorna lista de diccionarios con datos necesarios.
        """
        weekday_map = {
            "MON": WeekDay.MON,
            "MONDAY": WeekDay.MON,
            "TUE": WeekDay.TUE,
            "TUESDAY": WeekDay.TUE,
            "WED": WeekDay.WED,
            "WEDNESDAY": WeekDay.WED,
            "THU": WeekDay.THU,
            "THURSDAY": WeekDay.THU,
            "FRI": WeekDay.FRI,
            "FRIDAY": WeekDay.FRI,
            "SAT": WeekDay.SAT,
            "SATURDAY": WeekDay.SAT,
            "SUN": WeekDay.SUN,
            "SUNDAY": WeekDay.SUN,
        }

        weekday = weekday_map.get(current_weekday.upper(), WeekDay.MON)

        # Query: clases del teacher con schedule para el día actual
        # No cargamos period para evitar problema con enum vs int
        stmt = (
            select(Class)
            .options(
                selectinload(Class.subject).selectinload(Subject.course),
                selectinload(Class.group),
                selectinload(Class.schedules).selectinload(Schedule.classroom),
            )
            .where(
                and_(
                    Class.id_teacher == teacher_id,
                    Class.schedules.any(Schedule.weekday == weekday),
                )
            )
        )

        result = await self._session.execute(stmt)
        classes = result.scalars().unique().all()

        output = []
        for cls in classes:
            # Obtener TODOS los schedules del día
            day_schedules = [s for s in cls.schedules if s.weekday == weekday]
            if not day_schedules:
                continue

            # Procesar cada schedule (una clase puede tener múltiples horarios)
            for schedule in day_schedules:
                # Determinar estado de la clase
                start = schedule.start_time
                end = schedule.end_time

                if current_time < start:
                    status = "FUTURE"
                    remaining = int(
                        (start.hour - current_time.hour) * 60
                        + (start.minute - current_time.minute)
                    )
                elif current_time <= end:
                    status = "ACTIVE"
                    remaining = int(
                        (end.hour - current_time.hour) * 60
                        + (end.minute - current_time.minute)
                    )
                else:
                    status = "PAST"
                    remaining = None

                # Obtener nombre del curso (via subject -> course)
                course_name = cls.subject.course.name if cls.subject.course else "N/A"

                # Verificar si hay sesión para hoy
                session = await self.get_session_by_class_and_date(
                    cls.id_class, date.today()
                )
                session_id = session.id_session if session else None
                session_status = session.status.value if session else None

                # Determine if student can check in
                can_check_in = False
                if session:
                    if session.status.value == "ACTIVE":
                        can_check_in = True
                    elif session.status.value == "FINISHED" and session.extended_mode:
                        can_check_in = True

                # Si hay sesión ACTIVA, el estado de la clase es ACTIVE
                # sin importar lo que diga el horario del schedule
                if session_status == "ACTIVE":
                    status = "ACTIVE"
                    if remaining is None and session and session.closes_at:
                        remaining = max(
                            0,
                            int(
                                (session.closes_at - datetime.now()).total_seconds()
                                / 60
                            ),
                        )

                output.append(
                    {
                        "id_class": cls.id_class,
                        "course": course_name,
                        "group": cls.group.code if cls.group else "N/A",
                        "subject": cls.subject.name if cls.subject else "N/A",
                        "classroom": schedule.classroom.id_classroom
                        if schedule.classroom
                        else "N/A",
                        "start_time": start.strftime("%H:%M"),
                        "end_time": end.strftime("%H:%M"),
                        "status": status,
                        "qr_available": status != "PAST",
                        "remaining_minutes": remaining if status != "PAST" else None,
                        "session_id": session_id,
                        "session_status": session_status,
                        "can_check_in": can_check_in,
                        "extended_mode": session.extended_mode if session else False,
                    }
                )

        # Ordenar por hora de inicio
        output.sort(key=lambda x: x["start_time"])

        return output

    async def get_class_by_id(self, class_id: str) -> Class | None:
        stmt = (
            select(Class)
            .options(selectinload(Class.schedules).selectinload(Schedule.classroom))
            .where(Class.id_class == class_id)
        )
        result = await self._session.execute(stmt)
        return result.scalars().unique().one_or_none()

    async def count_enrollments_by_class(self, class_id: str) -> int:
        """Cuenta los estudiantes inscriptos en una clase."""
        stmt = select(func.count(Enrollment.id_enrollment)).where(
            Enrollment.id_class == class_id
        )
        result = await self._session.execute(stmt)
        return result.scalar() or 0

    async def get_enrollments_by_class(self, class_id: str) -> list[Enrollment]:
        """Obtiene todos los enrollments de una clase."""
        stmt = select(Enrollment).where(Enrollment.id_class == class_id)
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def get_session_by_class_and_date(
        self, class_id: str, session_date: date
    ) -> Session | None:
        """Obtiene la sesión de una clase para una fecha específica."""
        stmt = select(Session).where(
            and_(Session.id_class == class_id, Session.date == session_date)
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

    async def get_today_classes_by_student(
        self, student_id: str, current_time: time, current_weekday: str
    ) -> list[dict]:
        """
        Obtiene las clases del estudiante para el día actual.
        Retorna lista de diccionarios con datos necesarios.
        """
        weekday_map = {
            "MON": WeekDay.MON,
            "MONDAY": WeekDay.MON,
            "TUE": WeekDay.TUE,
            "TUESDAY": WeekDay.TUE,
            "WED": WeekDay.WED,
            "WEDNESDAY": WeekDay.WED,
            "THU": WeekDay.THU,
            "THURSDAY": WeekDay.THU,
            "FRI": WeekDay.FRI,
            "FRIDAY": WeekDay.FRI,
            "SAT": WeekDay.SAT,
            "SATURDAY": WeekDay.SAT,
            "SUN": WeekDay.SUN,
            "SUNDAY": WeekDay.SUN,
        }

        weekday = weekday_map.get(current_weekday.upper(), WeekDay.MON)

        # Obtener las clases del estudiante
        stmt_enroll = select(Enrollment.id_class).where(
            Enrollment.id_student == student_id
        )
        result = await self._session.execute(stmt_enroll)
        class_ids = [row[0] for row in result.fetchall()]

        if not class_ids:
            return []

        # Query: clases del estudiante con schedule para el día actual
        stmt = (
            select(Class)
            .options(
                selectinload(Class.subject).selectinload(Subject.course),
                selectinload(Class.group),
                selectinload(Class.schedules).selectinload(Schedule.classroom),
            )
            .where(
                and_(
                    Class.id_class.in_(class_ids),
                    Class.schedules.any(Schedule.weekday == weekday),
                )
            )
        )

        result = await self._session.execute(stmt)
        classes = result.scalars().unique().all()

        output = []
        for cls in classes:
            day_schedules = [s for s in cls.schedules if s.weekday == weekday]
            if not day_schedules:
                continue

            for schedule in day_schedules:
                start = schedule.start_time
                end = schedule.end_time

                if current_time < start:
                    status = "FUTURE"
                    remaining = int(
                        (start.hour - current_time.hour) * 60
                        + (start.minute - current_time.minute)
                    )
                elif current_time <= end:
                    status = "ACTIVE"
                    remaining = int(
                        (end.hour - current_time.hour) * 60
                        + (end.minute - current_time.minute)
                    )
                else:
                    status = "PAST"
                    remaining = None

                course_name = cls.subject.course.name if cls.subject.course else "N/A"

                # Verificar si hay sesión para hoy
                session = await self.get_session_by_class_and_date(
                    cls.id_class, date.today()
                )
                session_id = session.id_session if session else None
                session_status = session.status.value if session else None

                # Determine if student can check in
                can_check_in = False
                if session:
                    if session.status.value == "ACTIVE":
                        can_check_in = True
                    elif session.status.value == "FINISHED" and session.extended_mode:
                        can_check_in = True

                # Si hay sesión ACTIVA, el estado de la clase es ACTIVE
                if session_status == "ACTIVE":
                    status = "ACTIVE"
                    if remaining is None and session and session.closes_at:
                        remaining = max(
                            0,
                            int(
                                (session.closes_at - datetime.now()).total_seconds()
                                / 60
                            ),
                        )

                # Check if student already has attendance for this session
                check_in_time = None
                attendance_status = None
                if session:
                    att_stmt = select(Attendance).where(
                        and_(
                            Attendance.id_session == session.id_session,
                            Attendance.id_student == student_id,
                        )
                    )
                    att_result = await self._session.execute(att_stmt)
                    attendance_record = att_result.scalar_one_or_none()
                    if attendance_record:
                        # check_in_time solo si realmente escaneó (PRESENT/LATE)
                        # PENDING/ABSENT/JUSTIFIED no generan badge
                        if attendance_record.status in (
                            AttendanceStatus.PRESENT,
                            AttendanceStatus.LATE,
                        ):
                            check_in_time = attendance_record.record_date
                        attendance_status = (
                            attendance_record.status.value
                            if attendance_record.status
                            else None
                        )

                        # Recalcular can_check_in: si ya tiene registro FIRME, no puede escanear
                        if attendance_record.status in (
                            AttendanceStatus.PRESENT,
                            AttendanceStatus.LATE,
                            AttendanceStatus.JUSTIFIED,
                        ):
                            can_check_in = False

                output.append(
                    {
                        "id_class": cls.id_class,
                        "course": course_name,
                        "group": cls.group.code if cls.group else "N/A",
                        "subject": cls.subject.name if cls.subject else "N/A",
                        "classroom": schedule.classroom.id_classroom
                        if schedule.classroom
                        else "N/A",
                        "start_time": start.strftime("%H:%M"),
                        "end_time": end.strftime("%H:%M"),
                        "status": status,
                        "qr_available": status != "PAST",
                        "remaining_minutes": remaining if status != "PAST" else None,
                        "session_id": session_id,
                        "session_status": session_status,
                        "can_check_in": can_check_in,
                        "extended_mode": session.extended_mode if session else False,
                        "check_in_time": check_in_time,
                        "attendance_status": attendance_status,
                    }
                )

        output.sort(key=lambda x: x["start_time"])

        return output

    async def get_teacher_classes(
        self,
        teacher_id: str,
        course_id: str | None = None,
        year: int | None = None,
    ) -> list[Class]:
        """Todas las clases de un teacher con relaciones eager-loaded.
        Filtros opcionales: course_id (por carrera) y year (por año)."""
        stmt = (
            select(Class)
            .options(
                selectinload(Class.subject).selectinload(Subject.course),
                selectinload(Class.group),
                selectinload(Class.period),
                selectinload(Class.enrollments),
            )
            .where(Class.id_teacher == teacher_id)
        )

        if course_id is not None:
            stmt = stmt.join(Subject, Class.id_subject == Subject.id_subject).where(
                Subject.id_course == course_id
            )

        if year is not None:
            stmt = stmt.join(Period, Class.id_period == Period.id_period).where(
                Period.year == year
            )

        result = await self._session.execute(stmt)
        return list(result.scalars().unique().all())

    async def get_class_with_details(self, class_id: str) -> Class | None:
        """Clase con subject, course, group, period, enrollments y students."""
        stmt = (
            select(Class)
            .options(
                selectinload(Class.subject).selectinload(Subject.course),
                selectinload(Class.group),
                selectinload(Class.period),
                selectinload(Class.enrollments).selectinload(Enrollment.student),
            )
            .where(Class.id_class == class_id)
        )
        result = await self._session.execute(stmt)
        return result.scalars().unique().one_or_none()

    async def get_class_sessions_count(self, class_id: str) -> int:
        """Cantidad total de sesiones de una clase."""
        stmt = select(func.count(Session.id_session)).where(
            Session.id_class == class_id
        )
        result = await self._session.execute(stmt)
        return result.scalar() or 0

    async def get_attendance_counts_by_class(
        self, class_id: str
    ) -> dict[str, dict[str, int]]:
        """
        Retorna { id_student: { PRESENT: N, ABSENT: N, LATE: N, JUSTIFIED: N } }
        con un solo query GROUP BY sobre attendance JOIN sessions.
        """
        stmt = (
            select(
                Attendance.id_student,
                Attendance.status,
                func.count(Attendance.id_attendance),
            )
            .join(Session, Attendance.id_session == Session.id_session)
            .where(Session.id_class == class_id)
            .group_by(Attendance.id_student, Attendance.status)
        )
        result = await self._session.execute(stmt)
        rows = result.all()

        counts: dict[str, dict[str, int]] = {}
        for student_id, status, count in rows:
            if student_id not in counts:
                counts[student_id] = {}
            counts[student_id][status.value] = count  # type: ignore[attr-defined]

        return counts
