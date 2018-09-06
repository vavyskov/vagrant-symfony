#!/bin/bash
set -eux

## Variables
PHP_VERSION=7.2

## -----------------------------------------------------------------------------

## Sources
apt-get update

## MongoDB (default port is 27017)
apt install -y mongodb php${PHP_VERSION}-mongodb
#apt install -y mongodb php-mongodb >> /vagrant/vm_build_mongodb.log 2>&1

## -----------------------------------------------------------------------------

## Services
service apache2 reload
service mongodb start