#!/bin/bash
set -eux

## Variables
PHP_VERSION=7.2

## -----------------------------------------------------------------------------

## Sources
apt-get update

## SQLite
apt-get install -y php${PHP_VERSION}-sqlite3

## -----------------------------------------------------------------------------

## Services
service apache2 reload
