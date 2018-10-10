#!/bin/bash
set -eu

## Detect permission
if [ $(id -u) != 0 ]; then
   echo -e "\nYou have to run this script as root or with sudo prefix!\n"
   exit
fi

## Current script directory path
CURRENT_DIRECTORY=$(dirname $0)

## Environment variables
source "$CURRENT_DIRECTORY/../config/env.sh"

## -----------------------------------------------------------------------------

## Sources
apt-get update



## Apache
apt-get install -y apache2
#rm -rf /var/www/html
#echo "Public folder" > /var/www/html/index.html
cat << EOF > /var/www/html/index.html
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>It works!</title>
</head>
<body>
  <h1>It works!</h1>
</body>
</html>
EOF

## Apache website permissions
apt-get install -y libapache2-mpm-itk
a2enmod mpm_itk

## Apache clean URL and caching
a2enmod rewrite expires

## -----------------------------------------------------------------------------

## Detect Vagrant
if [ -d "/vagrant" ]; then
    #mkdir -p /home/vagrant/www/public
    cp /vagrant/config/apache-dev.conf /etc/apache2/sites-available/000-default.conf
fi

## -----------------------------------------------------------------------------

## Services
service apache2 reload
