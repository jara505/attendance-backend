"""
Seed de estructura académica para database.db
"""

import asyncio
import sys
sys.path.insert(0, '.')

from uuid import uuid4
from datetime import time

from src.infrastructure.database import async_session
from src.infrastructure.models.academic_models import CycleEnum, Group as GroupModel, Subject, Period
from src.infrastructure.models.class_models import WeekDay, Shift, Classroom, Class as ClassModel, Schedule
from src.infrastructure.models.user_models import Teacher
from sqlalchemy import select


async def seed_academic():
    async with async_session() as s:
        # ========== SUBJECTS ==========
        subjects = [
            ('sub-ic1', 'Calculo I', 'course-ic'),
            ('sub-ic2', 'Fisica I', 'course-ic'),
            ('sub-ic3', 'Dibujo Tecnico', 'course-ic'),
            ('sub-is1', 'Programacion I', 'course-is'),
            ('sub-is2', 'Introduccion a la Informatica', 'course-is'),
            ('sub-is3', 'Matematicas Discretas', 'course-is'),
            ('sub-ii1', 'Calculo I', 'course-ii'),
            ('sub-ii2', 'Estadistica I', 'course-ii'),
            ('sub-ar1', 'Dibujo Arquitectonico', 'course-arq'),
            ('sub-ar2', 'Historia de la Arquitectura', 'course-arq'),
            ('sub-lm1', 'Fundamentos de Marketing', 'course-lm'),
            ('sub-lm2', 'Investigacion de Mercados', 'course-lm'),
            ('sub-le1', 'Microeconomia', 'course-le'),
            ('sub-lp1', 'Psicologia General', 'course-lp'),
            ('sub-lc1', 'Comunicacion Oral y Escrita', 'course-lc'),
            ('sub-dg1', 'Dibujo I', 'course-dg'),
            ('sub-dg2', 'Teoria del Color', 'course-dg'),
        ]
        
        for sub_id, name, course_id in subjects:
            s.add(Subject(id_subject=sub_id, name=name, id_course=course_id))
        
        # ========== GROUPS ==========
        groups = [
            'IC11', 'IC12', 'IC13',
            'IS11', 'IS12', 'IS13', 'IS21', 'IS22', 'IS23',
            'II11', 'II12',
            'AR11', 'AR12',
            'LM11', 'LM12',
            'LE11',
            'LP11',
            'LC11',
            'DG11', 'DG12',
        ]
        
        for code in groups:
            s.add(GroupModel(id_group=str(uuid4()), code=code))
        
        # ========== PERIODS (usar int directo) ==========
        s.add(Period(
            id_period='period-2026-1',
            year=2026,
            cycle=1,  # INT no Enum
        ))
        
        # ========== CLASSROOMS ==========
        classrooms = [
            ('K1', 'K', 'SALON'), ('K2', 'K', 'SALON'), ('K3', 'K', 'SALON'), ('K4', 'K', 'SALON'),
            ('J1', 'J', 'SALON'), ('J2', 'J', 'SALON'), ('J3', 'J', 'SALON'), ('J4', 'J', 'SALON'),
            ('M1', 'M', 'LAB'), ('M2', 'M', 'LAB'), ('M3', 'M', 'LAB'), ('M4', 'M', 'LAB'),
        ]
        
        for room_id, pavilion, room_type in classrooms:
            s.add(Classroom(id_classroom=room_id, pavilion=pavilion, type=room_type))
        
        await s.flush()
        
        # ========== CLASSES ==========
        result = await s.execute(select(Teacher).where(Teacher.first_name == 'Jezzi'))
        teacher = result.scalar_one()
        
        classes_data = [
            ('sub-is1', 'IS11'),
            ('sub-is2', 'IS12'),
            ('sub-is3', 'IS21'),
            ('sub-ic1', 'IC11'),
            ('sub-ic2', 'IC12'),
            ('sub-ii1', 'II11'),
        ]
        
        class_ids = []
        for id_subject, group_code in classes_data:
            result = await s.execute(select(GroupModel).where(GroupModel.code == group_code))
            group = result.scalar_one()
            
            cls = ClassModel(
                id_class=str(uuid4()),
                id_teacher=teacher.id_teacher,
                id_subject=id_subject,
                id_group=group.id_group,
                id_period='period-2026-1',
            )
            s.add(cls)
            await s.flush()
            class_ids.append(cls.id_class)
        
        # ========== SCHEDULE ==========
        schedules_data = [
            (class_ids[0], 'MON', '07:00', '08:30', 'MORNING', 'K1'),
            (class_ids[1], 'TUE', '08:45', '10:15', 'MORNING', 'M2'),
            (class_ids[2], 'WED', '07:00', '08:30', 'MORNING', 'K2'),
            (class_ids[3], 'THU', '07:00', '08:30', 'MORNING', 'K3'),
            (class_ids[4], 'FRI', '07:00', '08:30', 'MORNING', 'K4'),
            (class_ids[5], 'MON', '08:45', '10:15', 'MORNING', 'M3'),
        ]
        
        for id_class, weekday, start, end, shift, id_classroom in schedules_data:
            s.add(Schedule(
                id_schedule=str(uuid4()),
                id_class=id_class,
                weekday=WeekDay[weekday],
                start_time=time.fromisoformat(start),
                end_time=time.fromisoformat(end),
                shift=Shift[shift],
                id_classroom=id_classroom,
            ))
        
        await s.commit()
        
    print("✅ Seed académico completado!")


if __name__ == "__main__":
    asyncio.run(seed_academic())
