#!/usr/bin/env bash
set -eux

## -----------------------------------------------------------------------------

## Apache
#mkdir -p /home/vagrant/www/public
cp /vagrant/config/apache.conf /etc/apache2/sites-available/000-default.conf

## -----------------------------------------------------------------------------

## PHP configuration
#cp /vagrant/config/php-dev.ini /etc/php/7.0/apache2/conf.d/
cp /vagrant/config/php-dev.ini /etc/php/7.2/apache2/conf.d/

## -----------------------------------------------------------------------------

## Services
service apache2 reload