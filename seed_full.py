#!/usr/bin/env python3
"""
Seed script — attendance-backend (PostgreSQL).
Limpia datos existentes e inserta ~30 registros consistentes por tabla.

Uso:
    cd /home/mrx/Escritorio/attendance-backend
    python seed_full.py

Requisitos:
    - Tablas creadas (ejecutar la app al menos una vez o aplicar migración)
    - Archivo .env con DATABASE_URL apuntando a PostgreSQL
"""

import asyncio
import random
import sys
from datetime import datetime, date, time, timedelta
from pathlib import Path
from uuid import uuid4

sys.path.insert(0, str(Path(__file__).parent.resolve()))

import unicodedata
import bcrypt
from faker import Faker
from sqlalchemy import text
from sqlalchemy.ext.asyncio import (
    create_async_engine,
    AsyncSession,
    async_sessionmaker,
)

from src.infrastructure.config import settings
from src.infrastructure.models.user_models import User, Student, Teacher, UserRole
from src.infrastructure.models.academic_models import (
    KnowledgeArea,
    Course,
    Group,
    Subject,
    Period,
)
from src.infrastructure.models.class_models import (
    Classroom,
    Class,
    Enrollment,
    Schedule,
    WeekDay,
    Shift,
)
from src.infrastructure.models.session_models import (
    Session,
    SessionStatus,
    Attendance,
    AttendanceStatus,
    AttendanceMethod,
    JustificationAttachment,
    AttachmentType,
)
from src.infrastructure.models.audit_models import (
    AttendanceEvent,
    EventType,
    TeacherFlag,
    FlagLevel,
    FlagStatus,
)

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------
fake = Faker("es")
random.seed(42)
fake.seed_instance(42)

DOMAIN = "catsivard.edu"
PWD_TEACHER = bcrypt.hashpw(b"teacher123", bcrypt.gensalt()).decode()
PWD_STUDENT = bcrypt.hashpw(b"student123", bcrypt.gensalt()).decode()
PWD_ADMIN = bcrypt.hashpw(b"admin123", bcrypt.gensalt()).decode()

TODAY = date.today()

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------


def uid() -> str:
    return str(uuid4())


def _strip_accents(s: str) -> str:
    nfkd = unicodedata.normalize("NFKD", s)
    return "".join(c for c in nfkd if not unicodedata.category(c).startswith("M"))


_used_emails: set[str] = set()


def email_addr(first: str, last: str) -> str:
    base = _strip_accents(first).lower().split()[0]
    email = f"{base}@{DOMAIN}"
    dedup = 1
    while email in _used_emails:
        dedup += 1
        email = f"{base}{dedup}@{DOMAIN}"
    _used_emails.add(email)
    return email


def teacher_card() -> str:
    return f"DOC{uid()[:8].upper()}"


def student_card() -> str:
    return f"EST{uid()[:8].upper()}"


def pick_dates(
    schedule_weekday: WeekDay, semester_start: date, semester_end: date, count: int
) -> list[date]:
    """Retorna `count` fechas dentro del semestre que caen en `schedule_weekday`."""
    week_map = {
        WeekDay.MON: 0,
        WeekDay.TUE: 1,
        WeekDay.WED: 2,
        WeekDay.THU: 3,
        WeekDay.FRI: 4,
        WeekDay.SAT: 5,
        WeekDay.SUN: 6,
    }
    target_wd = week_map[schedule_weekday]
    current = semester_start
    while current.weekday() != target_wd:
        current += timedelta(days=1)
    candidates: list[date] = []
    while current <= semester_end:
        candidates.append(current)
        current += timedelta(weeks=1)
    return random.sample(candidates, min(count, len(candidates)))


def all_dates_for_weekday(weekday: WeekDay, start: date, end: date) -> list[date]:
    """Retorna TODAS las fechas para un weekday dado dentro del rango [start, end]."""
    week_map = {
        WeekDay.MON: 0,
        WeekDay.TUE: 1,
        WeekDay.WED: 2,
        WeekDay.THU: 3,
        WeekDay.FRI: 4,
        WeekDay.SAT: 5,
        WeekDay.SUN: 6,
    }
    target_wd = week_map[weekday]
    current = start
    while current.weekday() != target_wd:
        current += timedelta(days=1)
    result: list[date] = []
    while current <= end:
        result.append(current)
        current += timedelta(weeks=1)
    return result


