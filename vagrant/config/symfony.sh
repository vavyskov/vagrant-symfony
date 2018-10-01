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

## Install
bash "$CURRENT_DIRECTORY/../install/debian.sh"
bash "$CURRENT_DIRECTORY/../install/apache.sh"
bash "$CURRENT_DIRECTORY/../install/php.sh"
bash "$CURRENT_DIRECTORY/../install/postgresql.sh"
bash "$CURRENT_DIRECTORY/../install/adminer.sh"
bash "$CURRENT_DIRECTORY/../install/nodejs.sh"
bash "$CURRENT_DIRECTORY/../install/maildev.sh"