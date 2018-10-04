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

## Sources
apt-get update

## Image tools
apt-get install -y imagemagick php-imagick
#apt-get install -y optipng gifsicle

#apt-get install -y libjpeg-progs
#cjpeg -version
#djpeg -version

## -----------------------------------------------------------------------------

## Services
service apache2 reload
