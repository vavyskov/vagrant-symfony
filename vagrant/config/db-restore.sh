#!/bin/bash

#set -eu

PATH="/vagrant/database"

## Detect computer ID
if [[ -f "$PATH/computer" && $(grep $1 $PATH/computer) ]]; then
#if [ $(grep $1 $PATH/computer) ]; then
   echo -e "\nThe same computer detected => the database restoring SKIPPED!\n"
   exit
fi

## Information
success() {
    echo -e "\nThe database $1 has been RESTORED!\n"
}

## Restore (MySQL, Mariadb)
restore() {
    echo "Stopping service $1"
    service $1 stop
    echo "Removing existing $1 files"
    rm -rf /var/lib/$1/*
    echo "Restoring $1 backup"
    tar -xzf $PATH/$1.tar.gz -C /var/lib/$1
    echo "Starting service $1"
    service $1 start
    success $1
}

## MySQL
if [[ -d "/var/lib/mysql" && -f "$PATH/mysql.tar.gz" ]]; then
    restore mysql
fi

## MongoDB
if [[ -d "/var/lib/mongodb" && -f "$PATH/mongodb.tar.gz" ]]; then
    restore mongodb
fi

## PostgreSQL
if [[ -d "/var/lib/postgresql" && -f "$PATH/postgres.sql.gz" ]]; then
    gunzip < $PATH/postgres.sql.gz | PGUSER=postgres psql postgres
    success postgresql
fi
