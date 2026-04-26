import enum
from datetime import datetime
from uuid import uuid4

from sqlalchemy import ForeignKey, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from src.infrastructure.database import Base


class EventType(str, enum.Enum):
    CREATION = "CREATION"
    STATUS_CHANGE = "STATUS_CHANGE"
    JUSTIFICATION = "JUSTIFICATION"


class FlagLevel(str, enum.Enum):
    LOW = "LOW"
    MEDIUM = "MEDIUM"
    HIGH = "HIGH"


class FlagStatus(str, enum.Enum):
    ACTIVE = "ACTIVE"
    UNDER_REVIEW = "UNDER_REVIEW"
    CLOSED = "CLOSED"


class AttendanceEvent(Base):
    __tablename__ = "attendance_event"

    id_event: Mapped[str] = mapped_column(
        String, primary_key=True, default=lambda: str(uuid4())
    )
    id_attendance: Mapped[str] = mapped_column(
        ForeignKey("attendance.id_attendance"), nullable=False
    )
    type: Mapped[EventType | None] = mapped_column(default=None)
    previous_status: Mapped[str | None] = mapped_column(String, default=None)
    new_status: Mapped[str | None] = mapped_column(String, default=None)
    comment: Mapped[str | None] = mapped_column(String, default=None)
    id_actor: Mapped[str] = mapped_column(
        ForeignKey("teachers.id_teacher"), nullable=False
    )
    date: Mapped[datetime | None] = mapped_column(default=datetime.now)

    attendance: Mapped["Attendance"] = relationship(  # noqa: F821
        back_populates="events"
    )
    actor: Mapped["Teacher"] = relationship(  # noqa: F821
        back_populates="events_authored"
    )


class TeacherFlag(Base):
    __tablename__ = "teacher_flags"

    id_flag: Mapped[str] = mapped_column(
        String, primary_key=True, default=lambda: str(uuid4())
    )
    id_teacher: Mapped[str] = mapped_column(
        ForeignKey("teachers.id_teacher"), nullable=False
    )
    reason: Mapped[str | None] = mapped_column(String, default=None)
    level: Mapped[FlagLevel | None] = mapped_column(default=None)
    status: Mapped[FlagStatus | None] = mapped_column(default=None)
    creation_date: Mapped[datetime | None] = mapped_column(default=datetime.now)
    session_id: Mapped[str | None] = mapped_column(
        ForeignKey("sessions.id_session"), default=None
    )

    teacher: Mapped["Teacher"] = relationship(back_populates="flags")  # noqa: F821
