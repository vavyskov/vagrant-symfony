#!/bin/bash
#set -eu
set -e

## Current script directory path
if [ -d "/vagrant" ]; then
#if [[ $1 = "vagrant" ]]; then
  CURRENT_DIRECTORY="/vagrant/config"
else
  CURRENT_DIRECTORY=$(dirname $0)
fi

## Environment variables
source "$CURRENT_DIRECTORY/env.sh"

## -----------------------------------------------------------------------------

## Configuration
bash "$CURRENT_DIRECTORY/debian.sh"

## Installation
bash "$CURRENT_DIRECTORY/../install/ntp.sh" intranet
bash "$CURRENT_DIRECTORY/../install/apache.sh"
bash "$CURRENT_DIRECTORY/../install/php.sh" 7.2
bash "$CURRENT_DIRECTORY/../install/mariadb.sh" 10.3
bash "$CURRENT_DIRECTORY/../install/phpmyadmin.sh"
bash "$CURRENT_DIRECTORY/../install/nodejs.sh"
bash "$CURRENT_DIRECTORY/../install/maildev.sh"
bash "$CURRENT_DIRECTORY/../install/drupal-tools.sh"
