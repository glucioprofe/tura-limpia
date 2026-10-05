# Backend · Tura Limpia

API REST desarrollada con Python y FastAPI para la lógica de negocio y persistencia de datos en PostgreSQL.

---

## Estructura del Backend

```text
backend/
├── app/
│   ├── api/
│   │   ├── routes/              # Endpoints de la API
│   │   └── dependencies.py      # Inyección de dependencias
│   ├── core/                    # Configuración, seguridad y manejo de errores
│   ├── database/                # Conexión y sesión de base de datos
│   ├── models/                  # Modelos ORM (SQLAlchemy)
│   ├── repositories/            # Acceso a base de datos (Repository Pattern)
│   ├── schemas/                 # DTOs y validaciones (Pydantic)
│   ├── services/                # Lógica de negocio (Service Layer)
│   └── main.py                  # Punto de entrada de FastAPI
├── requirements.txt             # Dependencias del servidor
├── .env.example                 # Variables de entorno
└── README.md
```
