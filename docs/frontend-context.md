# Teacher Attendance Module — Frontend Context

## Endpoints

### `GET /api/v1/teacher/classes`

Lista todas las clases del docente autenticado.

**Response**
```json
{
  "classes": [
    {
      "id_class": "uuid",
      "subject": "Programación I",
      "course": "Ingeniería Informática",
      "group": "A",
      "year": 2026,
      "cycle": 1,
      "total_students": 25
    }
  ]
}
```

---

### `GET /api/v1/teacher/classes/{class_id}/attendance`

Asistencia detallada de todos los alumnos para una clase específica.

**Response**
```json
{
  "id_class": "uuid",
  "subject": "Programación I",
  "course": "Ingeniería Informática",
  "group": "A",
  "year": 2026,
  "cycle": 1,
  "total_sessions": 30,
  "total_students": 25,
  "students": [
    {
      "id_student": "uuid",
      "first_name": "Juan",
      "last_name": "Pérez",
      "student_card": "12345",
      "present": 20,
      "absent": 3,
      "late": 5,
      "justified": 2,
      "total": 30,
      "percentage": 90.0
    }
  ]
}
```

**Campos de `students[]`**

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `present` | int | Asistencias normales |
| `absent` | int | Ausencias |
| `late` | int | Llegadas tarde |
| `justified` | int | Faltas justificadas |
| `total` | int | Total de sesiones con registro |
| `percentage` | float | Porcentaje de asistencia `(present + late + justified) / total * 100` |

---

## Flujo de navegación sugerido

1. El docente entra al módulo → `GET /teacher/classes` → muestra lista de sus clases (materia, curso, grupo, año/semestre)
2. Selecciona una clase → `GET /teacher/classes/{id}/attendance` → tabla con todos los alumnos y sus métricas
3. Cada fila puede mostrar color según `percentage` (ej. verde ≥ 80, amarillo ≥ 60, rojo < 60)

## Consideraciones

- Ambos endpoints requieren `Authorization: Bearer <token>` con rol `TEACHER`
- El `percentage` considera PRESENT + LATE + JUSTIFIED como "asistió"
- Si un alumno no tiene registros (clase nueva), `total = 0` y `percentage = 100`
- No se requiere ningún permiso adicional ni flag de admin
