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

## BrowserSync
which browser-sync || npm install -g browser-sync

## Detect Vagrant
if [ -d "/vagrant" ]; then


    ## ToDo: Apache or Nginx
    ## Dependency detection
    if [ -d "/etc/apache2" ]; then


        ## ToDo: PHP proxy
        ## With Apache and PHP
        browser-sync start --proxy "devel.example.com" -f '/home/vagrant/www/public/' --no-open --port 3000


    else

        ## https://browsersync.io/docs/command-line
        ## FixMe: BrowserSync (:3000 or :80 error "Cannot GET /", :3001 OK)
        DOCROOT=/home/vagrant/www/public
        browser-sync start -s -w -f ${DOCROOT} --no-open --port 3000
        #browser-sync start -s -w -f . --no-notify --host 127.0.01 --no-open --port 80
    fi

    ## Ctrl+C to stop the server

fi

## -----------------------------------------------------------------------------

## Services
#service apache2 reload
