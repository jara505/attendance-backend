import enum
from datetime import datetime
from uuid import uuid4

from sqlalchemy import ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from src.infrastructure.database import Base


class UserRole(str, enum.Enum):
    STUDENT = "STUDENT"
    TEACHER = "TEACHER"
    ADMIN = "ADMIN"


class User(Base):
    __tablename__ = "users"

    id_user: Mapped[str] = mapped_column(
        String, primary_key=True, default=lambda: str(uuid4())
    )
    email: Mapped[str] = mapped_column(String, unique=True, nullable=False)
    password_hash: Mapped[str] = mapped_column(String, nullable=False)
    role: Mapped[UserRole] = mapped_column(nullable=False)
    must_change_password: Mapped[bool] = mapped_column(default=True, nullable=False)
    created_at: Mapped[datetime | None] = mapped_column(default=datetime.now)
    deleted_at: Mapped[datetime | None] = mapped_column(default=None)

    student: Mapped["Student | None"] = relationship(back_populates="user")
    teacher: Mapped["Teacher | None"] = relationship(back_populates="user")


class Student(Base):
    __tablename__ = "students"

    id_student: Mapped[str] = mapped_column(
        String, primary_key=True, default=lambda: str(uuid4())
    )
    first_name: Mapped[str] = mapped_column(String, nullable=False)
    last_name: Mapped[str] = mapped_column(String, nullable=False)
    student_card: Mapped[str] = mapped_column(String, unique=True, nullable=False)
    id_course: Mapped[str] = mapped_column(
        ForeignKey("courses.id_course"), nullable=False
    )
    id_user: Mapped[str] = mapped_column(
        ForeignKey("users.id_user"), unique=True, nullable=False
    )
    deleted_at: Mapped[datetime | None] = mapped_column(default=None)
    editable_fields: Mapped[str | None] = mapped_column(String, default=None)

    user: Mapped["User"] = relationship(back_populates="student")
    course: Mapped["Course"] = relationship(back_populates="students")  # noqa: F821
    enrollments: Mapped[list["Enrollment"]] = relationship(  # noqa: F821
        back_populates="student"
    )
    attendances: Mapped[list["Attendance"]] = relationship(  # noqa: F821
        back_populates="student"
    )


class Teacher(Base):
    __tablename__ = "teachers"

    id_teacher: Mapped[str] = mapped_column(
        String, primary_key=True, default=lambda: str(uuid4())
    )
    first_name: Mapped[str] = mapped_column(String, nullable=False)
    last_name: Mapped[str] = mapped_column(String, nullable=False)
    teacher_card: Mapped[str] = mapped_column(String, unique=True, nullable=False)
    id_user: Mapped[str] = mapped_column(
        ForeignKey("users.id_user"), unique=True, nullable=False
    )
    modifications_count: Mapped[int] = mapped_column(default=0)
    teacher_flag: Mapped[bool] = mapped_column(default=False)
    must_change_password: Mapped[bool] = mapped_column(default=True)
    deleted_at: Mapped[datetime | None] = mapped_column(default=None)

    user: Mapped["User"] = relationship(back_populates="teacher")
    classes: Mapped[list["Class"]] = relationship(back_populates="teacher")  # noqa: F821
    flags: Mapped[list["TeacherFlag"]] = relationship(  # noqa: F821
        back_populates="teacher"
    )
    justified_attendances: Mapped[list["Attendance"]] = relationship(  # noqa: F821
        back_populates="teacher_justifier",
        foreign_keys="[Attendance.id_teacher_justifies]",
    )
    events_authored: Mapped[list["AttendanceEvent"]] = relationship(  # noqa: F821
        back_populates="actor"
    )
