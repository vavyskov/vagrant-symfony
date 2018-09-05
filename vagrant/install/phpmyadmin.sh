#!/bin/sh
set -eux

## Variables
MARIADB_ROOT_PASSWORD=root

## -----------------------------------------------------------------------------

## Show if MySQL or Mariadb is installed
#dpkg -l | grep -e mysql -e mariadb

## -----------------------------------------------------------------------------

## Sources
apt-get update

## PhpMyAdmin

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $MARIADB_ROOT_PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_PASSWORD"

sudo apt-get -y install phpmyadmin



## PhpMyAdmin - security
chown vagrant:vagrant /var/lib/phpmyadmin/blowfish_secret.inc.php

#randomBlowfishSecret=`openssl rand -base64 32`;
#sed -e "s|cfg\['blowfish_secret'\] = ''|cfg['blowfish_secret'] = '$randomBlowfishSecret'|" config.sample.inc.php > config.inc.php

## -----------------------------------------------------------------------------

## Services
service apache2 reload
