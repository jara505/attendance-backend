from datetime import time
from pydantic import BaseModel
from src.infrastructure.models.class_models import WeekDay


class UpdateScheduleRequest(BaseModel):
    weekday: WeekDay
    start_time: time
    end_time: time
    classroom: str | None = None


class UpdateScheduleResponse(BaseModel):
    id_class: str
    message: str


class TeacherDTO(BaseModel):
    id_teacher: str
    first_name: str
    last_name: str
    email: str


class ScheduleDTO(BaseModel):
    weekday: WeekDay
    start_time: time
    end_time: time
    classroom: str


class ClassDTO(BaseModel):
    id_class: str
    subject: str
    course: str
    group: str
    schedules: list[ScheduleDTO]


class TeacherClassesDTO(BaseModel):
    teacher: TeacherDTO
    classes: list[ClassDTO]
