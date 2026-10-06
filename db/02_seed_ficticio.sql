
BEGIN;

INSERT INTO usuario (id, nombre, rol) VALUES
    (1, '[FICTICIO] Admin Prueba',      'ADMINISTRADOR'),
    (2, '[FICTICIO] Operador Prueba 1', 'OPERADOR'),
    (3, '[FICTICIO] Operador Prueba 2', 'OPERADOR')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sector (id, nombre, descripcion) VALUES
    (1, 'Centro',              'Prueba: caso sencillo, servicio diario'),
    (2, 'Playita y Palo Seco', 'Prueba: caso complicado'),
    (3, 'Marina y Oriente',    'Prueba: patrón martes y viernes'),
    (4, 'Puertos',             'Prueba: mayor generación de residuos')
ON CONFLICT (id) DO NOTHING;

INSERT INTO barrio (id, nombre, sector_id, fuente_nombre) VALUES
    (1, 'Centro',    1, 'Verbal 2026-09-28 (docs/sectores_prueba.md)'),
    (2, 'Playita',   2, 'Verbal 2026-09-28 (docs/sectores_prueba.md)'),
    (3, 'Palo Seco', 2, 'Verbal 2026-09-28 (docs/sectores_prueba.md)'),
    (4, 'Marina',    3, 'Verbal 2026-09-28 (docs/sectores_prueba.md)'),
    (5, 'Oriente',   3, 'Verbal 2026-09-28 (docs/sectores_prueba.md)'),
    (6, 'Puertos',   4, 'Verbal 2026-09-28 (docs/sectores_prueba.md)')
ON CONFLICT (id) DO NOTHING;

INSERT INTO ruta (id, codigo, nombre, estado, creada_por) VALUES
    (1, 'R-01', '[FICTICIO] Ruta Centro',              'ACTIVA',   1),
    (2, 'R-02', '[FICTICIO] Ruta Playita y Palo Seco', 'ACTIVA',   1),
    (3, 'R-03', '[FICTICIO] Ruta Marina y Oriente',    'ACTIVA',   1),
    (4, 'R-04', '[FICTICIO] Ruta Puertos',             'BORRADOR', 1)
ON CONFLICT (id) DO NOTHING;

INSERT INTO ruta_barrio (ruta_id, barrio_id, orden) VALUES
    (1, 1, 1),
    (2, 2, 1), (2, 3, 2),
    (3, 4, 1), (3, 5, 2),
    (4, 6, 1)
ON CONFLICT DO NOTHING;

INSERT INTO horario_ruta (id, ruta_id, dia_semana, hora_inicio, hora_fin) VALUES
    (1, 1, 1, '06:00', '10:00'), (2, 1, 2, '06:00', '10:00'), (3, 1, 3, '06:00', '10:00'),
    (4, 1, 4, '06:00', '10:00'), (5, 1, 5, '06:00', '10:00'), (6, 1, 6, '06:00', '10:00'),
    (7, 2, 1, '07:00', '11:00'), (8, 2, 4, '07:00', '11:00'),
    (9, 3, 2, '14:00', '18:00'), (10, 3, 5, '14:00', '18:00'),
    (11, 4, 1, '05:00', '09:00'), (12, 4, 2, '05:00', '09:00'), (13, 4, 3, '05:00', '09:00'),
    (14, 4, 4, '05:00', '09:00'), (15, 4, 5, '05:00', '09:00'), (16, 4, 6, '05:00', '09:00')
ON CONFLICT (id) DO NOTHING;

INSERT INTO recorrido (id, ruta_id, horario_id, fecha, estado, con_retraso,
                       inicio_real, fin_real, motivo, actualizado_por) VALUES
    (1, 1, 1, '2026-10-05', 'COMPLETADO', FALSE,
        '2026-10-05 06:05', '2026-10-05 09:50', NULL, 2),
    (2, 2, 7, '2026-10-05', 'COMPLETADO', TRUE,
        '2026-10-05 07:40', '2026-10-05 12:10', '[FICTICIO] Vía bloqueada', 2),
    (3, 1, 2, '2026-10-06', 'CANCELADO',  FALSE,
        NULL, NULL, '[FICTICIO] Sin vehículo disponible', 1),
    (4, 3, 9, '2026-10-06', 'EN_PAUSA',   FALSE,
        '2026-10-06 14:00', NULL, '[FICTICIO] Falla del vehículo', 3),
    (5, 1, 3, '2026-10-07', 'EN_CURSO',   FALSE,
        '2026-10-07 06:00', NULL, NULL, 2),
    (6, 2, 8, '2026-10-08', 'PROGRAMADO', FALSE,
        NULL, NULL, NULL, NULL)
ON CONFLICT (id) DO NOTHING;

INSERT INTO incidencia (id, recorrido_id, barrio_id, tipo, descripcion, estado, registrada_por) VALUES
    (1, 2,    2, 'VIA_BLOQUEADA',        '[FICTICIO] Calle cerrada por obra',         'CERRADA',     2),
    (2, 4,    4, 'VEHICULO_AVERIADO',    '[FICTICIO] Pinchazo en compactador',        'EN_ATENCION', 3),
    (3, NULL, 6, 'ACUMULACION_RESIDUOS', '[FICTICIO] Punto crítico sin recorrido',    'ABIERTA',     2)
ON CONFLICT (id) DO NOTHING;

INSERT INTO historial_estado_recorrido (id, recorrido_id, estado_anterior, estado_nuevo, usuario_id, motivo) VALUES
    (1, 1, 'PROGRAMADO', 'EN_CURSO',   2, NULL),
    (2, 1, 'EN_CURSO',   'COMPLETADO', 2, NULL),
    (3, 3, 'PROGRAMADO', 'CANCELADO',  1, '[FICTICIO] Sin vehículo disponible'),
    (4, 4, 'PROGRAMADO', 'EN_CURSO',   3, NULL),
    (5, 4, 'EN_CURSO',   'EN_PAUSA',   3, '[FICTICIO] Falla del vehículo')
ON CONFLICT (id) DO NOTHING;

DO $$
BEGIN
    PERFORM setval('usuario_id_seq',                    (SELECT max(id) FROM usuario));
    PERFORM setval('sector_id_seq',                     (SELECT max(id) FROM sector));
    PERFORM setval('barrio_id_seq',                     (SELECT max(id) FROM barrio));
    PERFORM setval('ruta_id_seq',                       (SELECT max(id) FROM ruta));
    PERFORM setval('horario_ruta_id_seq',               (SELECT max(id) FROM horario_ruta));
    PERFORM setval('recorrido_id_seq',                  (SELECT max(id) FROM recorrido));
    PERFORM setval('incidencia_id_seq',                 (SELECT max(id) FROM incidencia));
    PERFORM setval('historial_estado_recorrido_id_seq', (SELECT max(id) FROM historial_estado_recorrido));
END $$;

COMMIT;
