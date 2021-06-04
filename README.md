# docker-mariadb-backup
Perform automated backups from mariadb docker

All backups will be stored in the path `/backup` make sure to persist this path.

### Environment variables:

| Name                | Required    | Description       |
| :---                |   :----:    | :---              |
| TZ                  | yes         | Set your [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) for logs, cron jobs and syncs |
| PUID                | no          | User id to use in case of permission issues |
| PGID                | no          | Group id of the user provided in PUID in case of permission issues |
| BACKUP_FULL         | no          | Defines if a full backup file with all databases should be created. By default this option is enabled so you will get a single file with all databases including system databases. Allowed values are `1` or `0` |
| BACKUP_PER_DB       | no          | Defines if single backup files per db should be created in addition to a complete backup with all db's. Allowed values are `1` or `0` |
| RETENTION    | no          | Retention of backups in days. Default is `7` |
| MYSQL_HOST          | yes         | Mariadb host name |
| MYSQL_PORT          | yes         | Mariadb port |
| MYSQL_USER          | yes         | Username to use to connect to mariadb host |
| MYSQL_PASSWORD      | no          | Password of the mariadb user.  |
| MYSQL_PASSWORD_FILE | no          | Password of the mariadb user as docker secret or file. |


### Docker compose file with mariadb and automated backup
```
version: '3.7'

services:
  mariadb:
    image: mariadb
    container_name: mariadb
    hostname: mariadb
    restart: unless-stopped
    networks:
      - database
    ports:
      - 3306:3306
    environment:
      - MYSQL_ROOT_PASSWORD=<MySecretPassword>
      - HIDE_PHP_VERSION=true
    volumes:
      - config:/etc/mysql/conf.d
      - data:/var/lib/mysql

  mariadb-backup:
    image: ghcr.io/flo-mic/docker-mariadb-backup:latest
    container_name: mariadb-backup
    hostname: mariadb-backup
    networks:
      - database
    volumes:
      - backup:/backup
    environment:
      - TZ=Europe/Berlin
      - RETENTION=7
      - MYSQL_HOST=mariadb
      - MYSQL_PORT=3306
      - MYSQL_USER=root
      - MYSQL_PASSWORD=<MySecretPassword>
    restart: always

networks:
  database: 
    external: false

volumes:
  config:
    external: false
  data:
    external: false
  backup: 
    external: false
```

### Restore an existing backup

To restore an existing backup you can follow the steps described below:

1. If not already done, create an mariadb instance. You can use the example instance from the docker-compose file above.
2. Copy the latest backup to the container and connect to it. For a full recovery of a mariadb instance it is recomended to use the `*.complete.sql.gz` file. This file contains all settings. (Replace **%backupfile%** with the **.sql.gz** file you want to restore.)
```
docker cp %backupfile% mariadb:/tmp/backup.sql.gz
docker exec -it mariadb bash
```
3. Run the restore process and delete the backup file within the container. This will take some time. (Replace **%MYSQL_ROOT_PASSWORD%** with the root password you use.)
```
exec gunzip < /tmp/backup.sql.gz | mysql -uroot -p"$MYSQL_ROOT_PASSWORD"'
rm /tmp/backup.sql.gz
exit
```
