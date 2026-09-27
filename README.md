# Tura Limpia

Prototipo académico para la gestión administrativa de rutas y recorridos de recolección en Buenaventura.

## Coordinación

Las responsabilidades y decisiones del Sprint 1 se registran en el [tablero de Trello TuraLimpia](https://trello.com/b/tOeGQFf8/turalimpia). Todas las células trabajan sobre este repositorio común.

El Product Owner aportará la base inicial y los accesos. Durante el Sprint 1, el equipo acordará el stack, el diseño general de la base de datos y la política de ramas, revisión e integración.

La aplicación ciudadana, la clasificación de imágenes y la analítica avanzada quedan fuera del alcance de esta primera entrega.



# Documentacion stack y patrones compartidos

**Proyecto Tura Limpia - Seminario de Actualización**

## 1. Introducción

El proyecto para la gestión y optimización de la recolección y transporte de residuos sólidos en el Distrito de Buenaventura será desarrollado utilizando una arquitectura organizada que permita separar las responsabilidades de cada componente del sistema.

El grupo ha establecido un conjunto de tecnologías, patrones y convenciones que serán compartidos durante el desarrollo del proyecto. Esto permitirá que los diferentes integrantes trabajen bajo una estructura común y que los componentes desarrollados puedan integrarse de manera adecuada.

La solución estará compuesta principalmente por un frontend desarrollado con React, un backend desarrollado con Python y FastAPI y una base de datos PostgreSQL. La comunicación entre el frontend y el backend se realizará mediante una API REST utilizando JSON.

## 2. Stack tecnológico

| Parte | Tecnología | ¿Para qué? |
|---|---|---|
| Frontend | React | Crear la interfaz que utilizarán los usuarios administrativos. |
| Backend | Python + FastAPI | Desarrollar la lógica del sistema y proporcionar la API. |
| Base de datos | PostgreSQL | Almacenar la información del sistema. |
| Comunicación | REST API + JSON | Comunicar el frontend con el backend. |
| Documentación API | OpenAPI | Documentar los servicios disponibles en la API. |
| Control de versiones | Git / GitHub | Controlar los cambios y facilitar el trabajo entre las células. |
| Autenticación | OAuth 2.0 / OIDC | Gestionar el acceso y la autenticación de los usuarios. |

## 3. Arquitectura general

La arquitectura propuesta seguirá una separación entre frontend, backend y base de datos. El flujo principal de comunicación será:

```text
React
  |
  | REST API + JSON
  v
Python + FastAPI
  |
  v
Lógica de negocio
  |
  v
PostgreSQL
```

El frontend será responsable de proporcionar la interfaz utilizada por los usuarios administrativos. El backend será responsable de procesar las solicitudes, aplicar las reglas de negocio, validar la información y comunicarse con la base de datos.

PostgreSQL será utilizado para almacenar la información relacionada con usuarios, residuos, rutas, vehículos y demás elementos necesarios para el funcionamiento del sistema.

## 4. Patrones compartidos

Los patrones compartidos establecen una estructura común que deberá ser utilizada por los integrantes del equipo durante el desarrollo. Estos patrones buscan evitar que cada módulo sea desarrollado de una manera diferente y permiten mantener una arquitectura organizada.

- Separación de responsabilidades.
- Service Layer.
- Repository Pattern.
- Schemas / DTO.
- Dependency Injection.
- Convenciones REST.
- Estructura uniforme de respuestas.
- Manejo centralizado de errores.

## 5. Separación de responsabilidades

El backend se dividirá en diferentes capas. Cada capa tendrá una responsabilidad específica.

La estructura general será:

```text
API
 |
 v
Schemas
 |
 v
Services
 |
 v
Repositories
 |
 v
Database
```

Esto permite evitar que una sola parte del sistema tenga todas las responsabilidades. Las rutas de FastAPI no deberán contener directamente toda la lógica de negocio ni realizar directamente todas las operaciones de base de datos.

## 6. Estructura de carpetas del backend

La estructura propuesta para el backend será:

```text
backend/
│
├── app/
│   ├── main.py
│   │
│   ├── api/
│   │   ├── routes/
│   │   │   ├── usuarios.py
│   │   │   ├── residuos.py
│   │   │   ├── rutas.py
│   │   │   └── vehiculos.py
│   │   │
│   │   └── dependencies.py
│   │
│   ├── schemas/
│   │   ├── usuario.py
│   │   ├── residuo.py
│   │   ├── ruta.py
│   │   └── vehiculo.py
│   │
│   ├── services/
│   │   ├── usuario_service.py
│   │   ├── residuo_service.py
│   │   ├── ruta_service.py
│   │   └── vehiculo_service.py
│   │
│   ├── repositories/
│   │   ├── usuario_repository.py
│   │   ├── residuo_repository.py
│   │   ├── ruta_repository.py
│   │   └── vehiculo_repository.py
│   │
│   ├── models/
│   │   ├── usuario.py
│   │   ├── residuo.py
│   │   ├── ruta.py
│   │   └── vehiculo.py
│   │
│   ├── database/
│   │   ├── connection.py
│   │   └── base.py
│   │
│   └── core/
│       ├── config.py
│       ├── security.py
│       └── errors.py
│
├── requirements.txt
├── .env.example
├── .gitignore
└── README.md
```

## 7. Repository Pattern

El patrón Repository será utilizado para separar el acceso a la base de datos de la lógica de negocio.

Los repositorios serán responsables de realizar operaciones como:

- Consultar información.
- Registrar información.
- Actualizar registros.
- Eliminar registros.
- Realizar búsquedas.

Los repositorios estarán ubicados en `repositories/`. Por ejemplo:

- `residuo_repository.py`
- `ruta_repository.py`
- `vehiculo_repository.py`

De esta manera, los servicios no tendrán que encargarse directamente de realizar todas las operaciones con PostgreSQL.

## 8. Service Layer

La capa de servicios contendrá la lógica de negocio del sistema. Los servicios recibirán las solicitudes procesadas por la API y aplicarán las reglas necesarias antes de comunicarse con los repositorios.

La carpeta será `services/`.

Ejemplos:

- `residuo_service.py`
- `ruta_service.py`
- `vehiculo_service.py`

Para registrar una recolección de residuos, el servicio podrá validar las condiciones necesarias y posteriormente solicitar al repositorio que almacene la información. Esto permite mantener las rutas de FastAPI más organizadas.

## 9. Schemas / DTO

Los schemas serán utilizados para definir y validar la información que entra y sale de la API.

FastAPI utiliza Pydantic para realizar la validación de datos, por lo que esta capa permitirá establecer qué información puede recibir cada endpoint.

Los schemas estarán ubicados en `schemas/`. Por ejemplo:

- `residuo.py`
- `ruta.py`
- `vehiculo.py`
- `usuario.py`

Un esquema de residuos podría contener información como:

- `tipo_residuo`
- `cantidad`
- `ubicacion`
- `fecha_recoleccion`

Esto permite verificar que los datos recibidos tengan la estructura y formato esperado.

## 10. Dependency Injection

Se utilizará el sistema de inyección de dependencias proporcionado por FastAPI.

Las dependencias podrán utilizarse para elementos como:

- Conexión con la base de datos.
- Autenticación.
- Autorización.
- Usuarios autenticados.
- Servicios.
- Configuraciones.

Las dependencias generales podrán organizarse en `api/dependencies.py`. Esto permite reutilizar componentes comunes en diferentes endpoints.

## 11. Convenciones de endpoints REST

Todos los integrantes deberán utilizar convenciones uniformes para los endpoints de la API. Los recursos deberán utilizar nombres claros y consistentes.

### Endpoints de usuarios

| Método | Endpoint | Operación |
|---|---|---|
| GET | `/usuarios` | Consultar usuarios. |
| GET | `/usuarios/{id}` | Consultar un usuario por ID. |
| POST | `/usuarios` | Crear un usuario. |
| PUT | `/usuarios/{id}` | Actualizar un usuario. |
| DELETE | `/usuarios/{id}` | Eliminar un usuario. |

### Endpoints de residuos

| Método | Endpoint | Operación |
|---|---|---|
| GET | `/residuos` | Consultar residuos. |
| GET | `/residuos/{id}` | Consultar un residuo por ID. |
| POST | `/residuos` | Registrar un residuo. |
| PUT | `/residuos/{id}` | Actualizar un residuo. |
| DELETE | `/residuos/{id}` | Eliminar un residuo. |

Se evitará utilizar nombres diferentes para representar la misma operación, buscando mantener una API coherente.

## 12. Estructura uniforme de respuestas

Las respuestas de la API deberán seguir una estructura uniforme.

### Respuesta exitosa

```json
{
  "success": true,
  "message": "Residuo registrado correctamente",
  "data": {}
}
```

### Respuesta de error

```json
{
  "success": false,
  "message": "No se pudo registrar el residuo",
  "error": {}
}
```

El objetivo es que el frontend desarrollado en React pueda interpretar las respuestas de manera consistente.

## 13. Manejo de errores

El backend deberá contar con un manejo organizado de errores. Los errores deberán:

- Utilizar códigos HTTP apropiados.
- Mostrar mensajes comprensibles.
- Evitar exponer información sensible.
- Mantener una estructura uniforme.
- Ser gestionados de forma centralizada cuando sea posible.

Los componentes relacionados con el manejo de errores podrán ubicarse en `core/errors.py`. Esto permite evitar que cada módulo maneje los errores de una manera completamente diferente.

## 14. Autenticación y seguridad

Para la autenticación se utilizará OAuth 2.0 / OIDC. Su función será controlar el acceso de los usuarios al sistema y permitir identificar a los usuarios autenticados.

Los componentes relacionados con seguridad podrán organizarse en `core/security.py`.

La autenticación deberá estar integrada con las dependencias de FastAPI para proteger los endpoints que requieran acceso autorizado.

## 15. Comunicación entre frontend y backend

La comunicación entre React y FastAPI se realizará mediante una API REST utilizando JSON.

El flujo será:

```text
Usuario administrativo
        |
        v
      React
        |
        | HTTP + JSON
        v
      FastAPI
        |
        v
      Services
        |
        v
    Repositories
        |
        v
    PostgreSQL
```

El backend procesará la solicitud y devolverá una respuesta que será interpretada por React para actualizar la interfaz.

## 16. Estructura general del proyecto

Teniendo en cuenta el frontend, backend y los elementos de apoyo, la estructura general será:

```text
proyecto-residuos/
│
├── frontend/
│   └── React
│
├── backend/
│   ├── app/
│   │   ├── main.py
│   │   ├── api/
│   │   │   ├── routes/
│   │   │   └── dependencies.py
│   │   ├── schemas/
│   │   ├── services/
│   │   ├── repositories/
│   │   ├── models/
│   │   ├── database/
│   │   └── core/
│   │
│   ├── requirements.txt
│   ├── .env
│   └── README.md
│
├── tests/
│
└── README.md
```

Cada parte del proyecto (frontend y backend) mantiene sus propias dependencias, variables de entorno y documentación, de forma independiente entre sí.

El `README.md` en la raíz del repositorio describe el proyecto en general y la coordinación del equipo; cada subcarpeta (`frontend/`, `backend/`) tiene su propio `README.md` con instrucciones específicas para levantarla.

Esta estructura representa la organización inicial que seguirá el proyecto y podrá ampliarse conforme se desarrollen nuevos módulos.

## 17. Política de trabajo con Git

Para controlar el desarrollo del proyecto se utilizará Git y GitHub. El objetivo es mantener un historial de cambios organizado y facilitar el trabajo colaborativo entre las diferentes células del equipo.

### Rama principal

Se utilizará una rama principal (`main`) para contener las versiones estables del proyecto. No se deberán realizar cambios directamente sobre esta rama sin revisión.

### Ramas de desarrollo

Se podrá utilizar una rama (`develop`) destinada al desarrollo de nuevas funcionalidades.

### Pull Request

Los cambios desarrollados en una rama deberán enviarse mediante Pull Request para facilitar la revisión del código antes de integrarlo.

### Revisión

Los integrantes del equipo deberán revisar los cambios antes de incorporarlos a la rama correspondiente.

### Integración del código

Una vez revisado y aprobado el código, se podrá realizar la integración correspondiente.

### Convenciones de commits

Los commits deberán utilizar mensajes claros que permitan identificar el propósito del cambio.

Ejemplos:

```text
feat: agregar endpoint de residuos
fix: corregir validación de rutas
docs: actualizar documentación de API
refactor: reorganizar servicio de vehículos
```
