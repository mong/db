#!/bin/bash

BACKUPDIR=~/backup-imongr-db/$1

if [ $1 = "daily" ]; then
  RETIREDAYS=7
  TIMESTAMP=$(date +%a-%F)
  echo "Running daily backup..."
elif [ $1 = "weekly" ]; then
  RETIREDAYS=30
  TIMESTAMP=$(date +%U-%F)
  echo "Running weekly backup..."
elif [ $1 = "monthly" ]; then
  RETIREDAYS=92
  TIMESTAMP=$(date +%b-%F)
  echo "Running monthly backup..."
else
  echo "One argument of either 'daily', 'weekly' or 'monthly' required."
  echo "Terminating."
  exit
fi

function delete_old_backups()
{
  echo "Deleting $BACKUPDIR/*.sql.gz older than $RETIREDAYS days"
  find $BACKUPDIR -type f -name "*.sql.gz" -mtime +$RETIREDAYS -exec rm {} \;
}

function backup_database()
{
        backup_file="$BACKUPDIR/$TIMESTAMP-imongr-$instance.sql.gz"
        mysqldump --add-drop-database --skip-comments --single-transaction -h $host -u $IMONGR_DB_USER -p$IMONGR_DB_PASS imongr | gzip -9 > $backup_file
}

# run it
host=$IMONGR_DB_HOST_VERIFY
instance="verify"
backup_database
host=$IMONGR_DB_HOST
instance="prod"
backup_database

delete_old_backups

echo "Done."


