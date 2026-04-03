import enum
from datetime import time
from uuid import uuid4

from sqlalchemy import ForeignKey, String, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from src.infrastructure.database import Base


class WeekDay(str, enum.Enum):
    MON = "MON"
    TUE = "TUE"
    WED = "WED"
    THU = "THU"
    FRI = "FRI"
    SAT = "SAT"
    SUN = "SUN"


class Shift(str, enum.Enum):
    MORNING = "MORNING"
    AFTERNOON = "AFTERNOON"


class Class(Base):
    __tablename__ = "classes"

    id_class: Mapped[str] = mapped_column(
        String, primary_key=True, default=lambda: str(uuid4())
    )
    id_teacher: Mapped[str] = mapped_column(
        ForeignKey("teachers.id_teacher"), nullable=False
    )
    id_subject: Mapped[str] = mapped_column(
        ForeignKey("subjects.id_subject"), nullable=False
    )
    id_group: Mapped[str] = mapped_column(
        ForeignKey("groups_.id_group"), nullable=False
    )
    id_period: Mapped[str] = mapped_column(
        ForeignKey("periods.id_period"), nullable=False
    )

    teacher: Mapped["Teacher"] = relationship(back_populates="classes")  # noqa: F821
    subject: Mapped["Subject"] = relationship(back_populates="classes")  # noqa: F821
    group: Mapped["Group"] = relationship(back_populates="classes")  # noqa: F821
    period: Mapped["Period"] = relationship(back_populates="classes")  # noqa: F821
    enrollments: Mapped[list["Enrollment"]] = relationship(back_populates="class_")
    schedules: Mapped[list["Schedule"]] = relationship(back_populates="class_")
    sessions: Mapped[list["Session"]] = relationship(  # noqa: F821
        back_populates="class_"
    )


class Enrollment(Base):
    __tablename__ = "enrollments"
    __table_args__ = (UniqueConstraint("id_student", "id_class"),)

    id_enrollment: Mapped[str] = mapped_column(
        String, primary_key=True, default=lambda: str(uuid4())
    )
    id_student: Mapped[str] = mapped_column(
        ForeignKey("students.id_student"), nullable=False
    )
    id_class: Mapped[str] = mapped_column(
        ForeignKey("classes.id_class"), nullable=False
    )

    student: Mapped["Student"] = relationship(back_populates="enrollments")  # noqa: F821
    class_: Mapped["Class"] = relationship(back_populates="enrollments")


class Classroom(Base):
    __tablename__ = "classrooms"

    id_classroom: Mapped[str] = mapped_column(
        String, primary_key=True, default=lambda: str(uuid4())
    )
    pavilion: Mapped[str] = mapped_column(String, nullable=False)
    type: Mapped[str] = mapped_column(String, nullable=False)
    latitude: Mapped[float | None] = mapped_column(default=None)
    longitude: Mapped[float | None] = mapped_column(default=None)
    allowed_radius: Mapped[float | None] = mapped_column(default=None)

    schedules: Mapped[list["Schedule"]] = relationship(back_populates="classroom")
    sessions: Mapped[list["Session"]] = relationship(  # noqa: F821
        back_populates="classroom"
    )


class Schedule(Base):
    __tablename__ = "schedule"

    id_schedule: Mapped[str] = mapped_column(
        String, primary_key=True, default=lambda: str(uuid4())
    )
    id_class: Mapped[str] = mapped_column(
        ForeignKey("classes.id_class"), nullable=False
    )
    weekday: Mapped[WeekDay] = mapped_column(nullable=False)
    start_time: Mapped[time] = mapped_column(nullable=False)
    end_time: Mapped[time] = mapped_column(nullable=False)
    shift: Mapped[Shift] = mapped_column(nullable=False)
    id_classroom: Mapped[str] = mapped_column(
        ForeignKey("classrooms.id_classroom"), nullable=False
    )

    class_: Mapped["Class"] = relationship(back_populates="schedules")
    classroom: Mapped["Classroom"] = relationship(back_populates="schedules")
