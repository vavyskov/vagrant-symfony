#!/bin/bash
set -eux

##There are a couple of ways how to execute the script:
#SCRIPT_PATH="/path/to/script.sh"
#$SCRIPT_PATH"
## or
#. "$SCRIPT_PATH"
## or
#source "$SCRIPT_PATH"
## or
#bash "$SCRIPT_PATH"
## or
#eval '"$SCRIPT_PATH"'
## or
#OUTPUT=$("$SCRIPT_PATH")
#echo $OUTPUT
## or
#OUTPUT=`"$SCRIPT_PATH"`
#echo $OUTPUT
## or
#("$SCRIPT_PATH")
## or
#(exec "$SCRIPT_PATH")

## Install MariaDB
source "mariadb.sh"

## Show if MySQL or Mariadb is installed
#dpkg -l | grep -e mysql -e mariadb

## -----------------------------------------------------------------------------

## Sources
apt-get update

## PhpMyAdmin - configuration
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $MARIADB_ROOT_PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_PASSWORD"

## PhpMyAdmin - installation
sudo apt-get -y install phpmyadmin

## PhpMyAdmin - security
chown vagrant:vagrant /var/lib/phpmyadmin/blowfish_secret.inc.php



#randomBlowfishSecret=`openssl rand -base64 32`;
#sed -e "s|cfg\['blowfish_secret'\] = ''|cfg['blowfish_secret'] = '$randomBlowfishSecret'|" config.sample.inc.php > config.inc.php



## PhpMyAdmin - storage permission
mysql -u root --password=$MARIADB_ROOT_PASSWORD -e "
    GRANT ALL PRIVILEGES ON phpmyadmin.* TO phpmyadmin@localhost IDENTIFIED BY '$PHPMYADMIN_PASSWORD' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
"
cp /vagrant/config/phpmyadmin-config.inc.php /etc/phpmyadmin/config.inc.php

## -----------------------------------------------------------------------------

## Services
#service apache2 reload
