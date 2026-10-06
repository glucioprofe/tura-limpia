#!/usr/bin/env bash
# Tura Limpia - Célula 4: crea una base VACÍA en Docker, aplica el esquema,
# carga los datos ficticios DOS veces y corre las comprobaciones.
# Uso (desde la raíz del repo):  bash db/verificar.sh
# Solo para pruebas locales. No toca ninguna base compartida ni producción.
set -euo pipefail

RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
ESQUEMA="${ESQUEMA:-$RAIZ/docs/01 esquema.sql}"
DIR="$(cd "$(dirname "$0")" && pwd)"
CONT=tura_limpia_verif
IMG="${IMG:-postgres:16-alpine}"

docker rm -f "$CONT" >/dev/null 2>&1 || true
docker run -d --name "$CONT" -e POSTGRES_PASSWORD=prueba -e POSTGRES_DB=tura_limpia "$IMG" >/dev/null
trap 'docker rm -f "$CONT" >/dev/null 2>&1 || true' EXIT

until docker exec "$CONT" pg_isready -U postgres -d tura_limpia -q; do sleep 1; done
sleep 1

psql_f() { docker exec -i "$CONT" psql -U postgres -d tura_limpia -v ON_ERROR_STOP=1 -q "$@"; }

echo "1) Esquema";               psql_f < "$ESQUEMA"
echo "2) Carga ficticia (1ª)";   psql_f < "$DIR/02_seed_ficticio.sql" >/dev/null
echo "3) Carga ficticia (2ª)";   psql_f < "$DIR/02_seed_ficticio.sql" >/dev/null
echo "4) Comprobaciones";        psql_f < "$DIR/03_comprobaciones.sql"
echo "Listo."
