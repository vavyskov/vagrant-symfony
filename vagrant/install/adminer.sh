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

## Dependency detection
if ! [ -d "/etc/php" ]; then
    ## Install PHP
    source "$CURRENT_DIRECTORY/php.sh"
fi

## -----------------------------------------------------------------------------

## Sources
apt-get update



## Adminer (old)
#apt-get install -y adminer

## Adminer (latest)
mkdir -p /usr/share/adminer/adminer
wget https://www.adminer.org/latest.php -O /usr/share/adminer/adminer/index.php
echo '50 2 5 * * /usr/bin/wget https://www.adminer.org/latest.php -O /usr/share/adminer/adminer/index.php' > /etc/cron.d/adminer

## Adminer - alias
## ToDo: Detect Apache or Nginx
if [ -d "/etc/apache2" ]; then
    echo "Alias /adminer /usr/share/adminer/adminer" | sudo tee /etc/apache2/conf-available/adminer.conf
    a2enconf adminer.conf
    service apache2 restart
fi


## -----------------------------------------------------------------------------

## Services
#service apache2 reload
