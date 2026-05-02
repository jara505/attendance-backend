from pydantic import BaseModel, EmailStr


class UserProfileDTO(BaseModel):
    email: EmailStr
    role: str


class TeacherProfileDTO(UserProfileDTO):
    first_name: str
    last_name: str
    teacher_card: str
    photo_url: str | None = None


class StudentProfileDTO(UserProfileDTO):
    first_name: str
    last_name: str
    student_card: str
    course: str
    photo_url: str | None = None


class AdminProfileDTO(UserProfileDTO):
    """Admin doesn't have additional profile data"""
    pass