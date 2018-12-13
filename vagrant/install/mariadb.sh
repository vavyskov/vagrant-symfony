#!/bin/bash
#set -eu
set -e

## Detect permission
if [ $(id -u) != 0 ]; then
   echo -e "\nYou have to run this script as root or with sudo prefix!\n"
   exit
fi

## Detect first parameter
if [[ $1 = 10.1 ]]; then
    MARIADB_VERSION=10.1
elif [[ $1 = 10.2 ]]; then
    MARIADB_VERSION=10.2
else
    MARIADB_VERSION=10.3
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

## Add sources only for MariaDB > 10.1 (apt-cache search mysql-server, apt-cache search mariadb-server)
## ToDo: Latest version link?
if $(dpkg --compare-versions $MARIADB_VERSION gt 10.1); then
    apt-get install -y software-properties-common dirmngr
    apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
    add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirror.vpsfree.cz/mariadb/repo/10.2/debian stretch main'
    add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirror.vpsfree.cz/mariadb/repo/10.3/debian stretch main'
    apt-get update
fi

## Set root password (Secure)
debconf-set-selections <<< "mysql-server mysql-server/root_password password '$MARIADB_ROOT_PASSWORD'"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password '$MARIADB_ROOT_PASSWORD'"

## Set root password (Dangerous)
#mysql -u root --password=$MARIADB_ROOT_PASSWORD -e "SET PASSWORD FOR root@localhost=PASSWORD('$MARIADB_ROOT_PASSWORD');"




## MariaDB 10.3 - File /etc/mysql/mariadb.conf.d/50-server.cnf (auth_socket.so) does not exist without MariaDB 10.1 installation...
#sed -i '/\[mysqld\]/a\plugin-load-add = auth_socket.so' /etc/mysql/mariadb.conf.d/50-server.cnf

## ToDo: MariaDB (10.3) ALONE do not work correctly WITHOUT MariaDB (10.1) installation :(
apt-get install -y mariadb-server-10.1





## MariaDB
apt-get install -y mariadb-server-${MARIADB_VERSION} php${PHP_VERSION}-mysql

## Configuration
cp $CURRENT_DIRECTORY/../config/mariadb.cnf /etc/mysql/conf.d/

## Upgrade
systemctl restart mariadb
mysql_upgrade

## MariaDB - set all permissions for root user (Optional)
## Enable e.g. access from PhpMyAdmin
#mysql -u root -e "GRANT ALL ON *.* TO root@localhost IDENTIFIED BY 'root'"

## MariaDB - security
#mysql_secure_installation >> /vagrant/vm_build_mysql.log 2>&1

## Detect Vagrant
if [ -d "/vagrant" ]; then
    ## MariaDB - initialization (Dangerous)
    mysql -u root --password=$MARIADB_ROOT_PASSWORD -e "
      CREATE DATABASE IF NOT EXISTS $MARIADB_DB CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci;
      GRANT ALL ON $MARIADB_DB.* TO $MARIADB_USER@localhost IDENTIFIED BY '$MARIADB_PASSWORD';
    "
    #ALTER DATABASE $MARIADB_DB CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci;
fi

## -----------------------------------------------------------------------------

## Services
service apache2 reload
service mysql reload