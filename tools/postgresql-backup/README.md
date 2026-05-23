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

### Run inside Docker

If the tool is mounted into a postgres container, run the backup as your host user so the dump files aren't owned by root:

```bash
docker exec -u $(id -u):$(id -g) postgres /postgresql-backup/backup.sh
```

Run restore with default psql

```bash
time psql -h <HOST> -U <USER> -d <DB_NAME> < /path/to/your/backup.sql
```

## Automation

To run this backup automatically at 10:00 AM every day, add a cron job:

Open your crontab:

```bash
crontab -e
```

Add the following line at the bottom (ensure you use the absolute path to your script):

```bash
00 10 * * * /bin/bash /absolute/path/to/your/backup.sh
```
