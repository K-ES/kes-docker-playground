#!/bin/bash
set -e

echo "=== Проверяем архив ==="

if [ ! -f /import/demo_big.sql.gz ]; then
    echo "demo_big.sql.gz не найден. Запускаем обычный PostgreSQL."
    exec docker-entrypoint.sh postgres
fi

echo "Архив найден. Запускаем PostgreSQL..."

docker-entrypoint.sh postgres &
pid="$!"

# ждём готовности сервера
until pg_isready -U "$POSTGRES_USER" >/dev/null 2>&1; do
    sleep 1
done

echo "=== Загружаем демобазу ==="

gunzip -c /import/demo_big.sql.gz | psql -U "$POSTGRES_USER"

echo "=== Загрузка завершена ==="

wait $pid