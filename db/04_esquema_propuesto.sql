CREATE EXTENSION IF NOT EXISTS btree_gist;

CREATE TABLE usuario (
    id             SERIAL PRIMARY KEY,
    nombre         VARCHAR(120) NOT NULL,
    correo         VARCHAR(160) NOT NULL UNIQUE,
    password_hash  VARCHAR(255) NOT NULL,
    rol            VARCHAR(20)  NOT NULL
                   CHECK (rol IN ('CIUDADANO', 'TRABAJADOR', 'GERENTE', 'ADMINISTRADOR')),
    activo         BOOLEAN NOT NULL DEFAULT TRUE,
    creado_por     INT REFERENCES usuario(id),
    creado_en      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE sector (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(120) NOT NULL UNIQUE,
    descripcion TEXT
);

CREATE TABLE barrio (
    id             SERIAL PRIMARY KEY,
    nombre         VARCHAR(120) NOT NULL,
    sector_id      INT NOT NULL REFERENCES sector(id),
    fuente_nombre  VARCHAR(200) NOT NULL,
    activo         BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE (nombre, sector_id)
);

CREATE TABLE vehiculo (
    id                SERIAL PRIMARY KEY,
    placa             VARCHAR(10) NOT NULL UNIQUE,
    tipo              VARCHAR(20) NOT NULL CHECK (tipo IN ('COMPACTADOR', 'VOLQUETA', 'OTRO')),
    capacidad_m3      NUMERIC(5,2) CHECK (capacidad_m3 > 0),
    estado_operativo  VARCHAR(20) NOT NULL DEFAULT 'DISPONIBLE'
                      CHECK (estado_operativo IN ('DISPONIBLE', 'EN_SERVICIO', 'EN_MANTENIMIENTO', 'FUERA_DE_SERVICIO')),
    actualizado_en    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE trabajador (
    id          SERIAL PRIMARY KEY,
    usuario_id  INT NOT NULL UNIQUE REFERENCES usuario(id),
    documento   VARCHAR(20) NOT NULL UNIQUE,
    cargo       VARCHAR(20) NOT NULL CHECK (cargo IN ('CONDUCTOR', 'RECOLECTOR', 'BARREDOR', 'SUPERVISOR')),
    activo      BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE grupo_barrido (
    id         SERIAL PRIMARY KEY,
    nombre     VARCHAR(80) NOT NULL UNIQUE,
    sector_id  INT NOT NULL REFERENCES sector(id),
    activo     BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE asignacion_barrido (
    id             SERIAL PRIMARY KEY,
    trabajador_id  INT NOT NULL REFERENCES trabajador(id),
    grupo_id       INT NOT NULL REFERENCES grupo_barrido(id),
    barrio_id      INT REFERENCES barrio(id),
    desde          DATE NOT NULL,
    hasta          DATE,
    asignado_por   INT NOT NULL REFERENCES usuario(id),
    CHECK (hasta IS NULL OR hasta >= desde)
);
CREATE UNIQUE INDEX uq_asignacion_vigente ON asignacion_barrido(trabajador_id) WHERE hasta IS NULL;

CREATE TABLE ruta (
    id              SERIAL PRIMARY KEY,
    codigo          VARCHAR(20)  NOT NULL UNIQUE,
    nombre          VARCHAR(120) NOT NULL,
    tipo_servicio   VARCHAR(20)  NOT NULL DEFAULT 'RECOLECCION'
                    CHECK (tipo_servicio IN ('RECOLECCION', 'BARRIDO')),
    estado          VARCHAR(20)  NOT NULL DEFAULT 'BORRADOR'
                    CHECK (estado IN ('BORRADOR', 'ACTIVA', 'SUSPENDIDA', 'INACTIVA')),
    vehiculo_id     INT REFERENCES vehiculo(id),
    creada_por      INT NOT NULL REFERENCES usuario(id),
    actualizado_en  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE ruta_barrio (
    ruta_id    INT NOT NULL REFERENCES ruta(id) ON DELETE CASCADE,
    barrio_id  INT NOT NULL REFERENCES barrio(id),
    orden      SMALLINT NOT NULL CHECK (orden > 0),
    PRIMARY KEY (ruta_id, barrio_id),
    UNIQUE (ruta_id, orden)
);

CREATE TABLE horario_ruta (
    id           SERIAL PRIMARY KEY,
    ruta_id      INT NOT NULL REFERENCES ruta(id) ON DELETE CASCADE,
    dia_semana   SMALLINT NOT NULL CHECK (dia_semana BETWEEN 1 AND 7),
    hora_inicio  TIME NOT NULL,
    hora_fin     TIME NOT NULL,
    CHECK (hora_fin <> hora_inicio),
    UNIQUE (id, ruta_id),
    EXCLUDE USING gist (
        ruta_id WITH =,
        dia_semana WITH =,
        tsrange(DATE '2000-01-01' + hora_inicio,
                DATE '2000-01-01' + hora_fin
                  + CASE WHEN hora_fin < hora_inicio THEN INTERVAL '1 day' ELSE INTERVAL '0' END) WITH &&
    )
);

CREATE TABLE recorrido (
    id               SERIAL PRIMARY KEY,
    ruta_id          INT  NOT NULL,
    horario_id       INT  NOT NULL,
    fecha            DATE NOT NULL,
    vehiculo_id      INT  REFERENCES vehiculo(id),
    conductor_id     INT  REFERENCES trabajador(id),
    estado           VARCHAR(20) NOT NULL DEFAULT 'PROGRAMADO'
                     CHECK (estado IN ('PROGRAMADO', 'EN_CURSO', 'EN_PAUSA', 'COMPLETADO', 'CANCELADO')),
    con_retraso      BOOLEAN NOT NULL DEFAULT FALSE,
    inicio_real      TIMESTAMPTZ,
    fin_real         TIMESTAMPTZ,
    motivo           TEXT,
    actualizado_por  INT REFERENCES usuario(id),
    actualizado_en   TIMESTAMPTZ NOT NULL DEFAULT now(),
    FOREIGN KEY (horario_id, ruta_id) REFERENCES horario_ruta(id, ruta_id),
    UNIQUE (ruta_id, fecha, horario_id),
    CHECK (estado NOT IN ('CANCELADO', 'EN_PAUSA') OR motivo IS NOT NULL),
    CHECK (NOT con_retraso OR motivo IS NOT NULL),
    CHECK (fin_real IS NULL OR (inicio_real IS NOT NULL AND fin_real >= inicio_real)),
    CHECK (estado NOT IN ('EN_CURSO', 'EN_PAUSA', 'COMPLETADO') OR (vehiculo_id IS NOT NULL AND inicio_real IS NOT NULL)),
    CHECK (estado <> 'COMPLETADO' OR fin_real IS NOT NULL)
);

CREATE TABLE posicion_vehiculo (
    id             BIGSERIAL PRIMARY KEY,
    vehiculo_id    INT NOT NULL REFERENCES vehiculo(id),
    recorrido_id   INT REFERENCES recorrido(id),
    latitud        NUMERIC(9,6) NOT NULL CHECK (latitud BETWEEN -90 AND 90),
    longitud       NUMERIC(9,6) NOT NULL CHECK (longitud BETWEEN -180 AND 180),
    registrada_en  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE tipo_incidencia (
    codigo  VARCHAR(30) PRIMARY KEY,
    nombre  VARCHAR(80) NOT NULL,
    activo  BOOLEAN NOT NULL DEFAULT TRUE
);

INSERT INTO tipo_incidencia (codigo, nombre) VALUES
    ('VEHICULO_AVERIADO',     'Falla del vehículo'),
    ('VIA_BLOQUEADA',         'Vía bloqueada'),
    ('INUNDACION',            'Inundación'),
    ('CONGESTION',            'Congestión vehicular'),
    ('CALLE_ESTRECHA',        'Calle estrecha'),
    ('RESIDUOS_NO_RECOGIDOS', 'Residuos no recogidos'),
    ('ACCIDENTE',             'Accidente'),
    ('OTRO',                  'Otro');

CREATE TABLE incidencia (
    id              SERIAL PRIMARY KEY,
    recorrido_id    INT REFERENCES recorrido(id),
    barrio_id       INT REFERENCES barrio(id),
    vehiculo_id     INT REFERENCES vehiculo(id),
    tipo            VARCHAR(30) NOT NULL REFERENCES tipo_incidencia(codigo),
    gravedad        VARCHAR(10) NOT NULL CHECK (gravedad IN ('BAJA', 'MEDIA', 'ALTA')),
    descripcion     TEXT NOT NULL,
    estado          VARCHAR(20) NOT NULL DEFAULT 'REPORTADA'
                    CHECK (estado IN ('REPORTADA', 'EN_ATENCION', 'RESUELTA', 'CERRADA', 'DESCARTADA')),
    motivo          TEXT,
    registrada_por  INT NOT NULL REFERENCES usuario(id),
    registrada_en   TIMESTAMPTZ NOT NULL DEFAULT now(),
    cerrada_en      TIMESTAMPTZ,
    CHECK (recorrido_id IS NOT NULL OR barrio_id IS NOT NULL),
    CHECK (estado <> 'DESCARTADA' OR motivo IS NOT NULL),
    CHECK (estado NOT IN ('CERRADA', 'DESCARTADA') OR cerrada_en IS NOT NULL)
);

CREATE TABLE historial_estado_recorrido (
    id               SERIAL PRIMARY KEY,
    recorrido_id     INT NOT NULL REFERENCES recorrido(id) ON DELETE CASCADE,
    estado_anterior  VARCHAR(20)
                     CHECK (estado_anterior IN ('PROGRAMADO', 'EN_CURSO', 'EN_PAUSA', 'COMPLETADO', 'CANCELADO')),
    estado_nuevo     VARCHAR(20) NOT NULL
                     CHECK (estado_nuevo IN ('PROGRAMADO', 'EN_CURSO', 'EN_PAUSA', 'COMPLETADO', 'CANCELADO')),
    usuario_id       INT NOT NULL REFERENCES usuario(id),
    motivo           TEXT,
    fecha            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE historial_estado_incidencia (
    id               SERIAL PRIMARY KEY,
    incidencia_id    INT NOT NULL REFERENCES incidencia(id) ON DELETE CASCADE,
    estado_anterior  VARCHAR(20)
                     CHECK (estado_anterior IN ('REPORTADA', 'EN_ATENCION', 'RESUELTA', 'CERRADA', 'DESCARTADA')),
    estado_nuevo     VARCHAR(20) NOT NULL
                     CHECK (estado_nuevo IN ('REPORTADA', 'EN_ATENCION', 'RESUELTA', 'CERRADA', 'DESCARTADA')),
    usuario_id       INT NOT NULL REFERENCES usuario(id),
    motivo           TEXT,
    fecha            TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE OR REPLACE FUNCTION fn_actualizado_en() RETURNS trigger AS $$
BEGIN
    NEW.actualizado_en := now();
    RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_ruta_actualizado      BEFORE UPDATE ON ruta      FOR EACH ROW EXECUTE FUNCTION fn_actualizado_en();
CREATE TRIGGER trg_recorrido_actualizado BEFORE UPDATE ON recorrido FOR EACH ROW EXECUTE FUNCTION fn_actualizado_en();
CREATE TRIGGER trg_vehiculo_actualizado  BEFORE UPDATE ON vehiculo  FOR EACH ROW EXECUTE FUNCTION fn_actualizado_en();

CREATE OR REPLACE FUNCTION fn_recorrido_sin_incidencias_abiertas() RETURNS trigger AS $$
BEGIN
    IF NEW.estado = 'COMPLETADO' AND EXISTS (
        SELECT 1 FROM incidencia
        WHERE recorrido_id = NEW.id AND estado IN ('REPORTADA', 'EN_ATENCION')
    ) THEN
        RAISE EXCEPTION 'El recorrido % tiene incidencias abiertas y no puede completarse', NEW.id
            USING ERRCODE = 'check_violation';
    END IF;
    RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_recorrido_completado
    BEFORE UPDATE OF estado ON recorrido
    FOR EACH ROW EXECUTE FUNCTION fn_recorrido_sin_incidencias_abiertas();

CREATE INDEX idx_barrio_sector          ON barrio(sector_id);
CREATE INDEX idx_ruta_barrio_barrio     ON ruta_barrio(barrio_id);
CREATE INDEX idx_recorrido_fecha        ON recorrido(fecha);
CREATE INDEX idx_recorrido_vehiculo     ON recorrido(vehiculo_id);
CREATE INDEX idx_incidencia_recorrido   ON incidencia(recorrido_id);
CREATE INDEX idx_incidencia_estado      ON incidencia(estado);
CREATE INDEX idx_posicion_vehiculo_hora ON posicion_vehiculo(vehiculo_id, registrada_en DESC);
