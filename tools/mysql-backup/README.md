# Mysql-backup

This is a Bash script to backup a MySQL or MariaDB database by exporting data from each table individually and running the backup commands in parallel for optimal speed.

This tool is depend on `mariadb-dump` or `mysqldump` so make sure that you have one of these tools installed on your system.

## Prerequisites

- `mysqldump` or `mariadb-dump`

## Usage

Create `config/backup.conf` file.

```conf
SERVER_TYPE=mariadb
MAX_JOBS=8

DB_HOST="localhost"
DB_USER="your-username"
DB_PASSWORD="your-password"
DB_NAME="your-database"

DUMP_EXTRA_ARGS="--compress --skip-ssl --quick --single-transaction"
```

Run backup with config file

```console
./backup.sh
```

Run restore with default mysql

```console
time mysql --user=<ADMIN_BACKUP> --password=<PASSWORD> demo < <(cat /path/to/your/restore/*.sql)
```
