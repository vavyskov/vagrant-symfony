#!/bin/bash
#set -eu
set -e

DOMAIN=$(hostname --domain)
VHOST_PATH="/etc/apache2/sites-available/"

## Detect permission
prompt=$(sudo -nv 2>&1)
if ! [ $? -eq 0 ] || echo $prompt | grep -q '^sudo:'; then
  echo -e "\nRun script as a 'root' user or with 'sudo' at the beginning!\n"
  exit
fi

## Detect first parameter
if [[ $1 = "" ]]; then
  echo -e "\nType project 'name' as the first parameter.\n"
  exit
fi

## -----------------------------------------------------------------------------

# Delete user
if id $1 >/dev/null 2>&1; then
  userdel $1
  rm -fr /home/$1
  echo -e "\nUser '$1' deleted."
else
  echo -e "User '$1' does not exists!"
fi

## Delete virtual host
if [ -f "${VHOST_PATH}test.$1.conf" ]; then
  a2dissite -q test.$1
  rm ${VHOST_PATH}test.$1.conf
  echo -e "Virtual host 'test.$1' deleted."
else
  echo -e "Virtual host '$1' does not exists!"
fi

## Delete database
if sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw $1; then
  sudo -u postgres dropdb $1
  echo -e "Databese '$1' deleted."
else
  echo -e "Database '$1' does not exists!"

fi

## Delete database user
if sudo -u postgres psql -t -c '\du' | cut -d \| -f 1 | grep -qw $1; then
    sudo -u postgres dropuser $1
  echo -e "Database user '$1' deleted.\n"
else
  echo -e "Database user '$1' does not exists!"

fi

## -----------------------------------------------------------------------------

## Services
service apache2 reload
service postgresql reload