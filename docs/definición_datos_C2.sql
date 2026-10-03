CREATE DATABASE tura_limpia;
USE tura_limpia;

CREATE TABLE conductor (
    id_conductor     CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    documento        VARCHAR(20)  NOT NULL UNIQUE,
    nombres          VARCHAR(80)  NOT NULL,
    apellidos        VARCHAR(80)  NOT NULL,
    telefono         VARCHAR(20),
    licencia_numero  VARCHAR(30)  NOT NULL UNIQUE,
    licencia_categoria VARCHAR(10) NOT NULL,
    licencia_vence   DATE         NOT NULL,
    activo           BOOLEAN      NOT NULL DEFAULT TRUE
);

CREATE TABLE vehiculo (
    id_vehiculo      CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    placa            VARCHAR(10)  NOT NULL UNIQUE,
    tipo             VARCHAR(30)  NOT NULL,       -- ej: compactador, camión, camioneta
    marca            VARCHAR(40),
    modelo           VARCHAR(40),
    anio             SMALLINT,
    capacidad_kg     DECIMAL(10,2),
    soat_vence       DATE,
    revision_vence   DATE,
    estado           VARCHAR(15)  NOT NULL DEFAULT 'DISPONIBLE'
                     CHECK (estado IN ('DISPONIBLE','EN_RUTA','MANTENIMIENTO','BAJA'))
);

CREATE TABLE turno (
    id_turno         CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    nombre           VARCHAR(30)  NOT NULL UNIQUE, -- ej: Mañana, Tarde, Noche
    hora_inicio      TIME         NOT NULL,
    hora_fin         TIME         NOT NULL
);

CREATE TABLE asignacion_turno (
    id_asignacion    CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    id_conductor     CHAR(36) NOT NULL,
    id_vehiculo      CHAR(36) NOT NULL,
    id_turno         CHAR(36) NOT NULL,
    fecha            DATE NOT NULL,
    observaciones    VARCHAR(200),
    CONSTRAINT fk_asig_conductor FOREIGN KEY (id_conductor) REFERENCES conductor(id_conductor),
    CONSTRAINT fk_asig_vehiculo  FOREIGN KEY (id_vehiculo)  REFERENCES vehiculo(id_vehiculo),
    CONSTRAINT fk_asig_turno     FOREIGN KEY (id_turno)     REFERENCES turno(id_turno),
    -- Un conductor y un vehículo no pueden repetirse en el mismo turno y fecha
    CONSTRAINT uq_conductor_turno_fecha UNIQUE (id_conductor, id_turno, fecha),
    CONSTRAINT uq_vehiculo_turno_fecha  UNIQUE (id_vehiculo,  id_turno, fecha)
);

