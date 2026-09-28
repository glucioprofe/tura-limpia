# Backend - Tura Limpia

API del proyecto construida con FastAPI y PostgreSQL.

## Requisitos previos

- Python 3.10 a 3.12 (versiones más recientes como 3.13/3.14 pueden dar problemas con algunas dependencias, ver sección de problemas comunes)
- PostgreSQL instalado localmente. Si no lo tienes, descárgalo de https://www.postgresql.org/download/ y sigue el instalador (deja las opciones por defecto, solo anota la contraseña que pongas para el usuario `postgres`)
- Git

## Estructura del proyecto

```
backend/
├── app/
│   ├── main.py
│   ├── api/
│   │   ├── routes/
│   │   └── dependencies.py
│   ├── schemas/
│   ├── services/
│   ├── repositories/
│   ├── models/
│   ├── database/
│   │   ├── connection.py
│   │   └── base.py
│   └── core/
│       ├── config.py
│       ├── security.py
│       └── errors.py
├── requirements.txt
├── .env.example
└── .gitignore
```

- **app**: paquete principal de la aplicación.
- **api/routes**: define los endpoints de la API.
- **schemas**: modelos de validación de datos (Pydantic).
- **services**: contiene la lógica de negocio.
- **repositories**: acceso a la base de datos.
- **models**: modelos de las tablas (SQLAlchemy).
- **database**: conexión y configuración de PostgreSQL.
- **core**: configuración, seguridad y manejo de errores.
- **main.py**: punto de entrada de la aplicación.
- **requirements.txt**: dependencias del proyecto.
- **.env.example**: plantilla de variables de entorno.

## Cómo ejecutarlo localmente

Clonar el proyecto

```
git clone https://github.com/glucioprofe/tura-limpia.git
```

Ir a la carpeta del backend

```
cd tura-limpia/backend
```

Crear y activar el entorno virtual

```
python -m venv venv
venv\Scripts\activate
```

Instalar las dependencias

```
pip install -r requirements.txt
```

Crear una base de datos local en PostgreSQL llamada `tura_limpia` (usando pgAdmin, que se instala junto con PostgreSQL: clic derecho en Databases > Create > Database)

Copiar el archivo de variables de entorno y poner tu propia contraseña de PostgreSQL

```
copy .env.example .env
```

Levantar el servidor

```
uvicorn app.main:app --reload
```

## Endpoints

- API: http://127.0.0.1:8000/
- Prueba de conexión a la base de datos: http://127.0.0.1:8000/test-db
- Documentación de la API: http://127.0.0.1:8000/docs

## Problemas comunes

**Error `ModuleNotFoundError: No module named 'psycopg'`**

Ocurre con versiones nuevas de Python (3.13/3.14) donde `psycopg2-binary` no instala correctamente. Solución:

```
pip install "psycopg[binary]"
```

**El servidor no arranca / error de conexión a la base de datos**

Verifica que:
- PostgreSQL esté corriendo (en Windows: buscar "Servicios", confirmar que el servicio `postgresql-x64-...` diga "En ejecución")
- La contraseña en tu archivo `.env` sea exactamente la misma que configuraste al instalar PostgreSQL
- La base de datos `tura_limpia` exista (verificar en pgAdmin)