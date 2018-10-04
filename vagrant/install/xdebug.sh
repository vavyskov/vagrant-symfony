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

## XDebug
apt-get install -y php-xdebug
#apt-get install -y php-pear php-dev xdebug
## libpng-dev (required for some node package)
#apt-get install -y libpng-dev
cat << EOF > /etc/php/${PHP_VERSION}/mods-available/xdebug.ini
zend_extension=xdebug.so
xdebug.remote_enable=1
;xdebug.remote_host=localhost
;xdebug.remote_port=9001
;xdebug.remote_connect_back=1
xdebug.profiler_enable_trigger=1
xdebug.profiler_enable=0
xdebug.profiler_output_dir="/tmp"
;xdebug.idekey=PHP_STORM
EOF

## -----------------------------------------------------------------------------

## Services
service apache2 reload
