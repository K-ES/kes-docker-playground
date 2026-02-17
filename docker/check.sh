#!/bin/bash
set -e

echo "=== Проверяем каталог /import ==="

if [ -f /import/dump.sql ]; then
    echo "Файл найден:"
    ls -lh /import/dump.sql
    echo "Размер:"
    du -sh /import/dump.sql
else
    echo "dump.sql не найден"
fi

echo "=== Запуск PostgreSQL ==="

exec docker-entrypoint.sh postgres