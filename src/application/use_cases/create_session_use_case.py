from datetime import date, timedelta
from src.application.dtos.session_dto import CreateSessionRequest, SessionResponse
from src.domain.exceptions.session_exceptions import (
    ClassNotFoundError,
    UnauthorizedSessionAccessError,
    SessionAlreadyExistsError,
    SessionDateInPastError,
)
from src.infrastructure.models.class_models import WeekDay


class CreateSessionUseCase:
    def __init__(self, repository, class_repository):
        self.repository = repository
        self.class_repository = class_repository

    async def execute(
        self, request: CreateSessionRequest, teacher_id: str
    ) -> SessionResponse:
        cls = await self.class_repository.get_class_by_id(request.id_class)
        if cls is None:
            raise ClassNotFoundError(request.id_class)

        if cls.id_teacher != teacher_id:
            raise UnauthorizedSessionAccessError()

        weekday_map = {
            0: WeekDay.MON,
            1: WeekDay.TUE,
            2: WeekDay.WED,
            3: WeekDay.THU,
            4: WeekDay.FRI,
            5: WeekDay.SAT,
            6: WeekDay.SUN,
        }

        # Solo permitir crear sesión para hoy (o permitir cualquier fecha si el schedule existe)
        # Por ahora aceptar cualquier fecha que coincida con el schedule
        if request.session_date > date.today() + timedelta(days=7):
            raise SessionDateInPastError(
                f"Cannot create session for date {request.session_date}"
            )

        session_weekday = weekday_map[request.session_date.weekday()]
        schedule = next(
            (s for s in cls.schedules if s.weekday == session_weekday), None
        )

        if schedule is None:
            raise Exception("No schedule for this day")

        # Verificar que no existe sesión para ese día
        existing_session = await self.repository.get_by_class_and_date(
            request.id_class, request.session_date
        )
        if existing_session is not None:
            raise SessionAlreadyExistsError(
                request.id_class, 
                str(request.session_date),
                existing_session.id_session
            )

        session = await self.repository.create(
            id_class=request.id_class,
            id_classroom=schedule.classroom.id_classroom,
            session_date=request.session_date,
        )

        return SessionResponse(
            id_session=session.id_session,
            id_class=session.id_class,
            id_classroom=session.id_classroom,
            date=session.date,
            status=session.status,
        )
