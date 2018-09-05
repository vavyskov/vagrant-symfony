#!/bin/sh
set -eux

## Variables

## -----------------------------------------------------------------------------

## Sources
apt-get update

## PhpPgAdmin
apt install -y phppgadmin
cp /vagrant/config/phppgadmin.conf /etc/apache2/conf-available/

## Enable postgres user login
sed -i "s/extra_login_security'] = true/extra_login_security'] = false/" /etc/phppgadmin/config.inc.php

## -----------------------------------------------------------------------------

## Services
service apache2 reload
