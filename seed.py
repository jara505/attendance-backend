"""
Seed masivo para poblar toda la base de datos con datos ficticios realistas.
Respeta todas las relaciones, enums y constraints de los modelos actuales.
"""

import asyncio
import sys

sys.path.insert(0, ".")

from uuid import uuid4
from datetime import date, datetime, time, timedelta
from random import choice, randint, sample, uniform

from faker import Faker

from src.infrastructure.database import async_session, engine, Base
from src.infrastructure.models import (  # noqa: F403
    User,
    Student,
    Teacher,
    KnowledgeArea,
    Course,
    Group,
    Subject,
    Period,
    Class,
    Enrollment,
    Classroom,
    Schedule,
    Session,
    Attendance,
    JustificationAttachment,
    AttendanceEvent,
    TeacherFlag,
)
from src.infrastructure.models.user_models import UserRole
from src.infrastructure.models.academic_models import CycleEnum
from src.infrastructure.models.class_models import WeekDay, Shift
from src.infrastructure.models.session_models import (
    SessionStatus,
    AttendanceStatus,
    AttendanceMethod,
    AttachmentType,
)
from src.infrastructure.models.audit_models import EventType, FlagLevel, FlagStatus
from src.infrastructure.services.bcrypt_password_service import BcryptPasswordService

fake = Faker("es_MX")
pwd_service = BcryptPasswordService()
TEACHER_PASSWORD = "teacher123"
STUDENT_PASSWORD = "student123"
ADMIN_PASSWORD = "admin123"
FIXED_TEACHERS = 2
FIXED_STUDENTS = 3


def uid() -> str:
    return str(uuid4())


async def wipe_all():
    """Elimina todos los datos en orden inverso a las FKs."""
    tables = [
        "justification_attachment",
        "attendance_event",
        "teacher_flags",
        "attendance",
        "sessions",
        "schedule",
        "enrollments",
        "classes",
        "classrooms",
        "subjects",
        "periods",
        "groups_",
        "students",
        "teachers",
        "users",
        "courses",
        "knowledge_area",
    ]
    async with engine.begin() as conn:
        for table in tables:
            await conn.exec_driver_sql(f"DELETE FROM {table}")
    print("  🗑️  Datos existentes eliminados\n")


