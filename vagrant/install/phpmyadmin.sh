#!/bin/bash
set -eux

## Variables
#MARIADB_ROOT_PASSWORD=root
PHPMYADMIN_PASSWORD=phpmyadmin

## -----------------------------------------------------------------------------

## Show if MySQL or Mariadb is installed
#dpkg -l | grep -e mysql -e mariadb

## Install MariaDB
source "mariadb.sh"

##There are a couple of ways how to execute the script:
#SCRIPT_PATH="/path/to/script.sh"
#$SCRIPT_PATH"
## or
#. "$SCRIPT_PATH"
## or
#source "$SCRIPT_PATH"
## or
#bash "$SCRIPT_PATH"
## or
#eval '"$SCRIPT_PATH"'
## or
#OUTPUT=$("$SCRIPT_PATH")
#echo $OUTPUT
## or
#OUTPUT=`"$SCRIPT_PATH"`
#echo $OUTPUT
## or
#("$SCRIPT_PATH")
## or
#(exec "$SCRIPT_PATH")

## -----------------------------------------------------------------------------

## Sources
apt-get update

## PhpMyAdmin

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $MARIADB_ROOT_PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_PASSWORD"

sudo apt-get -y install phpmyadmin



## PhpMyAdmin - security
chown vagrant:vagrant /var/lib/phpmyadmin/blowfish_secret.inc.php

#randomBlowfishSecret=`openssl rand -base64 32`;
#sed -e "s|cfg\['blowfish_secret'\] = ''|cfg['blowfish_secret'] = '$randomBlowfishSecret'|" config.sample.inc.php > config.inc.php






## PhpMyAdmin storage
mysql -u root --password=$MARIADB_ROOT_PASSWORD -e "
    GRANT ALL PRIVILEGES ON phpmyadmin.* TO pma@localhost IDENTIFIED BY 'pmapass' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
"




## ToDo: config.inc.php
cp /etc/phpmyadmin/config.inc.php /etc/phpmyadmin/config.inc-original.php
#sed -i "s/\/\/ $cfg['Servers'][$i]['controlhost']/$cfg['Servers'][$i]['controlhost']/" /etc/phpmyadmin/config.inc.php
## ???


## PhpMyAdmin storage - user used to manipulate with storage
#sed -i "s|// $cfg['Servers'][$i]['controlhost']|$cfg['Servers'][$i]['controlhost']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['controlport']|$cfg['Servers'][$i]['controlport']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['controluser']|$cfg['Servers'][$i]['controluser']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['controlpass']|$cfg['Servers'][$i]['controlpass']|" /etc/phpmyadmin/config.inc.php
## PhpMyAdmin storage - storage database and tables
#sed -i "s|// $cfg['Servers'][$i]['pmadb']|$cfg['Servers'][$i]['pmadb']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['bookmarktable']|$cfg['Servers'][$i]['bookmarktable']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['relation']|$cfg['Servers'][$i]['relation']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['table_info']|$cfg['Servers'][$i]['table_info']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['table_coords']|$cfg['Servers'][$i]['table_coords']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['pdf_pages']|$cfg['Servers'][$i]['pdf_pages']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['column_info']|$cfg['Servers'][$i]['column_info']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['history']|$cfg['Servers'][$i]['history']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['table_uiprefs']|$cfg['Servers'][$i]['table_uiprefs']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['tracking']|$cfg['Servers'][$i]['tracking']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['recent']|$cfg['Servers'][$i]['recent']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['favorite']|$cfg['Servers'][$i]['favorite']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['users']|$cfg['Servers'][$i]['users']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['navigationhiding']|$cfg['Servers'][$i]['navigationhiding']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['savedsearches']|$cfg['Servers'][$i]['savedsearches']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['central_columns']|$cfg['Servers'][$i]['central_columns']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['designer_settings']|$cfg['Servers'][$i]['designer_settings']|" /etc/phpmyadmin/config.inc.php
#sed -i "s|// $cfg['Servers'][$i]['export_templates']|$cfg['Servers'][$i]['export_templates']|" /etc/phpmyadmin/config.inc.php

## -----------------------------------------------------------------------------

## Services
#service apache2 reload
