#!/bin/bash
set -e

echo "Init script started..."

if [ -z "$DB_ARCHIVE_URL" ]; then
  echo "DB_ARCHIVE_URL not set. Skipping restore."
  exit 0
fi

mkdir -p /data

ARCHIVE_PATH="/data/db_archive.zip"
UNPACK_DIR="/data/unpacked"

echo "Downloading archive to mounted volume..."
curl -L "$DB_ARCHIVE_URL" -o "$ARCHIVE_PATH"

echo "Unpacking..."
unzip -o "$ARCHIVE_PATH" -d "$UNPACK_DIR"

DUMP_FILE=$(find "$UNPACK_DIR" -type f -name "*.sql" | head -n 1)

if [ -z "$DUMP_FILE" ]; then
  echo "No .sql file found."
  exit 1
fi

echo "Restoring from $DUMP_FILE"
psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f "$DUMP_FILE"

echo "Table statistics:"
psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" <<EOF
SELECT
    schemaname,
    relname,
    pg_size_pretty(pg_total_relation_size(relid)) AS total_size,
    n_live_tup
FROM pg_stat_user_tables
ORDER BY pg_total_relation_size(relid) DESC;
EOF

echo "Init complete."