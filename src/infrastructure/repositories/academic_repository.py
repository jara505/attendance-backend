from datetime import datetime, time
from sqlalchemy import select, and_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from src.infrastructure.models.class_models import Class, Schedule, WeekDay
from src.infrastructure.models.academic_models import Course, Group, Subject
from src.infrastructure.models.class_models import Classroom


class AcademicRepository:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_today_classes_by_teacher(
        self,
        teacher_id: str,
        current_time: time,
        current_weekday: str
    ) -> list[dict]:
        """
        Obtiene las clases del teacher para el día actual.
        Retorna lista de diccionarios con datos necesarios.
        """
        weekday_map = {
            "MONDAY": WeekDay.MON,
            "TUESDAY": WeekDay.TUE,
            "WEDNESDAY": WeekDay.WED,
            "THURSDAY": WeekDay.THU,
            "FRIDAY": WeekDay.FRI,
            "SATURDAY": WeekDay.SAT,
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
                selectinload(Class.schedules).selectinload(Schedule.classroom)
            )
            .where(
                and_(
                    Class.id_teacher == teacher_id,
                    Class.schedules.any(Schedule.weekday == weekday)
                )
            )
        )
        
        result = await self._session.execute(stmt)
        classes = result.scalars().unique().all()
        
        output = []
        for cls in classes:
            # Obtener el schedule del día
            schedule = next(
                (s for s in cls.schedules if s.weekday == weekday), 
                None
            )
            if not schedule:
                continue
            
            # Determinar estado de la clase
            start = schedule.start_time
            end = schedule.end_time
            
            if current_time < start:
                status = "FUTURE"
                remaining = int((start.hour - current_time.hour) * 60 + 
                              (start.minute - current_time.minute))
            elif current_time <= end:
                status = "ACTIVE"
                remaining = int((end.hour - current_time.hour) * 60 + 
                              (end.minute - current_time.minute))
            else:
                status = "PAST"
                remaining = None
            
            # Obtener nombre del curso (via subject -> course)
            course_name = cls.subject.course.name if cls.subject.course else "N/A"
            
            output.append({
                "id_class": cls.id_class,
                "course": course_name,
                "group": cls.group.code if cls.group else "N/A",
                "subject": cls.subject.name if cls.subject else "N/A",
                "classroom": schedule.classroom.id_classroom if schedule.classroom else "N/A",
                "start_time": start.strftime("%H:%M"),
                "end_time": end.strftime("%H:%M"),
                "status": status,
                "qr_available": status != "PAST",
                "remaining_minutes": remaining if status != "PAST" else None,
            })
        
        # Ordenar por hora de inicio
        output.sort(key=lambda x: x["start_time"])
        
        return output