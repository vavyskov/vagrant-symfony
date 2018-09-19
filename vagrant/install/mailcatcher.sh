#!/bin/bash
set -eu

## Detect permission
if [ $(id -u) != 0 ]; then
   echo -e "\nThis script must be run as root or with sudo prefix!\n"
   exit
fi



## https://fostermade.co/blog/email-testing-for-development-using-mailcatcher



## Current script directory path
CURRENT_DIRECTORY=$(dirname $0)

## Environment variables
source "$CURRENT_DIRECTORY/../config/env.sh"

## -----------------------------------------------------------------------------

## Sources
apt-get update

## MailCatcher
apt-get install -y build-essential libsqlite3-dev ruby-dev
gem install mailcatcher --no-ri --no-rdoc

## Make MailCatcher start on boot
echo "@reboot root mailcatcher --ip=0.0.0.0" >> /etc/crontab
update-rc.d cron defaults

## php.ini
cat << EOF > /etc/php/${PHP_VERSION}/apache2/conf.d/php-mailcatcher.ini
;; E-mail
sendmail_path = /usr/bin/env catchmail -f devel@example.com
EOF

## Make php use it to send mail
echo "sendmail_path = /usr/bin/env catchmail -f 'devel@example.com'" >> /etc/php/${PHP_VERSION}/mods-available/mailcatcher.ini

## Notify php mod manager (5.5+)
phpenmod mailcatcher

## Start it now
mailcatcher --ip 0.0.0.0

## -----------------------------------------------------------------------------

## Services
service apache2 reload





## Uninstall ???
#apt-get remove -y build-essential libsqlite3-dev ruby-dev
#gem uninstall mailcatcher
#phpdismod mailcatcher
#service apache2 reload