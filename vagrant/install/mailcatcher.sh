#!/bin/bash
set -eu

## Detect permission
if [ $(id -u) != 0 ]; then
   echo -e "\nThis script must be run as root or with sudo prefix!\n"
   exit
fi



## https://fostermade.co/blog/email-testing-for-development-using-mailcatcher



## Environment variables
source "../config/env.sh"

## -----------------------------------------------------------------------------

## Sources
apt-get update

## MailCatcher
apt-get install -y build-essential libsqlite3-dev ruby-dev
gem install mailcatcher --no-ri --no-rdoc

## Make it start on boot
echo "@reboot root mailcatcher --ip=0.0.0.0" >> /etc/crontab
update-rc.d cron defaults

## Make php use it to send mail
echo "sendmail_path = /usr/bin/env catchmail -f 'devel@example.com'" >> /etc/php/${PHP_VERSION}/mods-available/mailcatcher.ini

## Notify php mod manager (5.5+)
phpenmod mailcatcher

## Start it now
mailcatcher --ip 0.0.0.0

## -----------------------------------------------------------------------------

## Services
service apache2 reload
