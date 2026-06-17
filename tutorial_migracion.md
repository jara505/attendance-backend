## Generar migracion de schemas con alembic

## Inicializar alembic

```bash
alembic init alembic
```

### Conectar los modelos (alembic/env.py)

```bash
from src.models import Base -> que apunte a tus modelos
target_metadata = Base.metadata
```
Alembic.ini:

```bash
sqlalchemy.url = postgresql://user:pass@localhost:5432/db
```
### crear la migracion
```bash
alembic revision --autogenerate -m "init"
```

### Aplicar la migracion

```bash
alembic upgrade head
```

## Probar si funciona
```bash
docker exec -it <nombre_contenedor_db> psql -U user -d db
```
