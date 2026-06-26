#!/bin/bash
ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load configuration from an external file
if [[ -z "${DB_HOST:-}" || -z "${DB_USER:-}" || -z "${DB_PASSWORD:-}" || -z "${DB_NAME:-}" ]]; then
    source "$ROOT_DIR/config/backup.conf"
fi

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

    pg_dump -h "$DB_HOST" -U "$DB_USER" $DUMP_EXTRA_ARGS -f "$dump_file" "$DB_NAME"

    end_time=$(date +%s%3N)
    duration=$((end_time - start_time))

    echo "Backup process finished in $duration ms."
    echo "File: $dump_file"
}

main
