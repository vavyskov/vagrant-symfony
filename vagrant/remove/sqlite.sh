#!/bin/bash
set -eu

## Detect permission
if [ $(id -u) != 0 ]; then
   echo -e "\nThis script must be run as root or with sudo prefix!\n"
   exit
fi

## Current script directory path
CURRENT_DIRECTORY=$(dirname $0)

## Environment variables
source "$CURRENT_DIRECTORY/../config/env.sh"
PHP_VERSION=$(php -v | cut -d" " -f2 | cut -d"." -f1,2 | head -1)

## -----------------------------------------------------------------------------

## Remove SQLite
apt-get purge -y sqlite3 php${PHP_VERSION}-sqlite3

## -----------------------------------------------------------------------------

## Purge
bash "$CURRENT_DIRECTORY/../config/purge.sh"

## -----------------------------------------------------------------------------

## Services
service apache2 reload
