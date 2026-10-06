\set QUIET on
\pset footer off

DO $$
DECLARE
    esperado CONSTANT jsonb := '{"usuario":3,"sector":4,"barrio":6,"ruta":4,
        "ruta_barrio":6,"horario_ruta":16,"recorrido":6,"incidencia":3,
        "historial_estado_recorrido":5}';
    t text; n int;
BEGIN
    FOR t IN SELECT jsonb_object_keys(esperado) LOOP
        EXECUTE format('SELECT count(*) FROM %I', t) INTO n;
        IF n <> (esperado->>t)::int THEN
            RAISE EXCEPTION 'FALLA conteo %: hay %, se esperaba %', t, n, esperado->>t;
        END IF;
    END LOOP;
    RAISE NOTICE 'OK  A1 conteos sin duplicados';
END $$;

CREATE OR REPLACE FUNCTION pg_temp.debe_fallar(nombre text, sql text) RETURNS void AS $$
BEGIN
    BEGIN
        EXECUTE sql;
    EXCEPTION WHEN integrity_constraint_violation OR check_violation
                OR not_null_violation OR foreign_key_violation OR unique_violation THEN
        RAISE NOTICE 'OK  A2 rechaza: %', nombre;
        RETURN;
    END;
    RAISE EXCEPTION 'FALLA A2: se aceptó %', nombre;
END $$ LANGUAGE plpgsql;

\o /dev/null
BEGIN;
SELECT pg_temp.debe_fallar('ruta con estado inválido',
    $q$INSERT INTO ruta (codigo, nombre, estado, creada_por) VALUES ('X-1','x','PERDIDA',1)$q$);
SELECT pg_temp.debe_fallar('código de ruta duplicado',
    $q$INSERT INTO ruta (codigo, nombre, creada_por) VALUES ('R-01','x',1)$q$);
SELECT pg_temp.debe_fallar('ruta creada por usuario inexistente',
    $q$INSERT INTO ruta (codigo, nombre, creada_por) VALUES ('X-2','x',999)$q$);
SELECT pg_temp.debe_fallar('orden de barrio 0',
    $q$INSERT INTO ruta_barrio VALUES (4, 1, 0)$q$);
SELECT pg_temp.debe_fallar('dos barrios con el mismo orden en una ruta',
    $q$INSERT INTO ruta_barrio VALUES (2, 1, 1)$q$);
SELECT pg_temp.debe_fallar('hora_fin antes de hora_inicio',
    $q$INSERT INTO horario_ruta (ruta_id, dia_semana, hora_inicio, hora_fin) VALUES (1,1,'10:00','09:00')$q$);
SELECT pg_temp.debe_fallar('día de semana 8',
    $q$INSERT INTO horario_ruta (ruta_id, dia_semana, hora_inicio, hora_fin) VALUES (1,8,'06:00','07:00')$q$);
SELECT pg_temp.debe_fallar('recorrido cancelado sin motivo',
    $q$INSERT INTO recorrido (ruta_id, horario_id, fecha, estado) VALUES (1,1,'2026-10-12','CANCELADO')$q$);
SELECT pg_temp.debe_fallar('recorrido duplicado (misma ruta, fecha y horario)',
    $q$INSERT INTO recorrido (ruta_id, horario_id, fecha) VALUES (1,1,'2026-10-05')$q$);
SELECT pg_temp.debe_fallar('incidencia de tipo inválido',
    $q$INSERT INTO incidencia (tipo, descripcion, registrada_por) VALUES ('ALIENS','x',1)$q$);
SELECT pg_temp.debe_fallar('borrar barrio usado por una ruta',
    $q$DELETE FROM barrio WHERE id = 1$q$);
ROLLBACK;
\o

\echo
\echo '== A3.1 RF-07: rutas con barrios, días y horario =='
SELECT r.codigo, s.nombre AS sector, string_agg(DISTINCT b.nombre, ', ') AS barrios,
       string_agg(DISTINCT h.dia_semana::text, ',') AS dias,
       min(h.hora_inicio) AS desde, max(h.hora_fin) AS hasta, r.estado
FROM ruta r
JOIN ruta_barrio rb ON rb.ruta_id = r.id
JOIN barrio b       ON b.id = rb.barrio_id
JOIN sector s       ON s.id = b.sector_id
JOIN horario_ruta h ON h.ruta_id = r.id
GROUP BY r.codigo, s.nombre, r.estado
ORDER BY r.codigo;

\echo '== A3.2 Recorridos con sus incidencias y quién los actualizó =='
SELECT rc.fecha, r.codigo, rc.estado, rc.con_retraso,
       i.tipo AS incidencia, i.estado AS estado_incidencia, u.nombre AS actualizado_por
FROM recorrido rc
JOIN ruta r            ON r.id = rc.ruta_id
LEFT JOIN incidencia i ON i.recorrido_id = rc.id
LEFT JOIN usuario u    ON u.id = rc.actualizado_por
ORDER BY rc.fecha, r.codigo;

\echo '== A3.3 Coherencia: el estado actual = último estado del historial =='
SELECT rc.id, rc.estado AS estado_actual, ult.estado_nuevo AS ultimo_historial,
       CASE WHEN rc.estado = ult.estado_nuevo THEN 'OK' ELSE 'REVISAR' END AS resultado
