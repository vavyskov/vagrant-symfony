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

## Dependency detection
if ! [ -d "/etc/php" ]; then
    ## Install PHP
    source "$CURRENT_DIRECTORY/php.sh"
fi
PHP_VERSION=$(php -v | cut -d" " -f2 | cut -d"." -f1,2 | head -1)

## -----------------------------------------------------------------------------

## Sources
apt-get update



## PhpPgAdmin (old)
apt-get install -y phppgadmin

## ToDo: PhpPgAdmin (latest)
#rm -fr /usr/share/phppgadmin
#wget https://github.com/phppgadmin/phppgadmin/archive/master.zip -O /tmp/phppgadmin.zip
#mkdir /usr/share/phppgadmin
#unzip /tmp/phppgadmin.zip -d /usr/share/
#mv /usr/share/phppgadmin-master /usr/share/phppgadmin
#rm /tmp/phppgadmin.zip
#mkdir /etc/phppgadmin
#cp /usr/share/phppgadmin/conf/config.inc.php-dist /etc/phppgadmin/config.inc.php
#chown -R vagrant:vagrant /usr/share/phppgadmin



## Configuration
cp $CURRENT_DIRECTORY/../config/phppgadmin.conf /etc/apache2/conf-available/

## Enable postgres user login
sed -i "s/extra_login_security'] = true/extra_login_security'] = false/" /etc/phppgadmin/config.inc.php

## -----------------------------------------------------------------------------

## Services
service apache2 reload
