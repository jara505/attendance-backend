from pydantic import BaseModel, EmailStr


class UserProfileDTO(BaseModel):
    email: EmailStr
    role: str


class TeacherProfileDTO(UserProfileDTO):
    first_name: str
    last_name: str
    teacher_card: str


class StudentProfileDTO(UserProfileDTO):
    first_name: str
    last_name: str
    student_card: str
    course: str


class AdminProfileDTO(UserProfileDTO):
    """Admin doesn't have additional profile data"""
    pass