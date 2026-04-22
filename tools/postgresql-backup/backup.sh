#!/bin/bash
ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load configuration from an external file
source $ROOT_DIR/config/backup.conf

# Sprogram="psql"
dump_program="pg_dump"

current_timestamp=$(date +%s%3N)
dump_folder="$ROOT_DIR/dumps/${DB_NAME}-${current_timestamp}"

# Export password for non-interactive mode
export PGPASSWORD="$DB_PASSWORD"

current_timestamp=$(date +%s%3N)
dump_file="$ROOT_DIR/dumps/${DB_NAME}-${current_timestamp}.sql"

mkdir -p "$ROOT_DIR/dumps"

main() {
    echo "Starting full backup for database '$DB_NAME'..."
    start_time=$(date +%s%3N)

    # Perform a full database dump into one file
    # -h: host, -U: user, -f: output file
    pg_dump -h "$DB_HOST" -U "$DB_USER" $DUMP_EXTRA_ARGS -f "$dump_file" "$DB_NAME"

    if [ $? -eq 0 ]; then
        end_time=$(date +%s%3N)
        duration=$((end_time - start_time))
        echo "Full backup completed successfully in $duration ms."
        echo "File saved to: $dump_file"
    else
        echo "Error: Backup failed."
        exit 1
    fi
}

main