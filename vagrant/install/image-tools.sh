#!/bin/bash
set -eu

## Detect permission
if [ $(id -u) != 0 ]; then
   echo -e "\nThis script must be run as root or with sudo prefix!\n"
   exit
fi

## Environment variables
source "../config/env.sh"

## -----------------------------------------------------------------------------

## Sources
apt-get update

## Image tools
#apt-get install -y libjpeg-progs optipng gifsicle php${PHP_VERSION}-imagick

## -----------------------------------------------------------------------------

## Services
service apache2 reload
