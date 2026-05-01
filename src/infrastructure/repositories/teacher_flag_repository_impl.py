from datetime import date, datetime
from uuid import uuid4

from sqlalchemy import select, and_, func, cast, String
from sqlalchemy.ext.asyncio import AsyncSession

from src.domain.repositories.teacher_flag_repository import TeacherFlagRepositoryPort
from src.infrastructure.models.audit_models import TeacherFlag, FlagLevel, FlagStatus


class SQLAlchemyTeacherFlagRepository(TeacherFlagRepositoryPort):
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def create_flag(
        self,
        id_teacher: str,
        reason: str,
        session_id: str,
        level: FlagLevel = FlagLevel.LOW,
    ) -> None:
        flag = TeacherFlag(
            id_flag=str(uuid4()),
            id_teacher=id_teacher,
            reason=reason,
            level=level,
            status=FlagStatus.ACTIVE,
            creation_date=datetime.now(),
            session_id=session_id,
        )
        self._session.add(flag)
        await self._session.commit()

    async def count_extensions_today(self, id_teacher: str, today: date) -> int:
        stmt = select(func.count()).where(
            and_(
                TeacherFlag.id_teacher == id_teacher,
                TeacherFlag.reason.in_(["EXTENDED_MODE", "REOPEN_MODE"]),
                cast(TeacherFlag.creation_date, String).like(f"{today}%"),
            )
        )
        result = await self._session.execute(stmt)
        return result.scalar() or 0