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

## Dependency detection
which nodejs || source "$CURRENT_DIRECTORY/nodejs.sh"

## HTTP Server
which http-server || npm install -g http-server

## Detect Vagrant
if [ -d "/vagrant" ]; then



    ## ToDo: Apache or Nginx

    ## Dependency detection
    if ! [ -d "/etc/apache2" ]; then
        ## Start HTTP Server
        cd /home/vagrant/www/public
        http-server -p 80 -c-1
        #http-server -p 80 -c-1 -d false
    fi

    ## Ctrl+C to stop the server

fi

## -----------------------------------------------------------------------------

## Services
#service apache2 reload
