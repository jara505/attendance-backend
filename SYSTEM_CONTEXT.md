# Attendance Backend — Agent Context

Backend FastAPI para registro de asistencia universitaria mediante QR.
Documento orientado a IA: contexto mínimo y suficiente para generar/modificar código sin leer todo el repo.

---

## 1. Stack

- **Lenguaje**: Python `>=3.12,<3.15`
- **Framework**: FastAPI + Uvicorn
- **ORM**: SQLAlchemy 2.0 (async) + aiosqlite
- **DB**: SQLite (`database.db`)
- **Auth**: JWT (PyJWT, HS256) + Bearer
- **Hash**: bcrypt
- **Config**: pydantic-settings (`.env`)
- **Serialización**: orjson
- **Gestor**: Poetry (`pyproject.toml`) — también `requirements.txt`

---

## 2. Arquitectura — Clean Architecture

Implementación basada en **Clean Architecture** (Robert C. Martin) con 4 capas concéntricas.
Las dependencias apuntan **hacia adentro**: las capas externas dependen de las internas, nunca al revés.

```
        ┌─────────────────────────────────────────────┐
        │              api  (FastAPI)                 │  ← Interface Adapters
        │  routers, dependencies, HTTP mapping        │
        │  ┌───────────────────────────────────────┐  │
        │  │         application                   │  │  ← Use Cases
        │  │  use_cases, dtos, interfaces (ports)  │  │
        │  │  ┌─────────────────────────────────┐  │  │
        │  │  │          domain                 │  │  │  ← Entities / Business Rules
        │  │  │  entities, value_objects,       │  │  │
        │  │  │  repositories (abstract),       │  │  │
        │  │  │  exceptions                     │  │  │
        │  │  └─────────────────────────────────┘  │  │
        │  └───────────────────────────────────────┘  │
        └─────────────────────────────────────────────┘
                          ▲
                          │ implementa puertos
        ┌─────────────────┴───────────────────────────┐
        │           infrastructure                    │  ← Frameworks & Drivers
        │  SQLAlchemy models, repos impl, services    │
        │  (bcrypt, jwt), config, database, adapters  │
        └─────────────────────────────────────────────┘
```

### Reglas
- `domain` no importa nada de otras capas (núcleo puro).
- `application` define **puertos** (interfaces) e implementa **use cases**; depende solo de `domain`.
- `infrastructure` implementa los puertos (SQLAlchemy, JWT, bcrypt).
- `api` orquesta: recibe HTTP, invoca use cases vía DI, mapea errores de dominio a HTTP.
- Inversión de dependencias: los use cases reciben repositorios por constructor (inyección).

```
src/
├── main.py                  # App FastAPI, middlewares, routers
├── api/
│   ├── dependencies.py      # DI: session, auth, use cases
│   └── routes/              # Routers (auth, academic, profile, session, attendance)
├── application/
│   ├── dtos/                # Pydantic request/response
│   ├── interfaces/          # Puertos (repos, services)
│   └── use_cases/           # Lógica de negocio
├── domain/
│   ├── entities/            # Entidades de dominio
│   ├── value_objects/
│   ├── repositories/        # Interfaces
│   └── exceptions/          # Errores tipados
└── infrastructure/
    ├── config.py            # Settings
    ├── database.py          # engine, async_session, Base
    ├── models/              # SQLAlchemy ORM
    ├── repositories/        # Implementaciones SQLAlchemy
    ├── services/            # bcrypt, jwt
    └── adapters/
```

Inyección de dependencias mediante `fastapi.Depends` en `src/api/dependencies.py`.

---

## 3. Configuración (`.env`)

| Variable | Default | Notas |
|---|---|---|
| `DATABASE_URL` | `sqlite+aiosqlite:///database.db` | Async driver obligatorio |
| `JWT_SECRET_KEY` | — | **Requerido** |
| `ALGORITHM` | `HS256` | Alias: `JWT_ALGORITHM` |
| `ACCESS_TOKEN_EXPIRATION_MINUTES` | — | **Requerido** |

`extra="ignore"` en Settings: variables no listadas se descartan.

---

## 4. API (prefijo `/api/v1`)

Auth: `Authorization: Bearer <jwt>`. JWT payload usa `sub = id_user`.

### `/auth`
- `POST /login` → `LoginResponse` (token)
- `POST /change-password` 🔒

### `/academic`
- `GET /my-classes` 🔒 (teacher) → clases del día con estado `ACTIVE|FUTURE|PAST`

### `/profile`
- `GET /me` 🔒
- `PUT /photo` 🔒 (teacher/student; ADMIN no permitido)

### `/sessions` (todas 🔒 teacher)
- `POST ""` → crear sesión
- `POST /{id}/activate` → activar + generar QR (`qr_duration_minutes`)
- `POST /{id}/extend` → modo extendido (controlado por `teacher_flag`)
- `GET  /{id}/attendance` → resumen
- `POST /{id}/finish` → cerrar sesión

### `/attendance`
- `POST /check-in` → registra asistencia con `qr_token` + `student_id` (público)
- `GET  /session/{id}/summary`

### Estáticos
- `/uploads` → sirve `./uploads/`

---

## 5. Códigos de error usados

