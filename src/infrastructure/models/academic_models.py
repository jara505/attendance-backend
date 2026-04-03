import enum
from datetime import date
from uuid import uuid4

from sqlalchemy import String, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import ForeignKey

from src.infrastructure.database import Base


class CycleEnum(int, enum.Enum):
    FIRST = 1
    SECOND = 2


class KnowledgeArea(Base):
    __tablename__ = "knowledge_area"

    id_area: Mapped[str] = mapped_column(
        String, primary_key=True, default=lambda: str(uuid4())
    )
    name: Mapped[str] = mapped_column(String, nullable=False)

    courses: Mapped[list["Course"]] = relationship(back_populates="area")


class Course(Base):
    __tablename__ = "courses"

    id_course: Mapped[str] = mapped_column(
        String, primary_key=True, default=lambda: str(uuid4())
    )
    name: Mapped[str] = mapped_column(String, nullable=False)
    id_area: Mapped[str] = mapped_column(
        ForeignKey("knowledge_area.id_area"), nullable=False
    )
    duration_years: Mapped[int | None] = mapped_column(default=None)

    area: Mapped["KnowledgeArea"] = relationship(back_populates="courses")
    subjects: Mapped[list["Subject"]] = relationship(back_populates="course")
    students: Mapped[list["Student"]] = relationship(  # noqa: F821
        back_populates="course"
    )


class Group(Base):
    __tablename__ = "groups_"

    id_group: Mapped[str] = mapped_column(
        String, primary_key=True, default=lambda: str(uuid4())
    )
    code: Mapped[str] = mapped_column(String, nullable=False)

    classes: Mapped[list["Class"]] = relationship(back_populates="group")  # noqa: F821


class Subject(Base):
    __tablename__ = "subjects"

    id_subject: Mapped[str] = mapped_column(
        String, primary_key=True, default=lambda: str(uuid4())
    )
    name: Mapped[str] = mapped_column(String, nullable=False)
    id_course: Mapped[str] = mapped_column(
        ForeignKey("courses.id_course"), nullable=False
    )

    course: Mapped["Course"] = relationship(back_populates="subjects")
    classes: Mapped[list["Class"]] = relationship(back_populates="subject")  # noqa: F821


class Period(Base):
    __tablename__ = "periods"
    __table_args__ = (UniqueConstraint("year", "cycle"),)

    id_period: Mapped[str] = mapped_column(
        String, primary_key=True, default=lambda: str(uuid4())
    )
    year: Mapped[int] = mapped_column(nullable=False)
    cycle: Mapped[CycleEnum] = mapped_column(nullable=False)
    start_date: Mapped[date | None] = mapped_column(default=None)
    end_date: Mapped[date | None] = mapped_column(default=None)

    classes: Mapped[list["Class"]] = relationship(back_populates="period")  # noqa: F821
