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





## PostgreSQL
apt-get install -y postgresql php${PHP_VERSION}-pgsql

## Enable password-base authentication
sed -i 's/local.*all.*postgres.*peer/local\tall\t\tpostgres\t\t\t\ttrust/' /etc/postgresql/9.6/main/pg_hba.conf
sed -i 's/local.*all.*all.*peer/local\tall\t\tall\t\t\t\t\tmd5/' /etc/postgresql/9.6/main/pg_hba.conf



## Permission - all new databases are created from "template1" by default
## Schema - https://wiki.hackzine.org/sysadmin/postgresql-change-default-schema.html
## Public - https://blog.dbi-services.com/avoiding-access-to-the-public-schema-in-postgresql/
#sudo -u postgres psql template1 -c "
#    REVOKE ALL ON SCHEMA public FROM PUBLIC;
#    GRANT ALL ON SCHEMA public TO PUBLIC;
#"

#CREATE SCHEMA private;
#SET search_path TO private;
#ALTER ROLE <role_name> IN DATABASE <db_name> SET search_path TO schema1,schema2;
#GRANT USAGE ON SCHEMA private TO new_user;

#REVOKE ALL ON SCHEMA public FROM PUBLIC;

#ALTER SCHEMA private OWNER TO { new_owner | CURRENT_USER | SESSION_USER };
#ALTER DEFAULT PRIVILEGES FOR ROLE xyz REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;





## Enable postgres password-base authentication
#sudo -u postgres psql -c "ALTER ROLE postgres WITH PASSWORD '$POSTGRESQL_ROOT_PASSWORD'"
#sed -i 's/local.*all.*postgres.*peer/local\tall\t\tpostgres\t\t\t\tmd5/' /etc/postgresql/9.6/main/pg_hba.conf





## Share PostgreSQL data
#chown -R postgres:postgres /var/lib/postgresql
#chown -R postgres:postgres /etc/postgresql/9.6

## Only once
#FIRST_RUN=true
#if [[ -d "/usr/lib/postgresql" ]]; then
#if [[ -d "/var/lib/postgresql" ]]; then
#    FIRST_RUN=false
#fi


## Set PostgreSQL password
#if [[ $FIRST_RUN = true ]]; then
#  sudo -u postgres psql -c "ALTER ROLE postgres WITH PASSWORD '$POSTGRESQL_ROOT_PASSWORD'"
#fi





#if [[ -f "/etc/postgresql/9.6/main/pg_hba.conf" ]]; then

#fi





## Init the database
#/etc/profile.d/profile.local.sh





#sudo -u postgres createdb $POSTGRES_DB
#sudo -u postgres createuser $POSTGRES_USER
#sudo -u postgres psql -c "
#  ALTER ROLE $POSTGRES_USER WITH ENCRYPTED PASSWORD '$POSTGRES_PASSWORD';
#  GRANT ALL ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;
#"

## Notes:
##sudo -u postgres psql -c "CREATE DATABASE $POSTGRES_DB WITH OWNER $POSTGRES_USER;"
##sudo -u postgres psql -c "CREATE DATABASE music ENCODING 'UTF8'  LC_COLLATE 'utf8mb4_czech_ci';"



## Remove database
#sudo -u postgres dropdb $POSTGRES_DB

## -----------------------------------------------------------------------------

## Detect Vagrant
if [ -d "/vagrant" ]; then
    ## Add database
    #sudo -u postgres createdb $POSTGRESQL_DB

    ## Add database if does not exist
    sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname = '$POSTGRESQL_DB'" | grep -q 1 || sudo -u postgres psql -c "
        CREATE DATABASE $POSTGRESQL_DB
    "

    ## Add user (role)
    ## CREATE USER xyz (alias: CREATE ROLE xyz LOGIN)
    #sudo -u postgres psql -c "
    #    CREATE USER $POSTGRESQL_USER WITH ENCRYPTED PASSWORD '$POSTGRESQL_PASSWORD';
    #    GRANT ALL ON DATABASE $POSTGRESQL_DB TO $POSTGRESQL_USER;
    #    ALTER DATABASE $POSTGRESQL_DB OWNER TO $POSTGRESQL_USER;
    #    REVOKE ALL ON DATABASE $POSTGRESQL_DB FROM PUBLIC;
    #"

    ## Add user (role) if does not exist
    sudo -u postgres psql -tc "SELECT 1 FROM pg_user WHERE usename = '$POSTGRESQL_USER'" | grep -q 1 || sudo -u postgres psql -c "
        CREATE USER $POSTGRESQL_USER WITH ENCRYPTED PASSWORD '$POSTGRESQL_PASSWORD';
        GRANT ALL ON DATABASE $POSTGRESQL_DB TO $POSTGRESQL_USER;
        ALTER DATABASE $POSTGRESQL_DB OWNER TO $POSTGRESQL_USER;
        REVOKE ALL ON DATABASE $POSTGRESQL_DB FROM PUBLIC;
    "





    ##
    ## https://www.pgbarman.org/
    ##
    ## sudo -u postgres psql
    ## SHOW data_directory;
    ## \q
    ##

    ## Change data direcotry (variant A)
    #mkdir /var/lib/postgresql/data
    #chown postgres:postgres /var/lib/postgresql/data
    #su postgres
    #/usr/lib/postgresql/9.6/bin/initdb -D /var/lib/postgresql/data
    #exit
    #service postgresql stop
    #sed -i "s/#data_directory = 'ConfigDir'/data_directory = '\/var\/lib\/postgresql\/data'/" /var/lib/postgresql/data/postgresql.conf
    #service postgresql start

    ## Change data direcotry (variant B)
    #mkdir /var/lib/postgresql/data
    #chown postgres:postgres /var/lib/postgresql/data
    #systemctl stop postgresql
    #rsync -av /var/lib/postgresql/9.6/main /var/lib/postgresql/data
    #sed -i "s/#data_directory = 'ConfigDir'/data_directory = '\/var\/lib\/postgresql\/data'/" /var/lib/postgresql/data/postgresql.conf
    #systemctl start postgresql
fi

## -----------------------------------------------------------------------------

## Services
service apache2 reload
service postgresql reload