FROM recorrido rc
JOIN LATERAL (SELECT estado_nuevo FROM historial_estado_recorrido h
              WHERE h.recorrido_id = rc.id ORDER BY h.fecha DESC, h.id DESC LIMIT 1) ult ON TRUE
ORDER BY rc.id;

\echo
\o /dev/null
CREATE OR REPLACE FUNCTION pg_temp.hueco(nombre text, sql text) RETURNS void AS $$
BEGIN
    BEGIN
        EXECUTE sql;
        RAISE NOTICE 'HALLAZGO  se acepta: %', nombre;
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'ok        se rechaza: %', nombre;
    END;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION pg_temp.conflicto(nombre text, sql text) RETURNS void AS $$
BEGIN
    BEGIN
        EXECUTE sql;
        RAISE NOTICE 'ok        se acepta: %', nombre;
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'CONFLICTO se rechaza: %', nombre;
    END;
END $$ LANGUAGE plpgsql;

BEGIN;
SELECT pg_temp.hueco('B1 recorrido duplicado cuando horario_id es NULL',
    $q$INSERT INTO recorrido (ruta_id, fecha) VALUES (1,'2026-10-20'), (1,'2026-10-20')$q$);
SELECT pg_temp.hueco('B2 recorrido con horario de OTRA ruta',
    $q$INSERT INTO recorrido (ruta_id, horario_id, fecha) VALUES (3, 1, '2026-10-21')$q$);
SELECT pg_temp.hueco('B3 recorrido con retraso sin motivo',
    $q$INSERT INTO recorrido (ruta_id, horario_id, fecha, con_retraso) VALUES (1,4,'2026-10-22',TRUE)$q$);
SELECT pg_temp.hueco('B4 recorrido en pausa sin motivo (PDF C3 lo exige)',
    $q$INSERT INTO recorrido (ruta_id, horario_id, fecha, estado) VALUES (1,5,'2026-10-23','EN_PAUSA')$q$);
SELECT pg_temp.hueco('B5 fin_real antes de inicio_real',
    $q$INSERT INTO recorrido (ruta_id, horario_id, fecha, inicio_real, fin_real)
       VALUES (1,6,'2026-10-24','2026-10-24 10:00','2026-10-24 08:00')$q$);
SELECT pg_temp.hueco('B6 historial con estado que no existe',
    $q$INSERT INTO historial_estado_recorrido (recorrido_id, estado_nuevo, usuario_id) VALUES (1,'VOLANDO',1)$q$);
SELECT pg_temp.hueco('B7 incidencia sin recorrido ni ubicación (PDF C3 exige ubicación)',
    $q$INSERT INTO incidencia (tipo, descripcion, registrada_por) VALUES ('OTRO','x',1)$q$);
SELECT pg_temp.hueco('B8 barrio duplicado cuando sector_id es NULL',
    $q$INSERT INTO barrio (nombre, fuente_nombre) VALUES ('Dup','x'), ('Dup','x')$q$);
SELECT pg_temp.conflicto('B9 horario que cruza medianoche (turno noche)',
    $q$INSERT INTO horario_ruta (ruta_id, dia_semana, hora_inicio, hora_fin) VALUES (4,1,'22:00','02:00')$q$);
SELECT pg_temp.hueco('B10 horarios solapados en la misma ruta y día',
    $q$INSERT INTO horario_ruta (ruta_id, dia_semana, hora_inicio, hora_fin) VALUES (1,1,'07:00','09:00')$q$);
SELECT pg_temp.hueco('B11 usuario duplicado (no hay correo/usuario único)',
    $q$INSERT INTO usuario (nombre, rol) VALUES ('Ana','OPERADOR'), ('Ana','OPERADOR')$q$);
SELECT pg_temp.conflicto('B12 rol Gerente (RF-01)',
    $q$INSERT INTO usuario (nombre, rol) VALUES ('G','GERENTE')$q$);
SELECT pg_temp.conflicto('B13 incidencia estado REPORTADA (PDF C3)',
    $q$INSERT INTO incidencia (barrio_id, tipo, descripcion, estado, registrada_por) VALUES (1,'OTRO','x','REPORTADA',1)$q$);
SELECT pg_temp.conflicto('B14 incidencia tipo ACCIDENTE (PDF C3)',
    $q$INSERT INTO incidencia (barrio_id, tipo, descripcion, registrada_por) VALUES (1,'ACCIDENTE','x',1)$q$);
SELECT pg_temp.hueco('B15 recorrido COMPLETADO con incidencia abierta (regla PDF C3)',
    $q$UPDATE recorrido SET estado = 'COMPLETADO', fin_real = now() WHERE id = 4$q$);
ROLLBACK;
\o

\echo
\echo '== B16 Tablas que piden RF/Trello y no existen todavía =='
SELECT t AS tabla_esperada, 'NO EXISTE' AS estado
FROM unnest(ARRAY['vehiculo','conductor','trabajador','grupo_barrido',
                  'historial_estado_incidencia']) t
WHERE to_regclass(t) IS NULL;
