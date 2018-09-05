#!/bin/sh
set -eux

## Variables

## -----------------------------------------------------------------------------

## Sources
apt-get update

## Image tools
apt install -y libjpeg-progs optipng gifsicle php-imagick

## -----------------------------------------------------------------------------

## Services
service apache2 reload
