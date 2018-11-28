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

## Sources
apt-get update




## GLOBAL Drush (variant A)
apt-get install -y mysql-client
curl -fsSL -o /usr/local/bin/drush https://github.com/drush-ops/drush/releases/download/8.1.17/drush.phar
chmod +x /usr/local/bin/drush

## GLOBAL Drush (variant B)
## apt-get install -y mysql-client
#COMPOSER_HOME=/opt/composer composer global require drush/drush:8
#ln -s /opt/composer/vendor/drush/drush/drush /usr/local/bin/drush

## Drush launcher
## https://github.com/drush-ops/drush-launcher




## Drupal console
curl https://drupalconsole.com/installer -L -o /usr/local/bin/drupal
chmod +x /usr/local/bin/drupal

## Drupal console launcher
## https://docs.drupalconsole.com/en/getting/launcher.html

## -----------------------------------------------------------------------------

## Services
#service apache2 reload
