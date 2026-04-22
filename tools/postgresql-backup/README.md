# Postgres-backup

This is a Bash script to backup a PostgreSQL database into a single .sql file. It records the total time taken for the dump to help you monitor performance.

This tool depends on `pg_dump`, so make sure you have the PostgreSQL client tools installed on your system.

## Prerequisites

- pg_dump

## Usage

Create `config/backup.conf` file.

```conf
DB_HOST="localhost"
DB_USER="your-username"
DB_PASSWORD="your-password"
DB_NAME="your-database"
# Optional: e.g., "--no-owner --schema=public"
DUMP_EXTRA_ARGS=""
```

Run backup with config file

```bash
./backup.sh
```

Run restore with default psql

```bash
time psql -h <HOST> -U <USER> -d <DB_NAME> < /path/to/your/backup.sql
```
