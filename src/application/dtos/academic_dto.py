from datetime import datetime, time
from enum import Enum
from pydantic import BaseModel


class ClassStatus(str, Enum):
    ACTIVE = "ACTIVE"
    FUTURE = "FUTURE"
    PAST = "PAST"


class SessionStatus(str, Enum):
    SCHEDULED = "SCHEDULED"
    ACTIVE = "ACTIVE"
    FINISHED = "FINISHED"


class TodayClassDTO(BaseModel):
    id_class: str
    course: str
    group: str
    subject: str
    classroom: str
    start_time: str
    end_time: str
    status: ClassStatus
    qr_available: bool
    remaining_minutes: int | None = None
    session_id: str | None = None
    session_status: SessionStatus | None = None
    can_check_in: bool = False
    extended_mode: bool = False
    check_in_time: datetime | None = None
    attendance_status: str | None = None  # PRESENT / LATE / ABSENT / JUSTIFIED


class TodayClassesResponse(BaseModel):
    classes: list[TodayClassDTO]
    date: str


# Student Attendance DTOs
class SubjectAttendanceSummary(BaseModel):
    subject_id: str
    subject_name: str
    present: int
    absent: int
    late: int
    percentage: int
    status: str  # "OK" or "ALERTA"


class SemesterAttendanceResponse(BaseModel):
    semester: str
    courses: list[SubjectAttendanceSummary]


class DayAttendance(BaseModel):
    day: int
    status: str | None  # "PRESENT", "ABSENT", "LATE", "JUSTIFIED", or null


class SubjectAttendanceDetail(BaseModel):
    subject_name: str
    month: str
    days: list[DayAttendance]


# ──────────────────────────────────────────
# Teacher Attendance DTOs
# ──────────────────────────────────────────


class TeacherClassItem(BaseModel):
    id_class: str
    subject: str
    course: str
    group: str
    year: int
    cycle: int
    total_students: int


class TeacherClassesListResponse(BaseModel):
    classes: list[TeacherClassItem]


class StudentAttendanceSummary(BaseModel):
    id_student: str
    first_name: str
    last_name: str
    student_card: str
    present: int = 0
    absent: int = 0
    late: int = 0
    justified: int = 0
    total: int = 0
    percentage: float = 100.0


class ClassAttendanceResponse(BaseModel):
    id_class: str
    subject: str
    course: str
    group: str
    year: int
    cycle: int
    total_sessions: int
    total_students: int
    students: list[StudentAttendanceSummary]
