#!/bin/bash

#set -eu

DB_PATH="/vagrant/database"

## Set computer ID
echo $1 > $DB_PATH/computer

## Information
success() {
    echo -e "\nThe database $1 has been BACKUPED!\n"
}

## Backup (MySQL, Mariadb)
backup() {
    sudo tar -czf $DB_PATH/$1.tar.gz -C /var/lib/$1 .
    success $1
}

## MySQL
if [ -d "/var/lib/mysql" ]; then
    backup mysql $1
fi

## MongoDB
if [ -d "/var/lib/mongodb" ]; then
    backup mongodb $1
fi

## PostgreSQL
if [ -d "/var/lib/postgresql" ]; then
    PGUSER=postgres pg_dumpall | gzip > $DB_PATH/postgres.sql.gz
    success postgresql
fi





## Date
#export today=`date +%Y%m%d`
#export deleteday=`/bin/date –date=”15 days ago” +%Y%m%d`
## Delete old backup script
#rm -f /tmp/pgalldump_$deleteday.dump.out
## Create backup script
#pg_dumpall > /tmp/pgalldump_$today.dump.out


#HOSTNAME=$(hostname -d)
#$TODAY=`date --iso-8601`
#$BACKDIR=/backup
#pg_dump [options] > $BACKDIR/$HOSTNAME-$TODAY
#if [ "$?"-ne 0]; then echo "Help" | mail -s "Backup failed" you@example.com; exit 1; fi



#hostname=`hostname`
## Dump DBs
#  date=`date +"%Y%m%d_%H%M%N"`
#  filename="/var/backups/app/${hostname}_${db}_${date}.sql"
#  pg_dump databasename >  $filename
#  gzip $filename
#exit 0