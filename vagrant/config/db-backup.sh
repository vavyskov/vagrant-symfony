#!/bin/bash

## Info function
success() {
    echo "The database $1 has been BACKUPED!"
}

## Backup function (MySQL, Mariadb)
backup() {
    sudo tar -czf /vagrant/database/$1.tar.gz -C /var/lib/$1 .
    success $1
}

## MySQL
if [ -d "/var/lib/mysql" ]; then
    backup mysql
fi

## MongoDB
if [ -d "/var/lib/mongodb" ]; then
    backup mongodb
fi

## PostgreSQL
if [ -d "/var/lib/postgresql" ]; then
    PGUSER=postgres PGPASSWORD=postgres pg_dumpall | gzip > /vagrant/database/postgres.sql.gz
    success postgresql
fi



## Date
#export today=`date +%Y%m%d`
#export deleteday=`/bin/date –date=”15 days ago” +%Y%m%d`
## Delete old backup script
#rm -f /tmp/pgalldump_$deleteday.dump.out
## Create backup script
#pg_dumpall > /tmp/pgalldump_$today.dump.out



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
