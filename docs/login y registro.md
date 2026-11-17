# Módulo de Autenticación

Este documento describe los endpoints disponibles para el registro e inicio de sesión de usuarios en la plataforma. La autenticación funciona mediante tokens **JWT (Bearer Token)** en formato `application/json`.

---

## 1. Registrar Ciudadano

Registra una nueva cuenta ciudadana en el sistema. El rol `ciudadano` se asigna de forma automática (no se requiere registro previo para consultar los vehículos).

* **Método:** `POST`
* **Endpoint:** `/auth/register`
* **Autenticación requerida:** No

### Cuerpo de la petición (`Request Body`)

Se debe enviar un objeto JSON con los siguientes campos obligatorios:

| Campo | Tipo | Descripción | Ejemplo |
| :--- | :--- | :--- | :--- |
| `nombres` | `string` | Nombres del ciudadano | `"Juan Carlos"` |
| `apellidos` | `string` | Apellidos del ciudadano | `"Pérez Gómez"` |
| `nombre_usuario` | `string` | Nombre de usuario único en el sistema | `"jperez"` |
| `correo` | `string` | Correo electrónico válido | `"user@example.com"` |
| `password` | `string` | Contraseña de acceso | `"MiPassword123"` |
| `telefono` | `string` | Número de contacto | `"3001234567"` |

#### Ejemplo de envío (`application/json`)

```json
{
  "nombres": "string",
  "apellidos": "string",
  "nombre_usuario": "string",
  "correo": "user@example.com",
  "password": "stringst",
  "telefono": "string"
}
```

### Posibles respuestas (`Responses`)

#### `201 Created` - Registro exitoso
Devuelve los datos básicos del usuario creado y confirma el rol asignado:

```json
{
  "id": "string",
  "nombre": "string",
  "email": "string",
  "rol": "ciudadano",
  "mensaje": "string"
}
```

#### Códigos de error
* **`409 Conflict`:** Correo o usuario ya registrado en el sistema.
* **`422 Unprocessable Entity`:** Datos de registro inválidos o con formato incorrecto.

---

## 2. Iniciar Sesión (Login)

Autentica a un usuario registrado mediante su correo electrónico (o nombre de usuario) y contraseña. Si las credenciales son válidas, retorna un **JWT de acceso**.

* **Método:** `POST`
* **Endpoint:** `/auth/login`
* **Autenticación requerida:** No

### Cuerpo de la petición (`Request Body`)

| Campo | Tipo | Descripción | Ejemplo |
| :--- | :--- | :--- | :--- |
| `email` | `string` | Correo electrónico o nombre de usuario | `"admin@turalimpia.com"` |
| `password` | `string` | Contraseña del usuario | `"string"` |

#### Ejemplo de envío (`application/json`)

```json
{
  "email": "admin@turalimpia.com",
  "password": "string"
}
```

### Posibles respuestas (`Responses`)

#### `200 OK` - Inicio de sesión exitoso
Retorna el token JWT necesario para consumir los endpoints protegidos de la API:

```json
{
  "access_token": "string",
  "token_type": "bearer"
}
```

#### Códigos de error
* **`401 Unauthorized`:** Credenciales inválidas (correo/usuario o contraseña incorrectos).
* **`403 Forbidden`:** Usuario inactivo o sin un rol activo asignado.
* **`422 Unprocessable Entity`:** Error de validación en los datos enviados.

```json
{
  "detail": [
    {
      "loc": [
        "string",
        0
      ],
      "msg": "string",
      "type": "string",
      "input": "string",
      "ctx": {}
    }
  ]
}
```
