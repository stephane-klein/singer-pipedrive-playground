#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../"

docker exec $(docker-compose ps -q data-warehouse) sh -c "rm -rf /sqls/"
docker cp sqls/ $(docker-compose ps -q data-warehouse):/sqls/
docker-compose exec data-warehouse sh -c "cd /sqls/ && psql --quiet -U \$POSTGRES_USER \$POSTGRES_DB -f /sqls/seed.sql"
