#!/usr/bin/with-contenv bash

# Get backup retention
if [[ -z "$RETENTION" ]]; then
   RETENTION=7
fi

# Timestamp for backup file name
NOW=$(date +"%Y-%m-%d_%H-%M")

# Get mariadb password
if [ "$MYSQL_PASSWORD_FILE" ]; then 
  MYSQL_PASSWORD=`cat $MYSQL_PASSWORD_FILE`;
fi; 
MYSQL_PWD="$MYSQL_PASSWORD" 

# Create a full backup with all db's
mysqldump -h $MYSQL_HOST --port=$MYSQL_PORT --all-databases -f -u $MYSQL_USER -p"${MYSQL_PASSWORD}" | gzip -9 > /backup/${NOW}_complete.sql.gz

# Create individual backups
if [ "$BACKUP_PER_DB" = "1" ]
then
  DBs=$(mysql -h $MYSQL_HOST --port=$MYSQL_PORT -u $MYSQL_USER -p"${MYSQL_PASSWORD}" -Bse "show databases")
  for db in $DBs
  do
    [ "$db" == "information_schema" ] && continue
    [ "$db" == "performance_schema" ] && continue
    mysqldump -h $MYSQL_HOST --port=$MYSQL_PORT -f -u $MYSQL_USER -p"${MYSQL_PASSWORD}" "$db" | gzip -9 > /backup/${NOW}_${db}.sql.gz
 done
fi

# delete all files that are older than xx days and the date does not end with a 2 -> keep ~3 per month
for file in $(find /backup -name *.sql.gz -mtime +${RETENTION} | grep -v '20..-..-.2_')
do
 rm $file
done