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
#if ! [ -d "/etc/php" ]; then
if ! [[ -x $(which php) ]]; then
    ## Install PHP
    source "$CURRENT_DIRECTORY/php.sh"
fi
PHP_VERSION=$(php -v | cut -d" " -f2 | cut -d. -f1,2 | head -1)

## -----------------------------------------------------------------------------

## Sources
apt-get update



## PHP-intl (ICU old)
#apt-get install -y php$PHP_VERSION-intl



## PHP-intl (ICU 62.1)
## https://realpandablog.wordpress.com/2018/02/09/how-to-upgrade-icu-in-intl-in-php-7-0-x-for-linux-ubuntu-16-04/
##
## Show list of PHP modules
## dpkg --get-selections | grep -v deinstall | grep php
##
## Available ICU versions:
## wget -O - http://download.icu-project.org/files/icu4c/ 2>/dev/null | grep -o 'href=.[^/"]\+' | grep -o '".\+' | grep -o '[^"]\+'
##
ICU_VERSION=62.1
if [[ $(php -i | grep "ICU version") ]]; then
    apt-get purge --auto-remove -y php$PHP_VERSION-intl
fi
which g++ || apt-get install -y g++
which phpize || apt-get install -y php$PHP_VERSION-dev



ICU_SRC_FILE="icu4c-$(echo $ICU_VERSION | sed -e 's/\./_/')-src.tgz"
if [[ ! -e "$ICU_SRC_FILE" ]]; then
    wget "http://download.icu-project.org/files/icu4c/$ICU_VERSION/$ICU_SRC_FILE"
fi

test -d icu/source || tar zxvf "$ICU_SRC_FILE"
if [[ ! -e "/opt/icu$ICU_VERSION" ]]; then
    pushd icu/source
        sudo mkdir "/opt/icu$ICU_VERSION"
        ./configure --prefix="/opt/icu$ICU_VERSION" && make && sudo make install
    popd
fi

test -d build-intl || mkdir build-intl
pushd build-intl
    PHP_FULL_VERSION=$(php -r 'echo preg_replace("~-.*$~", "", phpversion());')
    export CXXFLAGS=$(/opt/icu${ICU_VERSION}/bin/icu-config --cxxflags)

    ls -la
    test -d php-src || git clone https://github.com/php/php-src.git
    cd php-src/
    git checkout "php-$PHP_FULL_VERSION"

    cd ext/intl
    phpize
    ./configure --with-php-config=/usr/bin/php-config --with-icu-dir="/opt/icu$ICU_VERSION"
    make CXXFLAGS=$CXXFLAGS

    sudo make install

    PHP_INI_SCAN_DIR=$(php -r 'phpinfo();' | grep 'Scan this dir' | grep -o '/.\+')

    if [[ -d "$PHP_INI_SCAN_DIR" ]]; then
        pushd "$PHP_INI_SCAN_DIR"
            test -e ../../mods-available/intl.ini && sudo ln -s ../../mods-available/intl.ini 20-intl.ini
        popd
    else
        esle 'You are to add intl extension in your php.ini'
    fi
popd;

touch /etc/php/$PHP_VERSION/cli/conf.d/20-intl.ini && bash -c "echo 'extension=intl.so' > /etc/php/$PHP_VERSION/cli/conf.d/20-intl.ini"
touch /etc/php/$PHP_VERSION/apache2/conf.d/20-intl.ini && bash -c "echo 'extension=intl.so' > /etc/php/$PHP_VERSION/apache2/conf.d/20-intl.ini"

## Cleaning
rm -fr build-intl icu
rm -f $ICU_SRC_FILE
apt-get purge --auto-remove -y g++ php$PHP_VERSION-dev

## -----------------------------------------------------------------------------

#curl -fsS -o /tmp/icu.tar.gz -L http://download.icu-project.org/files/icu4c/62.1/icu4c-62_1-src.tgz
#tar -zxf /tmp/icu.tar.gz -C /tmp
#cd /tmp/icu/source
#apt-get install -y g++ php7.2-dev
#./configure --prefix=/usr/local && make && make install
##./configure --prefix=/usr/local/icu && make && make install
##./configure --prefix=/opt/icu && make && make install
##./configure --enable-intl
#touch /etc/php/7.2/cli/conf.d/20-intl.ini && bash -c "echo 'extension=intl.so' > /etc/php/7.2/cli/conf.d/20-intl.ini"
#touch /etc/php/7.2/apache2/conf.d/20-intl.ini && bash -c "echo 'extension=intl.so' > /etc/php/7.2/apache2/conf.d/20-intl.ini"

#ln -s /etc/php/$PHP_VERSION/mods-available/intl.ini /etc/php/$PHP_VERSION/cli/conf.d/20-intl.ini
#/etc/php/7.2/mods-available/intl.ini -> /usr/lib/php/20170718/intl.so

#rm -rf /tmp/icu*
#apt-get purge --auto-remove -y g++​ php7.2-dev

## php -i | grep "ICU version"    ??? 57.1
#​# icu-config --version           ??? 62.1

# /usr/bin/icu-config/icu...

## -----------------------------------------------------------------------------

## Experimental
#sh -c 'echo "deb http://deb.debian.org/debian experimental main" > /etc/apt/sources.list.d/php-intl.list'
#apt-get update
#apt-get -t experimental install php7.2-intl libicu-dev
#rm /etc/apt/sources.list.d/php-intl.list
#apt-get update


## -----------------------------------------------------------------------------

## Services
service apache2 reload

## -----------------------------------------------------------------------------

## Show info
if [[ -x $(which php) ]]; then
    echo "PHP ICU version: $(php -r 'echo defined("INTL_ICU_VERSION") ? INTL_ICU_VERSION : "none";')"
    echo "PHP $(php -i | grep 'ICU version')"
fi
if [[ -x $(which icuinfo) ]]; then
    echo "System ICU version (version A): $(icuinfo | grep -o '"version">[^<]\+' | grep -o '[^"><]\+$')"
fi
if [[ -x $(which icu-config) ]]; then
    echo "System ICU version (version B): $(icu-config --version)"
fi
