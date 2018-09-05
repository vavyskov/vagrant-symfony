#!/bin/sh
set -eux

## Variables

## -----------------------------------------------------------------------------

## Sources
apt-get update

## MongoDB (default port is 27017)
apt install -y mongodb php-mongodb
#apt install -y mongodb php-mongodb >> /vagrant/vm_build_mongodb.log 2>&1

## -----------------------------------------------------------------------------

## Services
service apache2 reload
service mongodb start