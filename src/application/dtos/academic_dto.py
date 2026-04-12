from datetime import time
from enum import Enum
from pydantic import BaseModel


class ClassStatus(str, Enum):
    ACTIVE = "ACTIVE"
    FUTURE = "FUTURE"
    PAST = "PAST"


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


class TodayClassesResponse(BaseModel):
    classes: list[TodayClassDTO]
    date: str