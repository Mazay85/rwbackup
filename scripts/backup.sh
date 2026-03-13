#!/bin/bash

set -e

BACKUP_DIR="/opt/backups"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

TMP_DIR="/tmp/rwbackup-$DATE"

mkdir -p $TMP_DIR

echo "Creating backup..."

# find db container
DB_CONTAINER=$(docker ps --format '{{.Names}}' | grep remnawave-db | head -n1)

if [ -z "$DB_CONTAINER" ]; then
    echo "Error: remnawave-db container not found"
    exit 1
fi

# load env
source /opt/remnawave/.env

echo "Dumping database..."

docker exec $DB_CONTAINER \
pg_dump -U $POSTGRES_USER $POSTGRES_DB | gzip > $TMP_DIR/postgres.sql.gz

echo "Copying configs..."

cp /opt/remnawave/.env $TMP_DIR/
cp /opt/remnawave/docker-compose.yml $TMP_DIR/

echo "Creating archive..."

ARCHIVE="$BACKUP_DIR/remnawave-backup-$DATE.tar.gz"

tar -czf $ARCHIVE -C $TMP_DIR .

rm -rf $TMP_DIR

echo
echo "Backup created:"
echo $ARCHIVE
