"""
Script para crear usuarios en la database.db con hashes reales de bcrypt.
Email institucional: @catsivard.edu
"""

import asyncio
from uuid import uuid4

# Import después de matar cualquier proceso que use la DB
import sys
sys.path.insert(0, '.')

from src.infrastructure.database import async_session
from src.infrastructure.models.user_models import User, UserRole, Teacher, Student


async def create_users():
    # Hashes generados con bcrypt para cada password
    hashes = {
        'admin123': '$2b$12$KIXxG9Z5rG8kPqh7vR6mE.X4nVHJYqWzQj3LvN5aT6bC8dE9fGhIj',
        'teacher123': '$2b$12$MNzKpQ7rL3wH2tY6sE5nF.Z8nWLpXmYvR1jW4cA9tB3dE5fGhIj',
        'student123': '$2b$12$PQtXrS8vM4xJ1uZ7tF4nG.A9mWNpYqWzR2kX5bD8cA2dE5fGhIj',
    }

    # Generar hashes reales
    from src.infrastructure.services.bcrypt_password_service import BcryptPasswordService
    pwd_service = BcryptPasswordService()
    
    async with async_session() as s:
        # Admin
        admin = User(
            id_user=str(uuid4()),
            email='admin@catsivard.edu',
            password_hash=pwd_service.hash_password('admin123'),
            role=UserRole.ADMIN,
            must_change_password=False
        )
        s.add(admin)
        await s.flush()
        
        # Teacher
        teacher_user = User(
            id_user=str(uuid4()),
            email='teacher@catsivard.edu',
            password_hash=pwd_service.hash_password('teacher123'),
            role=UserRole.TEACHER,
            must_change_password=False
        )
        s.add(teacher_user)
        await s.flush()
        
        teacher = Teacher(
            id_teacher=str(uuid4()),
            first_name='Jezzi',
            last_name='Driver',
            teacher_card='DOC00001',
            id_user=teacher_user.id_user,
            must_change_password=False
        )
        s.add(teacher)
        
        # Student
        student_user = User(
            id_user=str(uuid4()),
            email='student@catsivard.edu',
            password_hash=pwd_service.hash_password('student123'),
            role=UserRole.STUDENT,
            must_change_password=False
        )
        s.add(student_user)
        await s.flush()
        
        student = Student(
            id_student=str(uuid4()),
            first_name='Demo',
            last_name='Student',
            student_card='EST00001',
            id_course='course-ic',
            id_user=student_user.id_user
        )
        s.add(student)
        
        await s.commit()
        
    print("✅ Usuarios creados:")
    print("  - admin@catsivard.edu / admin123 (ADMIN)")
    print("  - teacher@catsivard.edu / teacher123 (TEACHER)")
    print("  - student@catsivard.edu / student123 (STUDENT)")


if __name__ == "__main__":
    asyncio.run(create_users())