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

## Sources
apt-get update

## PhpPgAdmin
apt install -y phppgadmin
cp /vagrant/config/phppgadmin.conf /etc/apache2/conf-available/

## Enable postgres user login
sed -i "s/extra_login_security'] = true/extra_login_security'] = false/" /etc/phppgadmin/config.inc.php

## -----------------------------------------------------------------------------

## Services
service apache2 reload
