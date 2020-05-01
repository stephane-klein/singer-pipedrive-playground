#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../"

docker-compose exec data-warehouse sh -c "psql -U \$POSTGRES_USER \$POSTGRES_DB"