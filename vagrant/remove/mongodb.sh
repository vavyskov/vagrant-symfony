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

## -----------------------------------------------------------------------------

## Remove MongoDB
apt-get purge --auto-remove -y mongodb
#apt-get purge --auto-remove -y mongodb php-mongodb >> /vagrant/vm_build_mongodb.log 2>&1

# Dependency detection
if [ -d "/etc/php" ]; then
    ## Remove PHP extension
    PHP_VERSION=$(php -v | cut -d" " -f2 | cut -d"." -f1,2 | head -1)
    apt-get purge --auto-remove -y php${PHP_VERSION}-mongodb
    service apache2 reload
fi

## -----------------------------------------------------------------------------

## Purge
#apt-get autoremove -y
#bash "$CURRENT_DIRECTORY/../config/purge.sh"

## -----------------------------------------------------------------------------

## Services