# ---------------------------------------------------------------------------
# Data definitions
# ---------------------------------------------------------------------------

# 1. Knowledge Areas  ──────────────────────────────────────────────────────
AREA_DEFS = [
    "Ciencias Básicas",
    "Ingeniería y Tecnología",
    "Ciencias Sociales",
    "Humanidades",
    "Arte y Diseño",
]

# 2. Courses  ──────────────────────────────────────────────────────────────
# (code, name, area_name, duration_years)
COURSE_DEFS: list[tuple[str, str, str, int]] = [
    ("IC", "Ingeniería Civil", "Ciencias Básicas", 5),
    ("IS", "Ingeniería de Sistemas", "Ingeniería y Tecnología", 5),
    ("II", "Ingeniería Industrial", "Ingeniería y Tecnología", 5),
    ("AR", "Arquitectura", "Arte y Diseño", 5),
    ("AD", "Administración de Empresas", "Ciencias Sociales", 4),
    ("DE", "Derecho", "Ciencias Sociales", 5),
    ("ME", "Medicina", "Ciencias Básicas", 6),
    ("DG", "Diseño Gráfico", "Arte y Diseño", 4),
]

# 3. Groups  ──────────────────────────────────────────────────────────────
# Pattern: {code_prefix}{year}{section}
GROUP_PATTERNS: dict[str, tuple[int, int, list[str]]] = {
    "IC": (1, 4, ["A"]),
    "IS": (1, 4, ["A", "B"]),
    "II": (1, 3, ["A"]),
    "AR": (1, 3, ["A"]),
    "AD": (1, 3, ["A"]),
    "DE": (1, 3, ["A"]),
    "ME": (1, 3, ["A"]),
    "DG": (1, 3, ["A"]),
}


def build_groups() -> list[str]:
    groups: list[str] = []
    for code, _, _, _ in COURSE_DEFS:
        y1, y2, secs = GROUP_PATTERNS[code]
        for year in range(y1, y2 + 1):
            for s in secs:
                groups.append(f"{code}{year}{s}")
    return groups


# 4. Subjects  ─────────────────────────────────────────────────────────────
SUBJECT_DEFS: dict[str, list[str]] = {
    "IC": [
        "Cálculo I",
        "Física I",
        "Álgebra Lineal",
        "Geometría Analítica",
        "Resistencia de Materiales",
    ],
    "IS": [
        "Programación I",
        "Base de Datos I",
        "Redes I",
        "Sistemas Operativos",
        "Ingeniería de Software",
    ],
    "II": ["Termodinámica", "Investigación Operativa", "Gestión de Calidad"],
    "AR": ["Dibujo Arquitectónico", "Historia de la Arquitectura", "Estructuras I"],
    "AD": ["Contabilidad General", "Marketing", "Recursos Humanos"],
    "DE": ["Introducción al Derecho", "Derecho Penal", "Derecho Civil"],
    "ME": ["Anatomía Humana", "Fisiología", "Bioquímica"],
    "DG": ["Dibujo Artístico", "Tipografía", "Diseño Digital"],
}

# 5. Periods  ──────────────────────────────────────────────────────────────
PERIOD_DEFS: list[tuple[int, int, date, date]] = [
    (2026, 1, date(2026, 3, 1), date(2026, 6, 30)),
    (2026, 2, date(2026, 8, 1), date(2026, 11, 30)),
]


# 6. Classrooms  ───────────────────────────────────────────────────────────
def build_classrooms() -> list[tuple[str, str, str]]:
    rooms: list[tuple[str, str, str]] = []
    for i in range(1, 11):
        rooms.append((f"A{100 + i}", "A", "SALÓN"))
    for i in range(1, 9):
        rooms.append((f"B{200 + i}", "B", "SALÓN"))
    for i in range(1, 9):
        rooms.append((f"C{300 + i}", "C", "LAB"))
    for i in range(1, 5):
        rooms.append((f"D{i:04d}", "D", "TALLER"))
    return rooms


# 7. Teachers  ─────────────────────────────────────────────────────────────
DEFAULT_TEACHER_NAMES = [
    ("María", "González"),
    ("José", "Rodríguez"),
    ("Carlos", "López"),
]


