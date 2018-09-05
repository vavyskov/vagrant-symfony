#!/bin/sh
set -eux

## Variables

## -----------------------------------------------------------------------------

## Sources
apt-get update

## SQLite
apt install -y php-sqlite3

## -----------------------------------------------------------------------------

## Services
service apache2 reload
