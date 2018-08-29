#!/bin/bash

FOLDER="/vagrant/database"

## Detect computer ID
if [ $(grep $1 $FOLDER/computer) ]; then
   echo -e "\nThe same computer detected => the database restoring SKIPPED!\n"
   exit
fi

## Info function
success() {
    echo -e "\nThe database $1 has been RESTORED!\n"
}

## Restore function (MySQL, Mariadb)
restore() {
    echo "Stopping service $1"
    service $1 stop
    echo "Removing existing $1 files"
    rm -rf /var/lib/$1/*
    echo "Restoring $1 backup"
    tar -xzf $FOLDER/$1.tar.gz -C /var/lib/$1
    echo "Starting service $1"
    service $1 start
    success $1
}

## MySQL
if [ -d "/var/lib/mysql" ]; then
    restore mysql
fi

## MongoDB
if [ -d "/var/lib/mongodb" ]; then
    restore mongodb
fi

## PostgreSQL
if [ -d "/var/lib/postgresql" ]; then
#    gunzip < $FOLDER/postgres.sql.gz | PGUSER=postgres psql postgres
    #gunzip < $FOLDER/postgres.sql.gz | PGUSER=postgres PGPASSWORD=postgres psql postgres
#    success postgresql
fi
