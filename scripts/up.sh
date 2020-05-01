#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../"

docker-compose up -d data-warehouse
./scripts/wait-service.sh data-warehouse 5432
./scripts/load-seed.sh