async def seed_all():
    print("🌱 Iniciando seed masivo...")
    await wipe_all()

    async with async_session() as s:
        # ─────────────────────────────────────────────────
        # 1. KNOWLEDGE AREAS
        # ─────────────────────────────────────────────────
        areas_data = [
            ("Ciencias Básicas",),
            ("Ingeniería y Tecnología",),
            ("Ciencias Sociales",),
            ("Humanidades",),
            ("Arte y Diseño",),
        ]
        areas = {}
        for (name,) in areas_data:
            area = KnowledgeArea(id_area=uid(), name=name)
            s.add(area)
            areas[name] = area
        await s.flush()
        print(f"  ✓ {len(areas)} áreas de conocimiento")

        # ─────────────────────────────────────────────────
        # 2. COURSES
        # ─────────────────────────────────────────────────
        courses_data = [
            ("Ingeniería Civil", "Ciencias Básicas", 5),
            ("Ingeniería de Sistemas", "Ingeniería y Tecnología", 5),
            ("Ingeniería Industrial", "Ingeniería y Tecnología", 5),
            ("Arquitectura", "Arte y Diseño", 5),
            ("Administración de Empresas", "Ciencias Sociales", 4),
            ("Derecho", "Ciencias Sociales", 5),
            ("Medicina", "Ciencias Básicas", 6),
            ("Diseño Gráfico", "Arte y Diseño", 4),
        ]
        courses = {}
        for name, area_name, years in courses_data:
            course = Course(
                id_course=uid(),
                name=name,
                id_area=areas[area_name].id_area,
                duration_years=years,
            )
            s.add(course)
            courses[name] = course
        await s.flush()
        print(f"  ✓ {len(courses)} carreras")

        # ─────────────────────────────────────────────────
        # 3. USERS + TEACHERS + STUDENTS
        # ─────────────────────────────────────────────────

        # ---- Admin ----
        admin_user = User(
            id_user=uid(),
            email="admin@catsivard.edu",
            password_hash=pwd_service.hash_password(ADMIN_PASSWORD),
            role=UserRole.ADMIN,
            must_change_password=False,
        )
        s.add(admin_user)

        # ---- Teachers (10) ----
        teacher_first_names = [
            "María",
            "José",
            "Carlos",
            "Ana",
            "Luis",
            "Rosa",
            "Pedro",
            "Laura",
            "Jorge",
            "Sofía",
        ]
        teacher_last_names = [
            "González",
            "Rodríguez",
            "López",
            "Martínez",
            "Pérez",
            "García",
            "Díaz",
            "Fernández",
            "Torres",
            "Ramírez",
        ]
        teachers = []
        for i in range(10):
            fn = teacher_first_names[i]
            ln = teacher_last_names[i]
            if i < FIXED_TEACHERS:
                email = f"teacher{i + 1}@catsivard.edu"
                pwd = TEACHER_PASSWORD
            else:
                email = f"{fn.lower()}.{ln.lower()}.{uid()[:6]}@catsivard.edu"
                pwd = TEACHER_PASSWORD
            user = User(
                id_user=uid(),
                email=email,
                password_hash=pwd_service.hash_password(pwd),
                role=UserRole.TEACHER,
                must_change_password=False,
            )
            s.add(user)
            await s.flush()

            teacher = Teacher(
                id_teacher=uid(),
                first_name=fn,
                last_name=ln,
                teacher_card=f"DOC{uid()[:8].upper()}",
                id_user=user.id_user,
                must_change_password=False,
                photo_url=fake.image_url(),
            )
            s.add(teacher)
            teachers.append(teacher)
        await s.flush()
        print(f"  ✓ 10 docentes")

        # ---- Students (60) ----
        course_list = list(courses.values())
        students = []
        for i in range(60):
            course = choice(course_list)
            fn = fake.first_name()
            ln = fake.last_name()
            if i < FIXED_STUDENTS:
                email = f"student{i + 1}@catsivard.edu"
                pwd = STUDENT_PASSWORD
            else:
                email = f"est.{fn.lower()}.{ln.lower()}.{uid()[:6]}@catsivard.edu"
                pwd = STUDENT_PASSWORD
            user = User(
                id_user=uid(),
                email=email,
                password_hash=pwd_service.hash_password(pwd),
                role=UserRole.STUDENT,
                must_change_password=False,
            )
            s.add(user)
            await s.flush()

            student = Student(
                id_student=uid(),
                first_name=fn,
                last_name=ln,
                student_card=f"EST{uid()[:8].upper()}",
                id_course=course.id_course,
                id_user=user.id_user,
                photo_url=fake.image_url(),
            )
            s.add(student)
            students.append(student)
        await s.flush()
        print(f"  ✓ 60 estudiantes")

        # ─────────────────────────────────────────────────
        # 4. GROUPS
        # ─────────────────────────────────────────────────
        group_codes = [
            "IC1A",
            "IC1B",
            "IC2A",
            "IC3A",
            "IC4A",
            "IC5A",
            "IS1A",
            "IS1B",
            "IS2A",
            "IS3A",
            "IS4A",
            "IS5A",
            "II1A",
            "II2A",
            "II3A",
            "AR1A",
            "AR2A",
            "AR3A",
            "AR4A",
            "AR5A",
            "AD1A",
            "AD2A",
            "AD3A",
            "AD4A",
            "DE1A",
            "DE2A",
            "DE3A",
            "ME1A",
            "ME2A",
            "ME3A",
            "DG1A",
            "DG2A",
            "DG3A",
            "DG4A",
        ]
        groups = []
        for code in group_codes:
            group = Group(id_group=uid(), code=code)
            s.add(group)
            groups.append(group)
        await s.flush()
        print(f"  ✓ {len(groups)} grupos")

        # ─────────────────────────────────────────────────
        # 5. PERIODS
        # ─────────────────────────────────────────────────
        current_year = 2026
        periods = []
        for cycle in [CycleEnum.FIRST, CycleEnum.SECOND]:
            period = Period(
                id_period=uid(),
                year=current_year,
                cycle=cycle.value,
                start_date=date(current_year, 3 if cycle == CycleEnum.FIRST else 8, 1),
                end_date=date(current_year, 7 if cycle == CycleEnum.FIRST else 12, 15),
            )
            s.add(period)
            periods.append(period)
        await s.flush()
        print(f"  ✓ {len(periods)} períodos ({current_year})")

        # ─────────────────────────────────────────────────
        # 6. SUBJECTS
        # ─────────────────────────────────────────────────
        subjects_data = [
            ("Cálculo I", "Ingeniería Civil"),
            ("Física I", "Ingeniería Civil"),
            ("Álgebra Lineal", "Ingeniería Civil"),
            ("Programación I", "Ingeniería de Sistemas"),
            ("Base de Datos", "Ingeniería de Sistemas"),
            ("Redes de Computadoras", "Ingeniería de Sistemas"),
            ("Termodinámica", "Ingeniería Industrial"),
            ("Investigación Operativa", "Ingeniería Industrial"),
            ("Dibujo Arquitectónico", "Arquitectura"),
            ("Historia de la Arquitectura", "Arquitectura"),
            ("Contabilidad General", "Administración de Empresas"),
            ("Marketing", "Administración de Empresas"),
            ("Introducción al Derecho", "Derecho"),
            ("Derecho Penal", "Derecho"),
            ("Anatomía Humana", "Medicina"),
            ("Fisiología", "Medicina"),
            ("Dibujo Artístico", "Diseño Gráfico"),
            ("Tipografía", "Diseño Gráfico"),
        ]
        subjects = []
        for sub_name, course_name in subjects_data:
            subject = Subject(
                id_subject=uid(),
                name=sub_name,
                id_course=courses[course_name].id_course,
            )
            s.add(subject)
            subjects.append(subject)
        await s.flush()
        print(f"  ✓ {len(subjects)} materias")

        # ─────────────────────────────────────────────────
        # 7. CLASSROOMS
        # ─────────────────────────────────────────────────
        classrooms_data = [
            ("A101", "A", "SALÓN"),
            ("A102", "A", "SALÓN"),
            ("A103", "A", "SALÓN"),
            ("A104", "A", "LAB"),
            ("B201", "B", "SALÓN"),
            ("B202", "B", "SALÓN"),
            ("B203", "B", "LAB"),
            ("B204", "B", "LAB"),
            ("C301", "C", "SALÓN"),
            ("C302", "C", "SALÓN"),
            ("C303", "C", "SALÓN"),
            ("C304", "C", "LAB"),
            ("D001", "D", "TALLER"),
            ("D002", "D", "TALLER"),
        ]
        classrooms = []
        for room_id, pav, room_type in classrooms_data:
            classroom = Classroom(
                id_classroom=room_id,
                pavilion=pav,
                type=room_type,
                latitude=round(uniform(-34.9, -34.5), 6),
                longitude=round(uniform(-57.9, -57.5), 6),
                allowed_radius=50.0,
            )
            s.add(classroom)
            classrooms.append(classroom)
        await s.flush()
        print(f"  ✓ {len(classrooms)} aulas")

        # ─────────────────────────────────────────────────
        # 8. CLASSES
        # ─────────────────────────────────────────────────
        # Vinculamos materias con grupos y docentes
        class_items = []
        period_actual = periods[0]  # primer ciclo 2026
        for subject in subjects[:12]:  # primeras 12 materias tienen class
            teacher = choice(teachers)
            group = choice(groups)
            cls = Class(
                id_class=uid(),
                id_teacher=teacher.id_teacher,
                id_subject=subject.id_subject,
                id_group=group.id_group,
                id_period=period_actual.id_period,
            )
            s.add(cls)
            class_items.append(cls)
        await s.flush()
        print(f"  ✓ {len(class_items)} clases")

        # ─────────────────────────────────────────────────
        # 9. ENROLLMENTS
        # ─────────────────────────────────────────────────
        enrollments = []
        for student in students:
            # Cada estudiante se inscribe en 2-4 clases
            num_classes = randint(2, 4)
            selected = sample(class_items, min(num_classes, len(class_items)))
            for cls in selected:
                enroll = Enrollment(
                    id_enrollment=uid(),
                    id_student=student.id_student,
                    id_class=cls.id_class,
                )
                s.add(enroll)
                enrollments.append(enroll)
        await s.flush()
        print(f"  ✓ {len(enrollments)} inscripciones")

        # ─────────────────────────────────────────────────
        # 10. SCHEDULES
        # ─────────────────────────────────────────────────
        weekdays = list(WeekDay)
        shifts = [Shift.MORNING, Shift.AFTERNOON]
        slots = [
            (time(7, 0), time(8, 30)),
            (time(8, 45), time(10, 15)),
            (time(10, 30), time(12, 0)),
            (time(13, 0), time(14, 30)),
            (time(14, 45), time(16, 15)),
            (time(16, 30), time(18, 0)),
        ]
        schedules = []
        for cls in class_items:
            # 1-2 horarios por clase
            num_slots = randint(1, 2)
            used_days = set()
            for _ in range(num_slots):
                day = choice([d for d in weekdays if d not in used_days])
                used_days.add(day)
                slot_start, slot_end = choice(slots)
                shift = Shift.MORNING if slot_start < time(12, 0) else Shift.AFTERNOON
                classroom = choice(classrooms)
                schedule = Schedule(
                    id_schedule=uid(),
                    id_class=cls.id_class,
                    weekday=day,
                    start_time=slot_start,
                    end_time=slot_end,
                    shift=shift,
                    id_classroom=classroom.id_classroom,
                )
                s.add(schedule)
                schedules.append(schedule)
        await s.flush()
        print(f"  ✓ {len(schedules)} horarios")

        # ─────────────────────────────────────────────────
        # 11. SESSIONS (pasadas y futuras)
        # ─────────────────────────────────────────────────
        sessions = []
        today = date.today()
        now_time = datetime.now().time()

        for cls in class_items:
            # 4 sesiones pasadas por clase
            for weeks_ago in range(4, 0, -1):
                session_date = today - timedelta(weeks=weeks_ago, days=randint(0, 2))
                if session_date.weekday() >= 5:  # weekend → skip
                    continue

                start_h = randint(7, 17)
                start_m = choice([0, 15, 30, 45])
                end_h = start_h + 1 + randint(0, 1)
                end_m = choice([0, 15, 30, 45])

                room = choice(classrooms)
                session = Session(
                    id_session=uid(),
                    id_class=cls.id_class,
                    date=session_date,
                    actual_start_time=time(start_h, start_m),
                    actual_end_time=time(end_h, end_m),
                    status=SessionStatus.FINISHED,
                    id_classroom=room.id_classroom,
                    qr_token=uid(),
                    qr_expires=datetime.combine(session_date, time(end_h, end_m))
                    + timedelta(hours=1),
                    opens_at=datetime.combine(session_date, time(start_h, start_m))
                    - timedelta(minutes=10),
                    closes_at=datetime.combine(session_date, time(end_h, end_m)),
                )
                s.add(session)
                sessions.append(session)

            # 1 sesión futura (SCHEDULED)
            future_date = today + timedelta(days=randint(1, 14))
            room = choice(classrooms)
            session = Session(
                id_session=uid(),
                id_class=cls.id_class,
                date=future_date,
                actual_start_time=None,
                actual_end_time=None,
                status=SessionStatus.SCHEDULED,
                id_classroom=room.id_classroom,
                qr_token=uid(),
            )
            s.add(session)
            sessions.append(session)

        await s.flush()
        print(f"  ✓ {len(sessions)} sesiones")

        # ─────────────────────────────────────────────────
        # 12. ATTENDANCE
        # ─────────────────────────────────────────────────
        past_sessions = [se for se in sessions if se.status == SessionStatus.FINISHED]
        attendances = []
        attendance_methods = [AttendanceMethod.QR, AttendanceMethod.MANUAL]
        status_weights = (
            [AttendanceStatus.PRESENT] * 7
            + [AttendanceStatus.ABSENT] * 1
            + [AttendanceStatus.LATE] * 1
            + [AttendanceStatus.JUSTIFIED] * 1
        )

        for session in past_sessions:
            # Obtener estudiantes inscritos en esta clase
            cls_id = session.id_class
            enrolled = [e for e in enrollments if e.id_class == cls_id]
            if not enrolled:
                continue

            for enrollment in enrolled:
                status = choice(status_weights)
                method = choice(attendance_methods)
                record_dt = datetime.combine(
                    session.date, session.actual_start_time or time(8, 0)
                )
                record_dt += timedelta(minutes=randint(-5, 30))

                att = Attendance(
                    id_attendance=uid(),
                    id_session=session.id_session,
                    id_student=enrollment.id_student,
                    status=status,
                    method=method,
                    record_date=record_dt,
                    ip_address=fake.ipv4(),
                    latitude=round(uniform(-34.9, -34.5), 6),
                    longitude=round(uniform(-57.9, -57.5), 6),
                    justification=fake.sentence()
                    if status == AttendanceStatus.JUSTIFIED
                    else None,
                    id_teacher_justifies=choice(teachers).id_teacher
                    if status == AttendanceStatus.JUSTIFIED
                    else None,
                    justification_date=record_dt + timedelta(days=1)
                    if status == AttendanceStatus.JUSTIFIED
                    else None,
                )
                s.add(att)
                attendances.append(att)

        await s.flush()
        print(f"  ✓ {len(attendances)} asistencias")

        # ─────────────────────────────────────────────────
        # 13. JUSTIFICATION ATTACHMENTS
        # ─────────────────────────────────────────────────
        justified = [a for a in attendances if a.status == AttendanceStatus.JUSTIFIED]
        attachments = []
        for att in justified[:20]:  # solos 20 justificaciones con archivo
            attachment = JustificationAttachment(
                id_attachment=uid(),
                id_attendance=att.id_attendance,
                file_url=fake.image_url(),
                type=choice([AttachmentType.IMAGE, AttachmentType.PDF]),
            )
            s.add(attachment)
            attachments.append(attachment)
        print(f"  ✓ {len(attachments)} archivos de justificación")

        # ─────────────────────────────────────────────────
        # 14. ATTENDANCE EVENTS
        # ─────────────────────────────────────────────────
        events_types = [
            EventType.CREATION,
            EventType.STATUS_CHANGE,
            EventType.JUSTIFICATION,
        ]
        events = []
        for att in attendances[:30]:  # eventos para las primeras 30 asistencias
            event = AttendanceEvent(
                id_event=uid(),
                id_attendance=att.id_attendance,
                type=choice(events_types),
                previous_status="PENDING",
                new_status=att.status.value if att.status else "ABSENT",
                comment=fake.sentence(),
                id_actor=choice(teachers).id_teacher,
            )
            s.add(event)
            events.append(event)
        print(f"  ✓ {len(events)} eventos de auditoría")

        # ─────────────────────────────────────────────────
        # 15. TEACHER FLAGS
        # ─────────────────────────────────────────────────
        flags = []
        flag_levels = [FlagLevel.LOW, FlagLevel.MEDIUM, FlagLevel.HIGH]
        flag_statuses = [FlagStatus.ACTIVE, FlagStatus.UNDER_REVIEW, FlagStatus.CLOSED]
        for teacher in teachers[:3]:  # 3 docentes con flags
            for _ in range(randint(1, 2)):
                flag = TeacherFlag(
                    id_flag=uid(),
                    id_teacher=teacher.id_teacher,
                    reason=fake.sentence(),
                    level=choice(flag_levels),
                    status=choice(flag_statuses),
                    session_id=choice(sessions).id_session if sessions else None,
                )
                s.add(flag)
                flags.append(flag)
        print(f"  ✓ {len(flags)} flags de docentes")

        # ─────────────────────────────────────────────────
        # COMMIT
        # ─────────────────────────────────────────────────
        await s.commit()

    # ─────────────────────────────────────────────────
    # RESUMEN
    # ─────────────────────────────────────────────────
    print("\n" + "=" * 50)
    print("✅ SEED COMPLETADO")
    print("=" * 50)
    print(f"  Áreas:          {len(areas)}")
    print(f"  Carreras:       {len(courses)}")
    print(f"  Docentes:       {len(teachers)}")
    print(f"  Estudiantes:    {len(students)}")
    print(f"  Grupos:         {len(groups)}")
    print(f"  Períodos:       {len(periods)}")
    print(f"  Materias:       {len(subjects)}")
    print(f"  Aulas:          {len(classrooms)}")
    print(f"  Clases:         {len(class_items)}")
    print(f"  Inscripciones:  {len(enrollments)}")
    print(f"  Horarios:       {len(schedules)}")
    print(f"  Sesiones:       {len(sessions)}")
    print(f"  Asistencias:    {len(attendances)}")
    print(f"  Adjuntos:       {len(attachments)}")
    print(f"  Eventos:        {len(events)}")
    print(f"  Flags:          {len(flags)}")
    print("=" * 50)
    print("\n🔑 CREDENCIALES FIJAS:")
    print(f"  Admin:    admin@catsivard.edu / {ADMIN_PASSWORD}")
    for i in range(FIXED_TEACHERS):
        print(f"  Teacher:  teacher{i + 1}@catsivard.edu / {TEACHER_PASSWORD}")
    for i in range(FIXED_STUDENTS):
        print(f"  Student:  student{i + 1}@catsivard.edu / {STUDENT_PASSWORD}")
    print(f"\n  Los demás users tienen emails random con @catsivard.edu")
    print(f"  Password teachers: {TEACHER_PASSWORD} | students: {STUDENT_PASSWORD}")


if __name__ == "__main__":
    asyncio.run(seed_all())
