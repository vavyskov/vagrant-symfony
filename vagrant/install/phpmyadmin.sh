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
if ! [ -d "/var/lib/mysql" ]; then
    ## Install MariaDB
    source "$CURRENT_DIRECTORY/mariadb.sh"
fi

## -----------------------------------------------------------------------------

## Sources
apt-get update

## PhpMyAdmin - configuration
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $MARIADB_ROOT_PASSWORD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_PASSWORD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_PASSWORD"





## PhpMyAdmin (old)
#sudo apt-get -y install phpmyadmin
#chown vagrant:vagrant /var/lib/phpmyadmin/blowfish_secret.inc.php
#cp $CURRENT_DIRECTORY/../config/phpmyadmin-debian.inc.php /etc/phpmyadmin/config.inc.php

## PhpMyAdmin (latest)
curl -fSL "https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz" -o /tmp/phpmyadmin.tar.gz
rm -fr /usr/share/phpmyadmin
mkdir /usr/share/phpmyadmin
tar -xz --strip-components=1 -f /tmp/phpmyadmin.tar.gz -C /usr/share/phpmyadmin
rm /tmp/phpmyadmin.tar.gz
echo "Alias /phpmyadmin /usr/share/phpmyadmin" | sudo tee /etc/apache2/conf-available/phpmyadmin.conf
a2enconf phpmyadmin
service apache2 reload
mkdir /usr/share/phpmyadmin/tmp
if [ -d "/vagrant" ]; then
    chown vagrant:vagrant /usr/share/phpmyadmin/tmp
else
    ## Detect Apache website user
    ## <?php echo `whoami`; ?>
    chown root:www-data /usr/share/phpmyadmin/tmp
    chmod g+w /usr/share/phpmyadmin/tmp
    ## Permission 777 is not good idea
    #chmod 777 /usr/share/phpmyadmin/tmp
fi
mysql -u root -e "CREATE DATABASE IF NOT EXISTS phpmyadmin;"
mysql -u root phpmyadmin < /usr/share/phpmyadmin/sql/create_tables.sql
cp $CURRENT_DIRECTORY/../config/phpmyadmin-latest.inc.php /usr/share/phpmyadmin/config.inc.php
RANDOM_BLOWFISH_SECRET=`openssl rand -base64 32 | tr -dc 'a-zA-Z0-9'`
sed -i "s/\$cfg\['blowfish_secret'\] = ''/\$cfg\['blowfish_secret'\] = '$RANDOM_BLOWFISH_SECRET'/" /usr/share/phpmyadmin/config.inc.php





## ToDo: Cron auto update





## PhpMyAdmin - storage permission
mysql -u root --password=$MARIADB_ROOT_PASSWORD -e "
    GRANT ALL PRIVILEGES ON phpmyadmin.* TO phpmyadmin@localhost IDENTIFIED BY '$PHPMYADMIN_PASSWORD' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
"

## -----------------------------------------------------------------------------

## Services
#service apache2 reload