| Código | Causa típica |
|---|---|
| 400 | password igual / fecha pasada |
| 401 | token inválido / credenciales |
| 403 | usuario inactivo / no es teacher / no autorizado |
| 404 | recurso no encontrado |
| 409 | conflicto de estado (sesión activa, ya check-in, modo extendido) |
| 410 | QR expirado |

Excepciones de dominio en `src/domain/exceptions/` y `src/application/use_cases/*` (e.g. `InvalidQRTokenError`, `SessionNotFoundError`, `AlreadyCheckedInError`).

---

## 6. Modelo de datos (resumen)

### Identidad
- `User` (id_user, email, password_hash, role: `STUDENT|TEACHER|ADMIN`, must_change_password, deleted_at)
- `Student` (id_student, first_name, last_name, student_card, id_course, id_user, photo_url)
- `Teacher` (id_teacher, …, teacher_flag, modifications_count, photo_url)

### Académico
- `KnowledgeArea` → `Course` → `Subject`
- `Group`, `Period (year, cycle: 1|2)`
- `Class` (id_teacher, id_subject, id_group, id_period)
- `Schedule` (id_class, weekday: MON…SUN, start/end time, shift: MORNING|AFTERNOON, id_classroom)
- `Classroom` (pavilion, type, lat/lon, allowed_radius)
- `Enrollment` (id_student, id_class) UNIQUE

### Asistencia
- `Session` (id_class, date, status: `SCHEDULED|ACTIVE|CANCELED|FINISHED`, qr_token UNIQUE, qr_expires, opens_at, closes_at, extended_mode, id_classroom)
- `Attendance` (id_session, id_student) UNIQUE; status: `PRESENT|ABSENT|LATE|JUSTIFIED`; method: `QR|MANUAL`; geo + ip
- `JustificationAttachment` (file_url, type: `IMAGE|PDF`)

### Convenciones
- PKs: UUID4 string (`default=lambda: str(uuid4())`)
- Soft delete: campo `deleted_at` (cuando aplica)
- Campos FK con prefijo `id_*`

---

## 7. Convenciones de código

- **Async** en toda la cadena (rutas, repos, sesiones DB).
- Use cases reciben repos por constructor; instanciación en `dependencies.py` o dentro del router (patrón actual).
- DTOs Pydantic v2 en `application/dtos/`.
- Routers solo orquestan: `try → use_case.execute → except DomainError → HTTPException`.
- No exponer modelos ORM en respuestas; usar DTOs.
- Lifespan ejecuta `Base.metadata.create_all` al iniciar (no migraciones — no usar Alembic salvo solicitud).

---

## 8. Ejecución (servidor local) lo realizo  de manera manual, no el agente de AI

API en `http://localhost:8000` — docs en `/docs`.

### Seeders
- `create_users.py` — usuarios base
- `seed_academic.py` — datos académicos

> Nota: `Dockerfile` y `docker-compose.yml` existen únicamente para entregar la imagen al equipo de frontend. No se usan en el flujo de desarrollo del backend.

---

## 9. Reglas para el agente

- **No** crear migraciones ni cambiar el motor DB sin solicitud explícita.
- **No** romper el contrato: prefijo `/api/v1`, JWT `sub=id_user`.
- Mantener separación de capas; nuevos endpoints → router + use case + (si aplica) repo.
- Nuevas excepciones de dominio van en `src/domain/exceptions/` y se mapean a HTTP en el router.
- Nuevos modelos ORM deben importarse en `src/infrastructure/models/__init__.py` para que `create_all` los registre.
- Validar entrada con DTOs Pydantic, nunca `dict` crudo.
- Operaciones DB: siempre `AsyncSession` inyectada, nunca crear engine ad-hoc.

---

## 10. Reducción de tokens

Pautas para minimizar consumo de contexto al trabajar en este repositorio.

### Antes de leer código
- Consultar **primero** este documento; cubre stack, capas, endpoints, modelo y convenciones.
- Usar §6 (modelo de datos) y §4 (API) como referencia rápida; evita abrir `models/` y `routes/` salvo que falte un detalle puntual.

### Lectura selectiva
- **Solo** leer los archivos directamente involucrados en la tarea.
- Para un nuevo endpoint: 1 router similar + 1 use case similar + el modelo afectado. Nada más.
- Evitar leer `__init__.py`, `__pycache__/`, `poetry.lock`, `database.db`.
- Usar `rg` con patrón concreto en lugar de `cat` archivos completos.

### Búsquedas eficientes
- `rg "class X" src/` antes que listar directorios.
- Limitar a la capa relevante (`src/api/`, `src/application/`, etc.).
- Evitar greps repetidos sobre el mismo término — encadenar en una sola consulta.

### Generación de código
- Reutilizar patrones del repo (router → use case → repo); no reinventar estructura.
- No regenerar archivos completos para cambios pequeños — usar diffs/edits puntuales.
- No incluir contexto redundante (ej. repetir el modelo en cada respuesta).
- DTOs: extender los existentes en `application/dtos/` antes de crear nuevos.

### Salida
- Respuestas mínimas suficientes (regla §6 de `AGENTS.md`).
- Mostrar solo el delta, no el archivo completo.
- Diagramas/tablas únicamente si reducen ambigüedad.

### Heurística
> Si la tarea puede resolverse con `SYSTEM_CONTEXT.md` + 1–3 archivos, **no abrir más**.
> Si requiere más, documentar la brecha aquí para futuras iteraciones.
