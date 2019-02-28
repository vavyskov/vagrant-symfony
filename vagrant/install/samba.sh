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

## -----------------------------------------------------------------------------

## Get variables
while true; do

    while true; do
        read -e -p "Workgroup (Get Workgroup on Windows: wmic computersystem get workgroup): " -i ${WORKGROUP:-''} WORKGROUP
        ## https://regex101.com/
        ## ^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#$^+=!*()@%&]).{4,}$
        if [[ ${WORKGROUP} =~ ^[^@#:*,.|\/\"\'\\\ ]{2,}$ ]]; then
            break
        else
            tput bold
            echo -e "Excluded characters are @ # : * , . | / \" ' \ and 'space'."
            echo -e "The minimum length is 2 characters."
            tput sgr0
        fi
    done

    echo -e "\nYour configuration"
    echo -e "------------------"
    echo -e "Workgroup:           $(tput setaf 3)${WORKGROUP}$(tput sgr 0)"

    ## New line
    echo -e ''

    read -e -p 'Is it correct? (Yes/No/Cancel): ' -n 1 CONTINUE
    if [[ ${CONTINUE} =~ ^[Yy].*$ ]]; then
        break
    elif [[ ${CONTINUE} =~ ^[Cc].*$ ]]; then
        exit
    fi
    echo -e ''
done

## New line
echo -e ''

## -----------------------------------------------------------------------------

## Sources
apt-get update

## Samba instalation
apt-get -y install libcups2 samba samba-common cups
#apt-get -y install smbfs

## Samba configuration
## https://www.howtoforge.com/tutorial/debian-samba-server/
mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
cat << EOF > /etc/samba/smb.conf
[global]
workgroup = ${WORKGROUP}
server string = Samba Server %v
netbios name = ${HOSTNAME}
security = user
map to guest = bad user
dns proxy = no

[homes]
   comment = Home Directories
   browseable = no
   valid users = %S
   writable = yes
   create mask = 0700
   directory mask = 0700
EOF


## -----------------------------------------------------------------------------

## Services
service smbd restart
#systemctl restart smbd
#systemctl restart smbd.service