def build_teachers() -> list[dict]:
    teachers: list[dict] = []
    used = set()
    for first, last in DEFAULT_TEACHER_NAMES:
        used.add((first, last))
        teachers.append(dict(first=first, last=last, is_default=True))
    while len(teachers) < 8:
        first = fake.first_name()
        last = fake.last_name()
        if (first, last) not in used:
            used.add((first, last))
            teachers.append(dict(first=first, last=last, is_default=False))
    return teachers


# 8. Students  ─────────────────────────────────────────────────────────────
def build_students() -> list[dict]:
    students: list[dict] = []
    used_names: set[tuple[str, str]] = set()
    # First 3 are default (password student123), rest are random
    while len(students) < 22:
        first = fake.first_name()
        last = fake.last_name()
        if (first, last) not in used_names:
            used_names.add((first, last))
            students.append(
                dict(
                    first=first,
                    last=last,
                    is_default=len(students) < 3,
                )
            )
    return students


# 9. Classes plan  ─────────────────────────────────────────────────────────
# course_code -> [(subject_name, group_code)]
CLASS_PLAN: dict[str, list[tuple[str, str]]] = {
    "IC": [("Cálculo I", "IC1A"), ("Física I", "IC1A"), ("Álgebra Lineal", "IC2A")],
    "IS": [
        ("Programación I", "IS1A"),
        ("Base de Datos I", "IS2A"),
        ("Redes I", "IS3A"),
    ],
    "II": [
        ("Termodinámica", "II1A"),
        ("Investigación Operativa", "II2A"),
        ("Gestión de Calidad", "II3A"),
    ],
    "AR": [
        ("Dibujo Arquitectónico", "AR1A"),
        ("Historia de la Arquitectura", "AR2A"),
        ("Estructuras I", "AR3A"),
    ],
    "AD": [("Contabilidad General", "AD1A"), ("Marketing", "AD2A")],
    "DE": [("Introducción al Derecho", "DE1A"), ("Derecho Penal", "DE2A")],
    "ME": [("Anatomía Humana", "ME1A"), ("Fisiología", "ME2A")],
    "DG": [("Dibujo Artístico", "DG1A"), ("Tipografía", "DG2A")],
}

# teacher index -> course code
TEACHER_COURSE_IDX: list[tuple[int, str]] = [
    (0, "IC"),
    (1, "IS"),
    (2, "II"),
    (3, "AR"),
    (4, "AD"),
    (5, "DE"),
    (6, "ME"),
    (7, "DG"),
]

# 10. Schedule slots (no conflicts per teacher)  ───────────────────────────
# teacher_index -> [(weekday, start, end)]
TEACHER_SLOTS: dict[int, list[tuple[WeekDay, time, time]]] = {
    0: [
        (WeekDay.MON, time(7, 0), time(8, 30)),
        (WeekDay.TUE, time(8, 45), time(10, 15)),
        (WeekDay.WED, time(10, 30), time(12, 0)),
    ],
    1: [
        (WeekDay.MON, time(8, 45), time(10, 15)),
        (WeekDay.TUE, time(10, 30), time(12, 0)),
        (WeekDay.WED, time(13, 0), time(14, 30)),
    ],
    2: [
        (WeekDay.MON, time(10, 30), time(12, 0)),
        (WeekDay.TUE, time(13, 0), time(14, 30)),
        (WeekDay.WED, time(14, 45), time(16, 15)),
    ],
    3: [
        (WeekDay.MON, time(13, 0), time(14, 30)),
        (WeekDay.TUE, time(14, 45), time(16, 15)),
        (WeekDay.WED, time(16, 30), time(18, 0)),
    ],
    4: [
        (WeekDay.MON, time(14, 45), time(16, 15)),
        (WeekDay.TUE, time(16, 30), time(18, 0)),
    ],
    5: [
        (WeekDay.MON, time(16, 30), time(18, 0)),
        (WeekDay.THU, time(7, 0), time(8, 30)),
    ],
    6: [
        (WeekDay.THU, time(8, 45), time(10, 15)),
        (WeekDay.THU, time(10, 30), time(12, 0)),
    ],
    7: [
        (WeekDay.THU, time(13, 0), time(14, 30)),
        (WeekDay.THU, time(14, 45), time(16, 15)),
    ],
}

