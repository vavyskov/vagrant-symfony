#!/bin/bash
#set -eu
set -e

## Detect permission
if [ $(id -u) != 0 ]; then
   echo -e "\nYou have to run this script as root or with sudo prefix!\n"
   exit
fi

## Detect first parameter
if [[ $1 = "intranet" ]]; then
    NET=intranet
else
    NET=internet
fi

## Current script directory path
CURRENT_DIRECTORY=$(dirname $0)

## Environment variables
source "$CURRENT_DIRECTORY/../config/env.sh"

## -----------------------------------------------------------------------------

## Sources
apt-get update



## NTP
apt-get install -y ntp

## Change NTP pool 3
sed -i 's/pool 3.debian.pool.ntp.org iburst/pool hodiny.ispovy.acr iburst/' /etc/ntp.conf

## Add new NTP after pool 3
#sed -i '/pool 3/a\pool hodiny.ispovy.acr iburst' /etc/ntp.conf

if [[ ${NET} = "intranet" ]]; then
    sed -i 's/^pool 0/#pool 0/' /etc/ntp.conf
    sed -i 's/^pool 1/#pool 1/' /etc/ntp.conf
    sed -i 's/^pool 2/#pool 2/' /etc/ntp.conf
    sed -i 's/^pool 3/#pool 3/' /etc/ntp.conf
    sed -i 's/^#pool hodiny/pool hodiny/' /etc/ntp.conf
else
    sed -i 's/^#pool 0/pool 0/' /etc/ntp.conf
    sed -i 's/^#pool 1/pool 1/' /etc/ntp.conf
    sed -i 's/^#pool 2/pool 2/' /etc/ntp.conf
    sed -i 's/^#pool 3/pool 3/' /etc/ntp.conf
    sed -i 's/^pool hodiny/#pool hodiny/' /etc/ntp.conf
fi

## Czech NTP servers
# pool tik.cesnet.cz iburst
# pool tak.cesnet.cz iburst

## -----------------------------------------------------------------------------

## Services
service ntp restart
timedatectl set-timezone Europe/Prague
