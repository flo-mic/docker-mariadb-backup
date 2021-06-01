# docker-mariadb-backup
Perform automated backups from mariadb docker

All backups will be stored in the path `/backup` make sure to persist this path.

#### Environment variables:

| Name                | Required    | Description       |
| :---                |   :----:    | :---              |
| TZ                  | yes         | Set your [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) for logs, cron jobs and syncs |
| PUID                | no          | User id to use in case of permission issues |
| PGID                | no          | Group id of the user provided in PUID in case of permission issues |
| BACKUP_PER_DB       | no          | Defines if single backup files per db should be created in addition to a complete backup with all db's. Allowed values are `1` or `0` |
| RETENTION    | no          | Retention of backups in days. Default is `7` |
| MYSQL_HOST          | yes         | Mariadb host name |
| MYSQL_PORT          | yes         | Mariadb port |
| MYSQL_USER          | yes         | Username to use to connect to mariadb host |
| MYSQL_PASSWORD      | no          | Password of the mariadb user.  |
| MYSQL_PASSWORD_FILE | no          | Password of the mariadb user as docker secret or file. |
