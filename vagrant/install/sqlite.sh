#!/bin/bash
set -eux

## Environment variables
source "../config/env.sh"

## -----------------------------------------------------------------------------

## Sources
apt-get update

## SQLite
apt-get install -y php${PHP_VERSION}-sqlite3

## -----------------------------------------------------------------------------

## Services
service apache2 reload
