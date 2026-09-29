-- =====================================================================
-- Tura Limpia - Célula 3: barrios, rutas, horarios, recorridos e incidencias
-- Propuesta para entregar a la célula 1. PostgreSQL.
-- Los estados van como texto con CHECK para poder cambiarlos fácil.
-- =====================================================================

-- Provisional: la tabla real de usuarios la define otra célula.
-- Aquí solo existe para que las relaciones "quién registró" funcionen.
CREATE TABLE usuario (
    id      SERIAL PRIMARY KEY,
    nombre  VARCHAR(120) NOT NULL,
    rol     VARCHAR(20)  NOT NULL CHECK (rol IN ('ADMINISTRADOR', 'OPERADOR'))
);

-- Agrupación de barrios (comuna, zona o sector de prueba).
CREATE TABLE sector (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(120) NOT NULL UNIQUE,
    descripcion TEXT
);

-- Barrio: lugar fijo. Sin geometría ni malla vial en este sprint.
CREATE TABLE barrio (
    id             SERIAL PRIMARY KEY,
    nombre         VARCHAR(120) NOT NULL,
    sector_id      INT REFERENCES sector(id),
    fuente_nombre  VARCHAR(200) NOT NULL,          -- de dónde sale el nombre
    activo         BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE (nombre, sector_id)
);

-- Ruta programada: el plan.
CREATE TABLE ruta (
    id              SERIAL PRIMARY KEY,
    codigo          VARCHAR(20)  NOT NULL UNIQUE,  -- ej. R-01
    nombre          VARCHAR(120) NOT NULL,
    estado          VARCHAR(20)  NOT NULL DEFAULT 'BORRADOR'
                    CHECK (estado IN ('BORRADOR', 'ACTIVA', 'SUSPENDIDA', 'INACTIVA')),
    creada_por      INT NOT NULL REFERENCES usuario(id),
    actualizado_en  TIMESTAMP NOT NULL DEFAULT now()
);

-- Qué barrios cubre una ruta y en qué orden (un barrio puede estar en varias rutas).
CREATE TABLE ruta_barrio (
    ruta_id    INT NOT NULL REFERENCES ruta(id) ON DELETE CASCADE,
    barrio_id  INT NOT NULL REFERENCES barrio(id),
    orden      SMALLINT NOT NULL CHECK (orden > 0),
    PRIMARY KEY (ruta_id, barrio_id),
    UNIQUE (ruta_id, orden)
);

-- Frecuencia / horario: qué días y en qué franja pasa la ruta.
-- dia_semana: 1 = lunes ... 7 = domingo
CREATE TABLE horario_ruta (
    id              SERIAL PRIMARY KEY,
    ruta_id         INT NOT NULL REFERENCES ruta(id) ON DELETE CASCADE,
    dia_semana      SMALLINT NOT NULL CHECK (dia_semana BETWEEN 1 AND 7),
    hora_inicio     TIME NOT NULL,
    hora_fin        TIME NOT NULL,
    actualizado_en  TIMESTAMP NOT NULL DEFAULT now(),
    CHECK (hora_fin > hora_inicio),
    UNIQUE (ruta_id, dia_semana, hora_inicio)
);

-- Recorrido realizado: una salida concreta de una ruta en una fecha.
CREATE TABLE recorrido (
    id                 SERIAL PRIMARY KEY,
    ruta_id            INT  NOT NULL REFERENCES ruta(id),
    horario_id         INT  REFERENCES horario_ruta(id),
    fecha              DATE NOT NULL,
    estado             VARCHAR(20) NOT NULL DEFAULT 'PROGRAMADO'
                       CHECK (estado IN ('PROGRAMADO', 'EN_CURSO', 'EN_PAUSA', 'COMPLETADO', 'CANCELADO')),
    con_retraso        BOOLEAN NOT NULL DEFAULT FALSE,
    inicio_real        TIMESTAMP,
    fin_real           TIMESTAMP,
    motivo             TEXT,                        -- obligatorio al cancelar o marcar retraso
    actualizado_por    INT REFERENCES usuario(id),
    actualizado_en     TIMESTAMP NOT NULL DEFAULT now(),
    UNIQUE (ruta_id, fecha, horario_id),
    CHECK (estado <> 'CANCELADO' OR motivo IS NOT NULL)
);

-- Incidencia operativa. Puede existir sin recorrido (decisión del equipo).
CREATE TABLE incidencia (
    id               SERIAL PRIMARY KEY,
    recorrido_id     INT REFERENCES recorrido(id),  -- opcional
    barrio_id        INT REFERENCES barrio(id),     -- opcional
    tipo             VARCHAR(30) NOT NULL
                     CHECK (tipo IN ('VEHICULO_AVERIADO', 'VIA_BLOQUEADA', 'CLIMA',
                                     'ACUMULACION_RESIDUOS', 'OTRO')),
    descripcion      TEXT NOT NULL,
    estado           VARCHAR(20) NOT NULL DEFAULT 'ABIERTA'
                     CHECK (estado IN ('ABIERTA', 'EN_ATENCION', 'CERRADA')),
    registrada_por   INT NOT NULL REFERENCES usuario(id),
    registrada_en    TIMESTAMP NOT NULL DEFAULT now()
);

-- Historial: quién cambió el estado de un recorrido, cuándo y por qué.
CREATE TABLE historial_estado_recorrido (
    id               SERIAL PRIMARY KEY,
    recorrido_id     INT NOT NULL REFERENCES recorrido(id) ON DELETE CASCADE,
    estado_anterior  VARCHAR(20),
    estado_nuevo     VARCHAR(20) NOT NULL,
    usuario_id       INT NOT NULL REFERENCES usuario(id),
    motivo           TEXT,
    fecha            TIMESTAMP NOT NULL DEFAULT now()
);

CREATE INDEX idx_ruta_barrio_barrio ON ruta_barrio(barrio_id);
CREATE INDEX idx_recorrido_fecha    ON recorrido(fecha);
