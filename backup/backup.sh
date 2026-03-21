#!/bin/sh

set -e

BACKUP_DIR="/backups"
DB_NAME="iris_systems_rec_task_development"

while true
do 
    echo "Starting backup process..."

    TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

    DB_FILE="$BACKUP_DIR/db_$TIMESTAMP.sql"
    STORAGE_FILE="$BACKUP_DIR/storage_$TIMESTAMP.tar.gz"
    FINAL_FILE="$BACKUP_DIR/full_backup_$TIMESTAMP.tar.gz"

    # 1. MySQL backup
    mysqldump -h $IRIS_SYSTEMS_REC_TASK_DATABASE_HOST \
              -u root \
              -p$IRIS_ROOT_PASSWORD \
              "$DB_NAME" > "$DB_FILE"

    # 2. Storage backup
    tar -czf "$STORAGE_FILE" -C /app storage

    # 3. Combine into single archive (optional but cleaner)
    tar -czf "$FINAL_FILE" -C "$BACKUP_DIR" \
        "$(basename "$DB_FILE")" \
        "$(basename "$STORAGE_FILE")"

    # 4. Remove intermediate files
    rm -f "$DB_FILE" "$STORAGE_FILE"

    echo "Backup completed at $TIMESTAMP"

    # 5. Retention: keep only last 5 backups
    ls -1t $BACKUP_DIR/full_backup_*.tar.gz | tail -n +6 | xargs -r rm -f

    echo "Old backups cleaned (keeping last 5)"

    # 6. Sleep for 60 seconds before next backup this is tempoprary, in production we can set it to 24 hours or more as needed
    sleep 60 
done