from datetime import date, datetime, time, timedelta
from uuid import uuid4

from sqlalchemy import select, and_
from sqlalchemy.ext.asyncio import AsyncSession

from src.domain.repositories.session_repository import SessionRepositoryPort
from src.infrastructure.models.session_models import Session, SessionStatus


class SQLAlchemySessionRepository(SessionRepositoryPort):
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_by_id(self, session_id: str) -> Session | None:
        stmt = select(Session).where(Session.id_session == session_id)
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

    async def get_by_class_and_date(
        self, class_id: str, session_date: date
    ) -> Session | None:
        stmt = (
            select(Session)
            .where(
                and_(
                    Session.id_class == class_id,
                    Session.date == session_date
                )
            )
            .limit(1)
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

    async def get_active_by_class(self, class_id: str) -> Session | None:
        stmt = select(Session).where(
            and_(
                Session.id_class == class_id,
                Session.status == SessionStatus.ACTIVE
            )
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

    async def create(
        self,
        id_class: str,
        id_classroom: str,
        session_date: date,
    ) -> Session:
        session = Session(
            id_session=str(uuid4()),
            id_class=id_class,
            id_classroom=id_classroom,
            date=session_date,
            status=SessionStatus.SCHEDULED,
            qr_token=str(uuid4()),
        )
        self._session.add(session)
        await self._session.commit()
        await self._session.refresh(session)
        return session

    async def activate(
        self,
        session_id: str,
        actual_start_time: time,
        qr_token: str,
        opens_at: datetime,
        closes_at: datetime,
    ) -> Session:
        stmt = select(Session).where(Session.id_session == session_id)
        result = await self._session.execute(stmt)
        session = result.scalar_one()
        
        session.status = SessionStatus.ACTIVE
        session.actual_start_time = actual_start_time
        session.qr_token = qr_token
        session.opens_at = opens_at
        session.closes_at = closes_at
        
        await self._session.commit()
        await self._session.refresh(session)
        return session

    async def finish(
        self,
        session_id: str,
        actual_end_time: time,
    ) -> Session:
        stmt = select(Session).where(Session.id_session == session_id)
        result = await self._session.execute(stmt)
        session = result.scalar_one()
        
        session.status = SessionStatus.FINISHED
        session.actual_end_time = actual_end_time
        
        await self._session.commit()
        await self._session.refresh(session)
        return session

    async def extend(
        self,
        session_id: str,
        extension_minutes: int,
    ) -> Session:
        stmt = select(Session).where(Session.id_session == session_id)
        result = await self._session.execute(stmt)
        session = result.scalar_one()
        
        session.extended_mode = True
        if session.closes_at:
            session.closes_at = session.closes_at + timedelta(minutes=extension_minutes)
        
        await self._session.commit()
        await self._session.refresh(session)
        return session

    async def get_by_qr_token(self, qr_token: str) -> Session | None:
        stmt = select(Session).where(Session.qr_token == qr_token)
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()