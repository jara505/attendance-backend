import enum
import datetime as dt
from uuid import uuid4

from sqlalchemy import ForeignKey, String, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from src.infrastructure.database import Base


class SessionStatus(str, enum.Enum):
    SCHEDULED = "SCHEDULED"
    ACTIVE = "ACTIVE"
    CANCELED = "CANCELED"
    FINISHED = "FINISHED"


class AttendanceStatus(str, enum.Enum):
    PRESENT = "PRESENT"
    ABSENT = "ABSENT"
    LATE = "LATE"
    JUSTIFIED = "JUSTIFIED"


class AttendanceMethod(str, enum.Enum):
    QR = "QR"
    MANUAL = "MANUAL"


class AttachmentType(str, enum.Enum):
    IMAGE = "IMAGE"
    PDF = "PDF"


class Session(Base):
    __tablename__ = "sessions"

    id_session: Mapped[str] = mapped_column(
        String, primary_key=True, default=lambda: str(uuid4())
    )
    id_class: Mapped[str] = mapped_column(
        ForeignKey("classes.id_class"), nullable=False
    )
    date: Mapped[dt.date] = mapped_column(nullable=False)
    actual_start_time: Mapped[dt.time | None] = mapped_column(default=None)
    actual_end_time: Mapped[dt.time | None] = mapped_column(default=None)
    status: Mapped[SessionStatus] = mapped_column(nullable=False)
    id_classroom: Mapped[str] = mapped_column(
        ForeignKey("classrooms.id_classroom"), nullable=False
    )
    qr_token: Mapped[str] = mapped_column(String, unique=True, nullable=False)
    qr_expires: Mapped[dt.datetime | None] = mapped_column(default=None)
    opens_at: Mapped[dt.datetime | None] = mapped_column(default=None)
    closes_at: Mapped[dt.datetime | None] = mapped_column(default=None)
    extended_mode: Mapped[bool] = mapped_column(default=False)
    extension_reason: Mapped[str | None] = mapped_column(String, default=None)
    close_notification_minutes: Mapped[int | None] = mapped_column(default=None)

    class_: Mapped["Class"] = relationship(back_populates="sessions")  # noqa: F821
    classroom: Mapped["Classroom"] = relationship(  # noqa: F821
        back_populates="sessions"
    )
    attendances: Mapped[list["Attendance"]] = relationship(back_populates="session")


class Attendance(Base):
    __tablename__ = "attendance"
    __table_args__ = (UniqueConstraint("id_session", "id_student"),)

    id_attendance: Mapped[str] = mapped_column(
        String, primary_key=True, default=lambda: str(uuid4())
    )
    id_session: Mapped[str] = mapped_column(
        ForeignKey("sessions.id_session"), nullable=False
    )
    id_student: Mapped[str] = mapped_column(
        ForeignKey("students.id_student"), nullable=False
    )
    status: Mapped[AttendanceStatus | None] = mapped_column(default=None)
    method: Mapped[AttendanceMethod | None] = mapped_column(default=None)
    record_date: Mapped[dt.datetime | None] = mapped_column(default=dt.datetime.now)
    ip_address: Mapped[str | None] = mapped_column(String, default=None)
    latitude: Mapped[float | None] = mapped_column(default=None)
    longitude: Mapped[float | None] = mapped_column(default=None)
    justification: Mapped[str | None] = mapped_column(String, default=None)
    id_teacher_justifies: Mapped[str | None] = mapped_column(
        ForeignKey("teachers.id_teacher"), default=None
    )
    justification_date: Mapped[dt.datetime | None] = mapped_column(default=None)

    session: Mapped["Session"] = relationship(back_populates="attendances")
    student: Mapped["Student"] = relationship(back_populates="attendances")  # noqa: F821
    teacher_justifier: Mapped["Teacher | None"] = relationship(  # noqa: F821
        back_populates="justified_attendances",
        foreign_keys=[id_teacher_justifies],
    )
    attachments: Mapped[list["JustificationAttachment"]] = relationship(
        back_populates="attendance"
    )
    events: Mapped[list["AttendanceEvent"]] = relationship(  # noqa: F821
        back_populates="attendance"
    )


class JustificationAttachment(Base):
    __tablename__ = "justification_attachment"

    id_attachment: Mapped[str] = mapped_column(
        String, primary_key=True, default=lambda: str(uuid4())
    )
    id_attendance: Mapped[str] = mapped_column(
        ForeignKey("attendance.id_attendance"), nullable=False
    )
    file_url: Mapped[str] = mapped_column(String, nullable=False)
    type: Mapped[AttachmentType | None] = mapped_column(default=None)
    upload_date: Mapped[dt.datetime | None] = mapped_column(default=dt.datetime.now)

    attendance: Mapped["Attendance"] = relationship(back_populates="attachments")
