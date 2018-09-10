#!/bin/bash
set -eux

## Environment variables
source "../config/env.sh"

## -----------------------------------------------------------------------------

## Sources
apt-get update

## Image tools
#apt-get install -y libjpeg-progs optipng gifsicle php${PHP_VERSION}-imagick

## -----------------------------------------------------------------------------

## Services
service apache2 reload
