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

## Set root password (Secure)
debconf-set-selections <<< "mysql-server mysql-server/root_password password '$MARIADB_ROOT_PASSWORD'"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password '$MARIADB_ROOT_PASSWORD'"

## Set root password (Dangerous)
#mysql -u root --password=$MARIADB_ROOT_PASSWORD -e "SET PASSWORD FOR root@localhost=PASSWORD('$MARIADB_ROOT_PASSWORD');"





## Mariadb (old)
apt-get install -y mysql-server php${PHP_VERSION}-mysql

## Mariadb (10.3) - UPGRADE ONLY - DO NOT WORK ALONE WITHOUT "old" Mariadb (10.1) installation :(
apt-get install -y software-properties-common dirmngr
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
## ToDo: Latest version link?
add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirror.vpsfree.cz/mariadb/repo/10.3/debian stretch main'
apt-get update
apt-get install -y mariadb-server php${PHP_VERSION}-mysql
## ToDo: File 50-server.cnf does not exist without "old" Mariadb (10.1) installation...
sed -i '/\[mysqld\]/a\plugin-load-add = auth_socket.so' /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mariadb.service
mysql_upgrade




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