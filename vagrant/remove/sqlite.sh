#!/bin/bash
set -eu

## Detect permission
if [ $(id -u) != 0 ]; then
   echo -e "\nYou have to run this script as root or with sudo prefix!\n"
   exit
fi

## Current script directory path
CURRENT_DIRECTORY=$(dirname $0)

## Environment variables
source "$CURRENT_DIRECTORY/../config/env.sh"
PHP_VERSION=$(php -v | cut -d" " -f2 | cut -d"." -f1,2 | head -1)

## -----------------------------------------------------------------------------

## Get confirmation
while true; do

    echo -e "\nI want to delete $(tput setaf 1)SQLite$(tput sgr 0)!!!"

    ## New line
    echo -e ''

    read -e -p 'Do you really want to delete it? (Yes/No/Cancel): ' -n 1 CONTINUE
    if [[ ${CONTINUE} =~ ^[Yy].*$ ]]; then
        break
    elif [[ ${CONTINUE} =~ ^[Cc].*$ ]]; then
        exit
    fi
    echo -e ''
done

## New line
echo -e ''

## -----------------------------------------------------------------------------

## Remove SQLite
apt-get purge --auto-remove -y sqlite3 php${PHP_VERSION}-sqlite3

## -----------------------------------------------------------------------------

## Purge
#apt-get autoremove -y
#bash "$CURRENT_DIRECTORY/../config/purge.sh"

## -----------------------------------------------------------------------------

## Services
service apache2 reload
