#!/bin/bash
#set -eu
set -e

## Current script directory path
CURRENT_DIRECTORY=$(dirname $0)

## Environment variables
source "$CURRENT_DIRECTORY/../config/env.sh"

## -----------------------------------------------------------------------------

## Detect permission
if [[ $(id -u) != 0 ]]; then
    echo -e "\n2 Run script as a 'root' user or with 'sudo' prefix at the beginning!\n"
    exit
fi

## Get variables
while true; do

    while true; do
        read -e -p "Delete project: " -i ${PROJECT:-''} PROJECT
        ## https://regex101.com/
        ## ^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#$^+=!*()@%&]).{4,}$
        if [[ ${PROJECT} =~ ^([a-z]+[-]*)+[a-z]+$ ]]; then
            break
        else
            echo -e "Allowed characters are lowercase letters and dash (e.g. 'project' or 'my-project') with the minimum length 2 characters."
        fi
    done

    USER=${PROJECT}

    # Replace character(-) in a string with another character(_)
    DB=${PROJECT//[-]/_}
    DB_USER=${PROJECT//[-]/_}

    echo -e "\nI want to delete"
    echo -e "----------------"
    echo -e "Project:       $(tput setaf 1)${PROJECT}$(tput sgr 0)"
    echo -e "User:          $(tput setaf 1)${USER}$(tput sgr 0)"
    echo -e "Virtual host:  $(tput setaf 1)${HOST}${PROJECT}.${DOMAIN}$(tput sgr 0)"
    echo -e "Database:      $(tput setaf 1)${DB}$(tput sgr 0) (replace -/_)"
    echo -e "Database user: $(tput setaf 1)${DB_USER}$(tput sgr 0) (replace -/_)\n"

    read -e -p 'Do you really want to delete it? (Yes/No/Cancel): ' -n 1 CONTINUE
    if [[ ${CONTINUE} =~ ^[Yy].*$ ]]; then
        break
    elif [[ ${CONTINUE} =~ ^[Cc].*$ ]]; then
        exit
    fi
    echo -e ''
done

## -----------------------------------------------------------------------------

# Delete user
if id ${USER} >/dev/null 2>&1; then
  userdel ${USER}
  rm -fr /home/${USER}
  echo -e "\nUser $(tput setaf 2)${USER}$(tput sgr 0) deleted."
else
  echo -e "User $(tput setaf 1)${USER}$(tput sgr 0) does not exists!"
fi

## Delete virtual host
if [[ -f "${VHOST_PATH}${HOST}${PROJECT}.conf" ]]; then
  a2dissite -q ${HOST}${PROJECT} 1>/dev/null
  rm ${VHOST_PATH}${HOST}${PROJECT}.conf
  echo -e "Virtual host $(tput setaf 2)${HOST}${PROJECT}.${DOMAIN}$(tput sgr 0) deleted."
else
  echo -e "Virtual host $(tput setaf 1)${HOST}${PROJECT}.${DOMAIN}$(tput sgr 0) does not exists!"
fi

## Delete database
if sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw ${DB}; then
  sudo -u postgres dropdb ${DB}
  echo -e "Databese $(tput setaf 2)${DB}$(tput sgr 0) deleted."
else
  echo -e "Database $(tput setaf 1)${DB}$(tput sgr 0) does not exists!"

fi

## Delete database user
if sudo -u postgres psql -t -c '\du' | cut -d \| -f 1 | grep -qw ${DB_USER}; then
    sudo -u postgres dropuser ${DB_USER}
  echo -e "Database user $(tput setaf 2)${DB_USER}$(tput sgr 0) deleted."
else
  echo -e "Database user $(tput setaf 1)${DB_USER}$(tput sgr 0) does not exists!"

fi

## New line
echo -e ''

## -----------------------------------------------------------------------------

## Services
service apache2 reload
service postgresql reload