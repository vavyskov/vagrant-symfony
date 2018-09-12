#!/bin/bash
set -eu

## Detect permission
if [ $(id -u) != 0 ]; then
   echo -e "\nThis script must be run as root or with sudo prefix!\n"
   exit
fi

## Environment variables
source "../config/env.sh"

## -----------------------------------------------------------------------------

## Sources
apt-get update



## Set root password (Secure)
debconf-set-selections <<< "mysql-server mysql-server/root_password password '$MARIADB_ROOT_PASSWORD'"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password '$MARIADB_ROOT_PASSWORD'"

## Set root password (Dangerous)
#mysql -u root --password=$MARIADB_ROOT_PASSWORD -e "SET PASSWORD FOR root@localhost=PASSWORD('$MARIADB_ROOT_PASSWORD');"



## Mariadb
apt install -y mysql-server php${PHP_VERSION}-mysql

## Mariadb - set all permissions for root user (Optional)
## Enable e.g. access from PhpMyAdmin
#mysql -u root -e "GRANT ALL ON *.* TO root@localhost IDENTIFIED BY 'root'"

## Mariadb - security
#mysql_secure_installation >> /vagrant/vm_build_mysql.log 2>&1

## Configuration
cp /vagrant/config/mariadb.cnf /etc/mysql/conf.d/

## Mariadb - initialization (Dangerous)
mysql -u root --password=$MARIADB_ROOT_PASSWORD -e "
  CREATE DATABASE IF NOT EXISTS $MARIADB_DB CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci;
  GRANT ALL ON $MARIADB_DB.* TO $MARIADB_USER@localhost IDENTIFIED BY '$MARIADB_PASSWORD';
"
#ALTER DATABASE $MARIADB_DB CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci;

## -----------------------------------------------------------------------------

## Services
service apache2 reload
service mysql reload