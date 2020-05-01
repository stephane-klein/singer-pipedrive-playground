#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../"

docker-compose up -d data-warehouse
./scripts/wait-service.sh data-warehouse 5432
docker-compose exec data-warehouse sh -c "createdb -U \$POSTGRES_USER redash" || true
docker-compose run --rm redash create_db
docker-compose up -d
 ./scripts/wait-service.sh redash 5000
docker-compose exec redash sh -c "/app/bin/docker-entrypoint manage users create_root admin@example.com admin --password password --org default"
docker-compose exec redash sh -c '/app/bin/docker-entrypoint manage ds new data-warehouse3 --type pg --options "{\"dbname\":\"postgres\",\"host\":\"data-warehouse\",\"user\":\"postgres\",\"password\":\"password\"}"'