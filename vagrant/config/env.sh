#!/bin/bash
set -eu

## Environment variables

HOSTNAME=$(hostname -d)

MARIADB_ROOT_PASSWORD=root
MARIADB_DB=mariadb
MARIADB_USER=mariadb
MARIADB_PASSWORD=mariadb

PHPMYADMIN_PASSWORD=phpmyadmin

## E-mail
#MX_RECORD=mail.website.cz
#EMAIL_DOMAIN=website.cz
#HOSTNAME=example.com

#EMAIL_SMTP=smtp.centrum.cz
#EMAIL_USERNAME=user@centrum.cz
#EMAIL_PASSWORD=password