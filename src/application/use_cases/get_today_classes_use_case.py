from datetime import datetime
from src.application.dtos.academic_dto import TodayClassesResponse, TodayClassDTO
from src.infrastructure.repositories.academic_repository import AcademicRepository


class GetTodayClassesUseCase:
    def __init__(self, repository: AcademicRepository) -> None:
        self._repository = repository

    async def execute(self, teacher_id: str) -> TodayClassesResponse:
        """
        Obtiene las clases del teacher para el día de hoy.
        """
        now = datetime.now()
        current_time = now.time()
        current_weekday = now.strftime("%A")  # MONDAY, TUESDAY, etc.
        
        classes = await self._repository.get_today_classes_by_teacher(
            teacher_id=teacher_id,
            current_time=current_time,
            current_weekday=current_weekday,
        )
        
        # Convertir a DTOs
        class_dtos = [
            TodayClassDTO(
                id_class=c["id_class"],
                course=c["course"],
                group=c["group"],
                subject=c["subject"],
                classroom=c["classroom"],
                start_time=c["start_time"],
                end_time=c["end_time"],
                status=c["status"],
                qr_available=c["qr_available"],
                remaining_minutes=c["remaining_minutes"],
            )
            for c in classes
        ]
        
        return TodayClassesResponse(
            classes=class_dtos,
            date=now.strftime("%Y-%m-%d"),
        )