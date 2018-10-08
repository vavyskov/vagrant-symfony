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
PHP_VERSION=$(php -v | cut -d" " -f2 | cut -d"." -f1,2 | head -1)

## -----------------------------------------------------------------------------

## Sources
apt-get update



## PHP intl ICU (old)
#apt-get install -y php$PHP_VERSION-intl

## PHP intl ICU (62.1)
apt-get purge -y php$PHP_VERSION-intl
apt-get install -y php$PHP_VERSION-dev
#apt-get install -y git
git -C /tmp clone https://gist.github.com/siffash/76676186de0ffc6eb6cbf89abc7a5e2f icu-install
chmod +x /tmp/icu-install/icu-install.sh
#/tmp/icu-install/icu-install.sh versions
/tmp/icu-install/icu-install.sh install 62.1
touch /etc/php/$PHP_VERSION/cli/conf.d/20-intl.ini && sudo bash -c 'echo "extension=intl.so" > /etc/php/$PHP_VERSION/cli/conf.d/20-intl.ini' && sudo touch /etc/php/$PHP_VERSION/apache2/conf.d/20-intl.ini && sudo bash -c 'echo "extension=intl.so" > /etc/php/$PHP_VERSION/apache2/conf.d/20-intl.ini'
/etc/init.d/apache2 restart

#apt-get purge --auto-remove -y php7.0-dev
#rm -rf /tmp/icu-install

#php -i | grep "ICU version"
#icu-config --version





#apt-get install -y g++
#curl -fsS -o /tmp/icu.tar.gz -L http://download.icu-project.org/files/icu4c/62.1/icu4c-62_1-src.tgz
#tar -zxf /tmp/icu.tar.gz -C /tmp
#cd /tmp/icu/source
#./configure --prefix=/usr/local
##./configure --prefix=/opt/icu
##./configure --enable-intl
#make
#make install

#/usr/local/share/icu/62.1/install-sh
#/usr/lib/php/20170718/intl.so

#rm -rf /tmp/icu*
#apt-get purge -y g++​

## php -i | grep "ICU version"    ??? 57.1
#​# icu-config --version           ??? 62.1

# /usr/bin/icu-config/icu...

## -----------------------------------------------------------------------------

## Services
service apache2 reload
