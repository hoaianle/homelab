#!/bin/bash
ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load configuration from an external file
source $ROOT_DIR/config/backup.conf

# Setup command for MariaDB and MySQL
program=$SERVER_TYPE

if [ $SERVER_TYPE = 'mysql' ]; then
    dump_program=mysqldump
else
    dump_program=mariadb-dump
fi

current_timestamp=$(date +%s%3N)

dump_folder="$ROOT_DIR/dumps/${DB_NAME}-${current_timestamp}"
single_dump_file="$ROOT_DIR/dumps/${DB_NAME}-${current_timestamp}.sql"
DUMP_MODE=${DUMP_MODE:-tables}

create_dump_folder() {
    if [ ! -d "$dump_folder" ]; then
        mkdir -p "$dump_folder"
    fi
}

get_list_tables() {
    tables=$($program -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "SHOW TABLE STATUS;" | tail -n +2)
    # sort by column 7 and 5 (data length and table rows)
    tables=$(echo "$tables" | sort -k7 -k5 -n)
    # extract first column (table name)
    tables=$(echo "$tables" | awk '{print $1}')
}

dump_table() {
    local table_name="$1"
    local file_path="$dump_folder/${table_name}.sql"
    start_time=$(date +%s%3N)
    $dump_program -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" $DUMP_EXTRA_ARGS "$DB_NAME" "$table_name" > "$file_path"
    end_time=$(date +%s%3N)
    duration=$((end_time - start_time))
    echo "Backup of table '$table_name' completed in $duration ms."
}

dump_single_file() {
    start_time=$(date +%s%3N)
    $dump_program -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" $DUMP_EXTRA_ARGS "$DB_NAME" > "$single_dump_file"
    end_time=$(date +%s%3N)
    duration=$((end_time - start_time))
    echo "Backup completed in $duration ms."
}

dump_tables() {
    create_dump_folder
    get_list_tables
    if [ -z "$tables" ]; then
        echo "No tables found in the database."
        exit 1
    fi
    echo "Starting parallel backup for database '$DB_NAME'..."
    start_time=$(date +%s%3N)

    # Parallel execution
    job_count=0
    for table in $tables; do
        dump_table "$table" &  # Run in background
        ((job_count++))

        # Limit max parallel jobs
        if (( job_count >= MAX_JOBS )); then
            wait  # Wait for jobs to finish before launching more
            job_count=0
        fi
    done

    wait  # Ensure all jobs finish
    end_time=$(date +%s%3N)
    duration=$((end_time - start_time))
    echo "Backup completed in $duration ms."
}

main() {
    if [ "$DUMP_MODE" = "single" ]; then
        dump_single_file
    elif [ "$DUMP_MODE" = "tables" ]; then
        dump_tables
    fi
}

main
