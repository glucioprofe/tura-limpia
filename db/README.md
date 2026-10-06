# Célula 4 · Datos de prueba e integridad

Los datos de `02_seed_ficticio.sql` son ficticios y solo sirven para probar el modelo.

## Cómo correrlo

Se necesita Docker. Desde la raíz del repo:

```bash
bash db/verificar.sh
```

El script crea una base PostgreSQL vacía en un contenedor temporal, aplica `docs/01 esquema.sql`, carga los datos dos veces para comprobar que no se duplican y ejecuta las comprobaciones. Al final borra el contenedor.

## Archivos

| Archivo | Contenido |
|---|---|
| `02_seed_ficticio.sql` | Datos de prueba: usuarios, sectores, barrios, rutas, horarios, recorridos e incidencias. |
| `03_comprobaciones.sql` | Conteos, restricciones, consultas entre módulos y hallazgos del esquema. |
| `04_esquema_propuesto.sql` | Esquema del MER propuesto por la célula 4. |
| `verificar.sh` | Ejecuta la carga y las comprobaciones en una base vacía. |