# 11. Session count per class  ─────────────────────────────────────────────
# (course_code, subject_name) -> session_count (total ~30)
SESSION_COUNTS: dict[tuple[str, str], int] = {
    ("IC", "Cálculo I"): 8,
    ("IC", "Física I"): 8,
    ("IC", "Álgebra Lineal"): 7,
    ("IS", "Programación I"): 8,
    ("IS", "Base de Datos I"): 7,
    ("IS", "Redes I"): 7,
    ("II", "Termodinámica"): 8,
    ("II", "Investigación Operativa"): 7,
    ("II", "Gestión de Calidad"): 7,
    ("AR", "Dibujo Arquitectónico"): 8,
    ("AR", "Historia de la Arquitectura"): 7,
    ("AR", "Estructuras I"): 7,
    ("AD", "Contabilidad General"): 8,
    ("AD", "Marketing"): 7,
    ("DE", "Introducción al Derecho"): 8,
    ("DE", "Derecho Penal"): 7,
    ("ME", "Anatomía Humana"): 8,
    ("ME", "Fisiología"): 7,
    ("DG", "Dibujo Artístico"): 8,
    ("DG", "Tipografía"): 7,
}
# Suma: 23+22+22+22+15+15+15+15 = ~149 sesiones

# Teachers with extended mode (indices 1=José, 3=Ana)
EXTENDED_TEACHERS = {1, 3}


# ---------------------------------------------------------------------------
# MAIN SEED
# ---------------------------------------------------------------------------


async def clear_data(session: AsyncSession) -> None:
    tables = [
        "justification_attachment",
        "attendance_event",
        "teacher_flags",
        "attendance",
        "sessions",
        "schedule",
        "enrollments",
        "classes",
        "subjects",
        "students",
        "teachers",
        "users",
        "periods",
        "groups_",
        "classrooms",
        "courses",
        "knowledge_area",
    ]
    for table in tables:
        await session.execute(text(f"DELETE FROM {table}"))
    await session.flush()
    print("✓ Datos existentes eliminados.")


