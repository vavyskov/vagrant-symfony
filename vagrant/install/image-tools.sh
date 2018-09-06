#!/bin/bash
set -eux

## Variables
PHP_VERSION=7.2

## -----------------------------------------------------------------------------

## Sources
apt-get update

## Image tools
apt-get install -y libjpeg-progs optipng gifsicle php${PHP_VERSION}-imagick

## -----------------------------------------------------------------------------

## Services
service apache2 reload
