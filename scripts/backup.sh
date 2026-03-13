#!/bin/bash

set -e

BACKUP_DIR="/opt/backups"
REMWAVE_DIR="/opt/remnawave"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
TMP_DIR="/tmp/remnawave-backup-$DATE"

mkdir -p "$TMP_DIR"
mkdir -p "$BACKUP_DIR"

echo "Starting Remnawave backup..."

# ищем контейнер БД
DB_CONTAINER=$(docker ps --format '{{.Names}}' | grep remnawave-db | head -n1)

if [ -z "$DB_CONTAINER" ]; then
    echo "Error: remnawave-db container not found"
    exit 1
fi

# читаем env
POSTGRES_USER=$(grep '^POSTGRES_USER=' $REMWAVE_DIR/.env | cut -d '=' -f2)
POSTGRES_DB=$(grep '^POSTGRES_DB=' $REMWAVE_DIR/.env | cut -d '=' -f2)
POSTGRES_PASSWORD=$(grep '^POSTGRES_PASSWORD=' $REMWAVE_DIR/.env | cut -d '=' -f2)

echo "Dumping database..."

docker exec -e PGPASSWORD=$POSTGRES_PASSWORD $DB_CONTAINER \
pg_dump -U $POSTGRES_USER $POSTGRES_DB > $TMP_DIR/postgres.sql

gzip $TMP_DIR/postgres.sql

echo "Copying configs..."

cp $REMWAVE_DIR/.env $TMP_DIR/
cp $REMWAVE_DIR/docker-compose.yml $TMP_DIR/

echo "Creating archive..."

ARCHIVE="$BACKUP_DIR/remnawave-backup-$DATE.7z"

7z a -t7z $ARCHIVE $TMP_DIR/* > /dev/null

rm -rf $TMP_DIR

echo
echo "Backup created:"
echo "$ARCHIVE"
