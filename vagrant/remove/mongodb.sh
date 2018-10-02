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

## -----------------------------------------------------------------------------

## Remove MongoDB
apt-get purge -y mongodb php${PHP_VERSION}-mongodb
#apt-get purge -y mongodb php-mongodb >> /vagrant/vm_build_mongodb.log 2>&1

## -----------------------------------------------------------------------------

## Purge
bash "$CURRENT_DIRECTORY/../config/purge.sh"

## -----------------------------------------------------------------------------

## Services
service apache2 reload