async def seed_all(session: AsyncSession) -> None:
    """Inserta datos en orden de dependencias FK."""

    # ------------------------------------------------------------------
    # 1. Knowledge Areas
    # ------------------------------------------------------------------
    area_map: dict[str, str] = {}  # name -> id
    for name in AREA_DEFS:
        aid = uid()
        session.add(KnowledgeArea(id_area=aid, name=name))
        area_map[name] = aid
    await session.flush()
    print(f"✓ 1. knowledge_area: {len(AREA_DEFS)}")

    # ------------------------------------------------------------------
    # 2. Courses
    # ------------------------------------------------------------------
    course_map: dict[str, dict] = {}  # code -> {id, name}
    for code, name, area_name, years in COURSE_DEFS:
        cid = uid()
        session.add(
            Course(
                id_course=cid,
                name=name,
                id_area=area_map[area_name],
                duration_years=years,
            )
        )
        course_map[code] = {"id": cid, "name": name}
    await session.flush()
    print(f"✓ 2. courses: {len(COURSE_DEFS)}")

    # ------------------------------------------------------------------
    # 3. Groups
    # ------------------------------------------------------------------
    group_names = build_groups()
    group_map: dict[str, str] = {}  # group_code -> id
    for gcode in group_names:
        gid = uid()
        session.add(Group(id_group=gid, code=gcode))
        group_map[gcode] = gid
    await session.flush()
    print(f"✓ 3. groups_: {len(group_names)}")

    # ------------------------------------------------------------------
    # 4. Subjects
    # ------------------------------------------------------------------
    subject_map: dict[str, dict] = {}  # subject_name -> {id, course_code}
    subj_list: list[dict] = []  # for later lookup
    for code, names in SUBJECT_DEFS.items():
        for sname in names:
            sid = uid()
            session.add(
                Subject(id_subject=sid, name=sname, id_course=course_map[code]["id"])
            )
            subject_map[sname] = {"id": sid, "course_code": code}
            subj_list.append({"name": sname, "id": sid, "course_code": code})
    await session.flush()
    print(f"✓ 4. subjects: {len(subj_list)}")

    # ------------------------------------------------------------------
    # 5. Periods
    # ------------------------------------------------------------------
    period_map: dict[tuple[int, int], str] = {}  # (year, cycle) -> id
    for year, cycle, sdate, edate in PERIOD_DEFS:
        pid = uid()
        session.add(
            Period(
                id_period=pid, year=year, cycle=cycle, start_date=sdate, end_date=edate
            )
        )
        period_map[(year, cycle)] = pid
    await session.flush()
    print(f"✓ 5. periods: {len(PERIOD_DEFS)}")

    # ------------------------------------------------------------------
    # 6. Classrooms
    # ------------------------------------------------------------------
    classrooms = build_classrooms()
    classroom_map: dict[str, str] = {}  # code -> id
    for code, pav, typ in classrooms:
        crid = uid()
        session.add(Classroom(id_classroom=crid, pavilion=pav, type=typ))
        classroom_map[code] = crid
    await session.flush()
    print(f"✓ 6. classrooms: {len(classrooms)}")

    # ------------------------------------------------------------------
    # 7. Users + Teachers
    # ------------------------------------------------------------------
    teachers_list = build_teachers()
    teacher_records: list[dict] = []  # {user_id, teacher_id, email, first, last, idx}

    # Admin
    admin_id = uid()
    session.add(
        User(
            id_user=admin_id,
            email="admin@catsivard.edu",
            password_hash=PWD_ADMIN,
            role=UserRole.ADMIN,
            must_change_password=False,
        )
    )
    await session.flush()

    for idx, tdata in enumerate(teachers_list):
        tid = uid()
        pwd = (
            PWD_TEACHER
            if tdata["is_default"]
            else bcrypt.hashpw(b"random789", bcrypt.gensalt()).decode()
        )
        email = email_addr(tdata["first"], tdata["last"])
        session.add(
            User(
                id_user=tid,
                email=email,
                password_hash=pwd,
                role=UserRole.TEACHER,
                must_change_password=False,
            )
        )
        tch_id = uid()
        session.add(
            Teacher(
                id_teacher=tch_id,
                first_name=tdata["first"],
                last_name=tdata["last"],
                teacher_card=teacher_card(),
                id_user=tid,
                modifications_count=0,
                teacher_flag=False,
                must_change_password=False,
            )
        )
        teacher_records.append(
            dict(
                user_id=tid,
                teacher_id=tch_id,
                email=email,
                first=tdata["first"],
                last=tdata["last"],
                idx=idx,
            )
        )
    await session.flush()
    print(f"✓ 7. users: 1 admin + {len(teachers_list)} teachers")

    # ------------------------------------------------------------------
    # 8. Users + Students
    # ------------------------------------------------------------------
    students_list = build_students()
    student_records: list[
        dict
    ] = []  # {user_id, student_id, course_code, email, first, last}

    # Distribute students across courses
    course_student_dist: list[tuple[str, int]] = [
        ("IC", 3),
        ("IS", 3),
        ("II", 3),
        ("AR", 3),
        ("AD", 2),
        ("DE", 2),
        ("ME", 3),
        ("DG", 3),
    ]

    st_idx = 0
    for course_code, count in course_student_dist:
        for _ in range(count):
            sdata = students_list[st_idx]
            sid = uid()
            pwd = (
                PWD_STUDENT
                if sdata["is_default"]
                else bcrypt.hashpw(b"random456", bcrypt.gensalt()).decode()
            )
            email = email_addr(sdata["first"], sdata["last"])
            session.add(
                User(
                    id_user=sid,
                    email=email,
                    password_hash=pwd,
                    role=UserRole.STUDENT,
                    must_change_password=False,
                )
            )
            std_id = uid()
            session.add(
                Student(
                    id_student=std_id,
                    first_name=sdata["first"],
                    last_name=sdata["last"],
                    student_card=student_card(),
                    id_course=course_map[course_code]["id"],
                    id_user=sid,
                )
            )
            student_records.append(
                dict(
                    user_id=sid,
                    student_id=std_id,
                    course_code=course_code,
                    email=email,
                    first=sdata["first"],
                    last=sdata["last"],
                )
            )
            st_idx += 1
    await session.flush()
    print(f"✓ 8. students: {len(student_records)}")

    # ------------------------------------------------------------------
    # 9. Classes + Schedules
    # ------------------------------------------------------------------
    class_records: list[
        dict
    ] = []  # {class_id, teacher_idx, course_code, subject_name, group_code}
    schedule_records: list[dict] = []

    period_id = period_map[(2026, 1)]

    for teacher_idx, course_code in TEACHER_COURSE_IDX:
        slots = TEACHER_SLOTS[teacher_idx]
        subjects_for_course = CLASS_PLAN[course_code]
        for i, (subj_name, group_code) in enumerate(subjects_for_course):
            cls_id = uid()
            session.add(
                Class(
                    id_class=cls_id,
                    id_teacher=teacher_records[teacher_idx]["teacher_id"],
                    id_subject=subject_map[subj_name]["id"],
                    id_group=group_map[group_code],
                    id_period=period_id,
                )
            )
            class_records.append(
                dict(
                    class_id=cls_id,
                    teacher_idx=teacher_idx,
                    course_code=course_code,
                    subject_name=subj_name,
                    group_code=group_code,
                )
            )

            # Schedule
            wd, st, et = slots[i]
            shift = Shift.MORNING if st.hour < 12 else Shift.AFTERNOON
            # Assign a random classroom
            classroom_code = random.choice(list(classroom_map.keys()))
            sched_id = uid()
            session.add(
                Schedule(
                    id_schedule=sched_id,
                    id_class=cls_id,
                    weekday=wd,
                    start_time=st,
                    end_time=et,
                    shift=shift,
                    id_classroom=classroom_map[classroom_code],
                    end_next_day=False,
                )
            )
            schedule_records.append(
                dict(
                    schedule_id=sched_id,
                    class_id=cls_id,
                    weekday=wd,
                    start_time=st,
                    end_time=et,
                )
            )
    await session.flush()
    print(f"✓ 9. classes: {len(class_records)}, schedule: {len(schedule_records)}")

    # ------------------------------------------------------------------
    # 10. Enrollments
    # ------------------------------------------------------------------
    # Students enroll in classes of their own course
    enrollment_count = 0
    for srec in student_records:
        student_course = srec["course_code"]
        for crec in class_records:
            if crec["course_code"] == student_course:
                enr_id = uid()
                session.add(
                    Enrollment(
                        id_enrollment=enr_id,
                        id_student=srec["student_id"],
                        id_class=crec["class_id"],
                    )
                )
                enrollment_count += 1
    await session.flush()
    print(f"✓ 10. enrollments: {enrollment_count}")

    # Build lookup: student_id by course_code
    students_by_course: dict[str, list[dict]] = {}
    for srec in student_records:
        students_by_course.setdefault(srec["course_code"], []).append(srec)

    # Build lookup: class by (course_code, subject_name)
    class_by_course_subj: dict[tuple[str, str], dict] = {}
    for crec in class_records:
        class_by_course_subj[(crec["course_code"], crec["subject_name"])] = crec

    # Build lookup: schedule by class_id
    schedule_by_class: dict[str, dict] = {}
    for srec in schedule_records:
        schedule_by_class[srec["class_id"]] = srec

    # ------------------------------------------------------------------
    # 11. Sessions
    # ------------------------------------------------------------------
    session_records: list[
        dict
    ] = []  # {session_id, class_id, course_code, subject_name, weekday, date}

    session_total = 0
    semester_start = date(2026, 3, 2)
    semester_end = date(2026, 6, 30)

    # IC (María): todas las fechas de clase desde marzo hasta ayer
    ic_students_only = {"ciro@catsivard.edu", "dominga@catsivard.edu"}
    ic_end = TODAY - timedelta(days=1)  # ayer (hoy domingo no va)

    for (course_code, subj_name), sched_count in SESSION_COUNTS.items():
        crec = class_by_course_subj.get((course_code, subj_name))
        if not crec:
            continue
        sched = schedule_by_class.get(crec["class_id"])
        if not sched:
            continue
        if course_code == "IC":
            # Generar TODAS las fechas de clase hasta ayer
            dates = all_dates_for_weekday(sched["weekday"], semester_start, ic_end)
        else:
            dates = pick_dates(
                sched["weekday"], semester_start, semester_end, sched_count
            )
        classroom_code = random.choice(list(classroom_map.keys()))
        for d in dates:
            # Slight offset from schedule times
            actual_start = time(
                sched["start_time"].hour,
                min(sched["start_time"].minute + random.randint(0, 10), 59),
            )
            actual_end = time(
                sched["end_time"].hour,
                max(sched["end_time"].minute - random.randint(0, 10), 0),
            )
            # Status distribution
            status = SessionStatus.FINISHED
            if d > TODAY:
                status = SessionStatus.SCHEDULED
            elif d == TODAY and session_total % 7 == 0:
                status = SessionStatus.ACTIVE
            elif session_total % 11 == 0:
                status = SessionStatus.CANCELED

            qr = uid()
            ses_id = uid()

            extended = False
            ext_reason = None
            # Extended mode for teacher indices 1 (José) and 3 (Ana)
            if (
                crec["teacher_idx"] in EXTENDED_TEACHERS
                and session_total % 3 == 0
                and status in (SessionStatus.FINISHED, SessionStatus.ACTIVE)
            ):
                extended = True
                ext_reason = random.choice(
                    [
                        "Clase práctica adicional",
                        "Repaso de contenido",
                        "Consulta de dudas",
                    ]
                )

            opens = datetime.combine(d, actual_start) - timedelta(minutes=10)
            closes = datetime.combine(d, actual_end)
            qr_exp = opens + timedelta(hours=1)

            session.add(
                Session(
                    id_session=ses_id,
                    id_class=crec["class_id"],
                    date=d,
                    actual_start_time=actual_start,
                    actual_end_time=actual_end,
                    status=status,
                    id_classroom=classroom_map[classroom_code],
                    qr_token=qr,
                    qr_expires=qr_exp,
                    opens_at=opens,
                    closes_at=closes,
                    extended_mode=extended,
                    extension_reason=ext_reason,
                )
            )
            session_records.append(
                dict(
                    session_id=ses_id,
                    class_id=crec["class_id"],
                    course_code=course_code,
                    subject_name=subj_name,
                    date=d,
                    weekday=sched["weekday"],
                    teacher_idx=crec["teacher_idx"],
                )
            )
            session_total += 1

    await session.flush()
    print(f"✓ 11. sessions: {session_total}")

    # Build lookup: sessions by class_id
    sessions_by_class: dict[str, list[dict]] = {}
    for srec in session_records:
        sessions_by_class.setdefault(srec["class_id"], []).append(srec)

    # ------------------------------------------------------------------
    # 12. Attendance
    # ------------------------------------------------------------------
    attendance_records: list[dict] = []
    attendance_total = 0

    for ses_rec in session_records:
        # Solo asistencias para Ciro y Dominga
        class_students = [
            s
            for s in students_by_course.get(ses_rec["course_code"], [])
            if s["email"] in ic_students_only
        ]
        for srec in class_students:
            # Simular flujo real:
            # - Si escaneó QR → PRESENT o LATE
            # - Si no escaneó y no justificó → PENDING (lo crea el sistema al finalizar)
            # - Si justificó → JUSTIFIED
            roll = random.random()
            if roll < 0.60:
                att_status = AttendanceStatus.PRESENT
                method = AttendanceMethod.QR
            elif roll < 0.78:
                att_status = AttendanceStatus.LATE
                method = AttendanceMethod.QR
            elif roll < 0.90:
                # No escaneó → queda PENDING hasta que el docente decida
                att_status = AttendanceStatus.PENDING
                method = None
            else:
                att_status = AttendanceStatus.JUSTIFIED
                method = AttendanceMethod.MANUAL
            record_dt = datetime.combine(
                ses_rec["date"], time(random.randint(7, 18), random.randint(0, 59))
            )

            # Justification logic
            justification = None
            id_teacher_justifies = None
            justification_date = None
            if att_status == AttendanceStatus.JUSTIFIED:
                justification = random.choice(
                    [
                        "Problemas de salud",
                        "Emergencia familiar",
                        "Viaje personal",
                        "Cita médica",
                    ]
                )
                just_teacher = random.choice(teacher_records)
                id_teacher_justifies = just_teacher["teacher_id"]
                justification_date = record_dt + timedelta(days=random.randint(0, 3))

            att_id = uid()
            session.add(
                Attendance(
                    id_attendance=att_id,
                    id_session=ses_rec["session_id"],
                    id_student=srec["student_id"],
                    status=att_status,
                    method=method,
                    record_date=record_dt,
                    ip_address=f"192.168.{random.randint(1, 254)}.{random.randint(1, 254)}",
                    justification=justification,
                    id_teacher_justifies=id_teacher_justifies,
                    justification_date=justification_date,
                )
            )
            attendance_records.append(
                dict(
                    attendance_id=att_id,
                    session_id=ses_rec["session_id"],
                    student_id=srec["student_id"],
                    status=att_status,
                )
            )
            attendance_total += 1

    await session.flush()
    print(f"✓ 12. attendance: {attendance_total}")

    # ------------------------------------------------------------------
    # 13. Attendance Events
    # ------------------------------------------------------------------
    event_total = 0
    for arec in attendance_records:
        # Create events for ~60% of attendances
        if random.random() > 0.6:
            continue
        ev_id = uid()
        ev_type = EventType.CREATION
        prev_st = None
        new_st = arec["status"].value if arec["status"] else None
        comment = None

        if arec["status"] == AttendanceStatus.JUSTIFIED:
            ev_type = EventType.JUSTIFICATION
            comment = random.choice(
                [
                    "Justificación aceptada",
                    "Justificación por enfermedad",
                ]
            )
        elif random.random() < 0.3 and arec["status"] != AttendanceStatus.PENDING:
            ev_type = EventType.STATUS_CHANGE
            prev_st = AttendanceStatus.PENDING.value
            new_st = arec["status"].value
            comment = "Cambio de estado manual"

        actor = random.choice(teacher_records)
        session.add(
            AttendanceEvent(
                id_event=ev_id,
                id_attendance=arec["attendance_id"],
                type=ev_type,
                previous_status=prev_st,
                new_status=new_st,
                comment=comment,
                id_actor=actor["teacher_id"],
            )
        )
        event_total += 1
    await session.flush()
    print(f"✓ 13. attendance_event: {event_total}")

    # ------------------------------------------------------------------
    # 14. Teacher Flags
    # ------------------------------------------------------------------
    flag_total = 0
    for trec in teacher_records:
        # Flag ~4 teachers
        if random.random() > 0.5:
            continue
        fl_id = uid()
        level = random.choice([FlagLevel.LOW, FlagLevel.MEDIUM, FlagLevel.HIGH])
        status = random.choice(
            [FlagStatus.ACTIVE, FlagStatus.UNDER_REVIEW, FlagStatus.CLOSED]
        )
        reason = random.choice(
            [
                "Ausencias repetitivas",
                "Retrasos frecuentes",
                "Reporte de estudiantes",
                "Irregularidades en registro de asistencia",
            ]
        )
        # Optional: link to a session
        session_id = None
        if random.random() < 0.4 and session_records:
            session_id = random.choice(session_records)["session_id"]
        session.add(
            TeacherFlag(
                id_flag=fl_id,
                id_teacher=trec["teacher_id"],
                reason=reason,
                level=level,
                status=status,
                session_id=session_id,
            )
        )
        flag_total += 1
    await session.flush()
    print(f"✓ 14. teacher_flags: {flag_total}")

    # ------------------------------------------------------------------
    # 15. Justification Attachments
    # ------------------------------------------------------------------
    attach_total = 0
    for arec in attendance_records:
        # Only attach to JUSTIFIED attendances and some others
        if arec["status"] != AttendanceStatus.JUSTIFIED and random.random() > 0.2:
            continue
        att_id = uid()
        file_type = random.choice([AttachmentType.IMAGE, AttachmentType.PDF])
        session.add(
            JustificationAttachment(
                id_attachment=att_id,
                id_attendance=arec["attendance_id"],
                file_url=f"/uploads/justificacion_{att_id[:8]}.{'jpg' if file_type == AttachmentType.IMAGE else 'pdf'}",
                type=file_type,
            )
        )
        attach_total += 1
    await session.flush()
    print(f"✓ 15. justification_attachment: {attach_total}")

    # ------------------------------------------------------------------
    # Commit
    # ------------------------------------------------------------------
    await session.commit()
    print("\n✅ Seed completado exitosamente.")
    print(
        f"   Resumen: areas={len(AREA_DEFS)}, cursos={len(COURSE_DEFS)}, "
        f"grupos={len(group_names)}, subjects={len(subj_list)}, "
        f"periodos={len(PERIOD_DEFS)}, aulas={len(classrooms)}"
    )
    print(
        f"   teachers={len(teachers_list)}, students={len(student_records)}, "
        f"classes={len(class_records)}"
    )
    print(
        f"   enrollments={enrollment_count}, sessiones={session_total}, "
        f"asistencias={attendance_total}"
    )
    print(f"   eventos={event_total}, flags={flag_total}, adjuntos={attach_total}")


# ---------------------------------------------------------------------------
# Entrypoint
# ---------------------------------------------------------------------------


async def main() -> None:
    engine = create_async_engine(settings.DATABASE_URL, echo=False)
    factory = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)
    async with factory() as session:
        await clear_data(session)
        await seed_all(session)
    await engine.dispose()


if __name__ == "__main__":
    asyncio.run(main())
