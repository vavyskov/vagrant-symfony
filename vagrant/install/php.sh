#!/bin/bash
#set -eu
set -e

## Detect permission
if [ $(id -u) != 0 ]; then
   echo -e "\nYou have to run this script as root or with sudo prefix!\n"
   exit
fi

## Detect first parameter
if [[ $1 = "5.6" ]]; then
    PHP_VERSION=5.6
elif [[ $1 = "7.0" ]]; then
    PHP_VERSION=7.0
elif [[ $1 = "7.1" ]]; then
    PHP_VERSION=7.1
elif [[ $1 = "7.3" ]]; then
    PHP_VERSION=7.3
else
    PHP_VERSION=7.2
fi

## Current script directory path
CURRENT_DIRECTORY=$(dirname $0)

## Environment variables
source "$CURRENT_DIRECTORY/../config/env.sh"





## Dependency detection
if ! [ -d "/etc/apache2" ]; then
    ## ToDo: Install Apache or Nginx
    source "$CURRENT_DIRECTORY/apache.sh"
fi





## -----------------------------------------------------------------------------

## Sources
apt-get update

## Add sources only for PHP > 7.0 (apt-cache search php)
if $(dpkg --compare-versions $PHP_VERSION gt 7.0); then
    apt-get install -y apt-transport-https lsb-release ca-certificates
    wget https://packages.sury.org/php/apt.gpg -O /etc/apt/trusted.gpg.d/php.gpg
    sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
    apt-get update
fi

## PHP installation
##
## Show list of PHP modules
## dpkg --get-selections | grep -v deinstall | grep php
##
apt-get install -y php$PHP_VERSION php$PHP_VERSION-gd php$PHP_VERSION-mbstring php$PHP_VERSION-opcache php$PHP_VERSION-xml \
    php$PHP_VERSION-curl php$PHP_VERSION-zip php-uploadprogress php-apcu php$PHP_VERSION-ldap php$PHP_VERSION-intl
#apt-get install -y php$PHP_VERSION-cli libpng$PHP_VERSION-dev php$PHP_VERSION-fpm php$PHP_VERSION-bz2 php$PHP_VERSION-imap



## https://github.com/krakjoe/apcu/blob/master/apc.php (APCu info page)



## Time zone
sed -i 's/;date.timezone =/date.timezone = "Europe\/Prague"/' /etc/php/$PHP_VERSION/cli/php.ini

## PHP configuration
cat << EOF > /etc/php/$PHP_VERSION/apache2/conf.d/php-default.ini
[Time zone]
date.timezone="Europe/Prague"

[Error reporting]
log_errors=On
error_log=php_error.log
error_reporting=E_ALL & ~E_DEPRECATED & ~E_STRICT
display_errors=Off
;display_startup_errors=Off
;track_errors=Off
;mysqlnd.collect_memory_statistics=Off
;zend.assertions=-1
;opcache.huge_code_pages=1

[Upload files]
post_max_size=256M
upload_max_filesize=128M

[Performance]
memory_limit=256M
max_execution_time=120
max_input_time=60

[OPcode extension]
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=60
opcache.fast_shutdown=1
opcache.enable_cli=1

[Drupal Commerce Kickstart]
;mbstring.http_input=pass
;mbstring.http_output=pass

[MongoDB]
;extension=mongo.so
;extension=mongodb.so

[E-mail]
sendmail_path=/usr/sbin/sendmail -t -i
;sendmail_path=/usr/sbin/ssmtp -t
EOF

## -----------------------------------------------------------------------------

## Detect Vagrant
if [ -d "/vagrant" ]; then
    ## PHP configuration
    cp /vagrant/config/php-dev.ini /etc/php/$PHP_VERSION/apache2/conf.d/
fi

## -----------------------------------------------------------------------------

## Composer (old)
#apt-get install -y composer

## Composer (latest)
## Directory /usr/local/bin can use proxy
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

## Swap (variant A)
## Enble dynamic swap space to prevent "Out of memory" crashes
apt-get install -y swapspace

## Swap (variant B)
## https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-14-04
#fallocate -l 4G /swapfile
#chmod 0600 /swapfile
#mkswap /swapfile
#swapon /swapfile
#echo '/swapfile none swap sw 0 0' >> /etc/fstab
#echo vm.swappiness = 10 >> /etc/sysctl.conf
#echo vm.vfs_cache_pressure = 50 >> /etc/sysctl.conf
#sysctl -p

## -----------------------------------------------------------------------------

## Set PHP version
update-alternatives --set php /usr/bin/php$PHP_VERSION
#update-alternatives --set phar /usr/bin/phar$PHP_VERSION
#update-alternatives --set phar.phar /usr/bin/phar.phar$PHP_VERSION
#update-alternatives --set phpize /usr/bin/phpize$PHP_VERSION
#update-alternatives --set php-config /usr/bin/php-config$PHP_VERSION

## -----------------------------------------------------------------------------

## Services
service apache2 reload
#service swapspace status





## PHP Major.Minor version
#PHP_TEST=$(php -v | cut -d" " -f2 | cut -d"." -f1,2 | head -1)

## PHP Major.Minor.Patch version
#PHP_TEST=$(php -v | head -1 | cut -d" " -f2 | cut -d"-" -f1)

## Show PHP version
#echo "Current PHP version: $PHP_TEST"
