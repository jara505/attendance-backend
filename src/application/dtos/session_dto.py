from datetime import date, time
from enum import Enum

from pydantic import BaseModel


class SessionStatusEnum(str, Enum):
    SCHEDULED = "SCHEDULED"
    ACTIVE = "ACTIVE"
    CANCELED = "CANCELED"
    FINISHED = "FINISHED"


class CreateSessionRequest(BaseModel):
    id_class: str
    session_date: date


class SessionResponse(BaseModel):
    id_session: str
    id_class: str
    id_classroom: str
    date: date
    status: SessionStatusEnum
    actual_start_time: time | None = None
    actual_end_time: time | None = None
    qr_token: str | None = None
    qr_expires: str | None = None
    extended_mode: bool = False


class ActivateSessionRequest(BaseModel):
    qr_duration_minutes: int = 10


class ExtendSessionRequest(BaseModel):
    extension_minutes: int = 15


class QRResponse(BaseModel):
    qr_token: str
    expires_at: str
    class_id: str
    session_id: str


class ExtendSessionResponse(BaseModel):
    id_session: str
    extended_mode: bool
    qr_expires: str | None = None
    extensions_today: int