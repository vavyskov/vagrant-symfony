#!/bin/bash
#set -eu
set -e

## Current script directory path
if [[ $1 = "vagrant" ]]; then
  CURRENT_DIRECTORY="/vagrant/config"
else
  CURRENT_DIRECTORY=$(dirname $0)
fi

## Environment variables
source "$CURRENT_DIRECTORY/env.sh"

## -----------------------------------------------------------------------------

## New Project
cp /vagrant/config/new-project.sh /home/
chmod u+x /home/new-project.sh

## Enable execute install scripts
chmod u+x /vagrant/install/*.sh

## -----------------------------------------------------------------------------

## NTP
sed -i 's/#poll/poll/' /etc/ntp.conf
sed -i 's/poll hodiny/#poll hodiny/' /etc/ntp.conf
service ntp restart

## -----------------------------------------------------------------------------

## Apache
#mkdir -p /home/vagrant/www/public
cp /vagrant/config/apache-dev.conf /etc/apache2/sites-available/000-default.conf

## -----------------------------------------------------------------------------

## PHP configuration
cp /vagrant/config/php-dev.ini /etc/php/$PHP_VERSION/apache2/conf.d/

## -----------------------------------------------------------------------------

## Project 2
#cd /vagrant/config
#./new-project.sh project2
#chown -R project2:project2 /home/project2

## -----------------------------------------------------------------------------

## PostgreSQL

## Add database
#sudo -u postgres createdb postgresql

## Add database if does not exist
sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname = 'postgresql'" | grep -q 1 || sudo -u postgres psql -c "
    CREATE DATABASE postgresql
"

## Add user (role)
## CREATE USER xyz (alias: CREATE ROLE xyz LOGIN)
#sudo -u postgres psql -c "
#    CREATE USER postgresql WITH ENCRYPTED PASSWORD 'postgresql';
#    GRANT ALL ON DATABASE postgresql TO postgresql;
#    ALTER DATABASE postgresql OWNER TO postgresql;
#    REVOKE ALL ON DATABASE postgresql FROM PUBLIC;
#"

## Add user (role) if does not exist
sudo -u postgres psql -tc "SELECT 1 FROM pg_user WHERE usename = 'postgresql'" | grep -q 1 || sudo -u postgres psql -c "
    CREATE USER postgresql WITH ENCRYPTED PASSWORD 'postgresql';
    GRANT ALL ON DATABASE postgresql TO postgresql;
    ALTER DATABASE postgresql OWNER TO postgresql;
    REVOKE ALL ON DATABASE postgresql FROM PUBLIC;
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

## -----------------------------------------------------------------------------

## E-mail
#cp /vagrant/config/ssmtp-dev.conf /etc/ssmtp/ssmtp.conf
#cp /vagrant/config/revaliases-dev /etc/ssmtp/revaliases

#cat << EOF > /etc/ssmtp/ssmtp.conf
#root=user@host.name
#hostname=host.name
#mailhub=smtp.host.name:465
#FromLineOverride=YES
#AuthUser=username@gmail.com
#AuthPass=password
#AuthMethod=LOGIN
#UseTLS=YES
#EOF

## -----------------------------------------------------------------------------

## Services
service apache2 reload
service postgresql reload

## -----------------------------------------------------------------------------

## Install
bash "$CURRENT_DIRECTORY/../install/maildev.sh"
#bash "$CURRENT_DIRECTORY/../install/xdebug.sh"