#!/bin/bash
##!/bin/su root

DOMAIN=$(hostname --domain)
VHOST_PATH="/etc/apache2/sites-available/"

## Detect permission
prompt=$(sudo -nv 2>&1)
if ! [ $? -eq 0 ] || echo $prompt | grep -q '^sudo:'; then
  echo -e "\nRun script as a 'root' user or with 'sudo' at the beginning!\n"
  exit
fi

## Detect first parameter
if [ "$1" = "" ]; then
  echo -e "\nType project 'name' as the first parameter (optionaly 'password' as the second parameter)!\n"
  exit
fi

## Detect virtual host
if [ -f "${VHOST_PATH}$1.conf" ]; then
  echo -e "\nVirtual host '$1' exists!\n"
  exit
fi

# Detect user
if id "$1" >/dev/null 2>&1; then
  echo -e "\nUser '$1' exists!\n"
  exit
fi                    

## Set user password
if [ "$2" = "" ]; then
  PASSWD=$1
else
  PASSWD=$2
fi

## Add user
useradd $1 -p ${PASSWD} -m -s /bin/bash
mkdir -p /home/$1/www/public
mkdir -p /home/$1/www/private
chown -R $1:$1 /home/$1/www
echo -e "\nUser '$1' with password '${PASSWD}' created."

## Add virtual host
cat << EOF > ${VHOST_PATH}$1.conf
<VirtualHost *:80>
  ServerName $1.${DOMAIN}
  #ServerAlias mywebsite.cz

  ServerAdmin webmaster@localhost
  DocumentRoot /home/$1/www/public

  <Directory "/home/$1/www/public">
    Options +FollowSymLinks -Indexes +MultiViews
    AllowOverride all
    Order allow,deny
    Allow from all
    Require all granted
  </Directory>

  ErrorLog ${APACHE_LOG_DIR}/error_$1.log
  CustomLog ${APACHE_LOG_DIR}/access_$1.log combined

  <IfModule mpm_itk_module>
    AssignUserId $1 $1
  </IfModule>
</VirtualHost>
EOF
a2ensite -q $1
service apache2 reload
echo -e "Virtual host '$1' created.\n"
