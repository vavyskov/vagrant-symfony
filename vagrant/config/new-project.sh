#!/bin/bash

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
  echo -e "\nType project 'name' as the first parameter,"
  echo -e "optionally user 'password' as second parameter and"
  echo -e "optionally database 'password' as third parameter.\n"
  exit
fi

# Detect user
if id "$1" >/dev/null 2>&1; then
  echo -e "\nUser '$1' exists!\n"
  exit
fi

## Detect virtual host
if [ -f "${VHOST_PATH}$1.conf" ]; then
  echo -e "\nVirtual host '$1' exists!\n"
  exit
fi

## Detect database
if sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw $1; then
  echo -e "\nDatabase '$1' exists!\n"
  exit
fi

## Detect database user
if sudo -u postgres psql -t -c '\du' | cut -d \| -f 1 | grep -qw $1; then
  echo -e "\nDatabase user '$1' exists!\n"
  exit
fi

## -----------------------------------------------------------------------------

## Set user password
if [ "$2" ]; then
  USER_PASSWD=$2
else
  USER_PASSWD=$1
fi

## Show user UID and GID
# id -u username
# id -G username

## Add user
useradd $1 -p ${USER_PASSWD} -m -s /bin/bash
mkdir -p /home/$1/www/public
mkdir -p /home/$1/www/private
chown -R $1:$1 /home/$1/www
echo -e "\nUser '$1' with password '${USER_PASSWD}' created."

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
echo -e "Virtual host '$1' created."

## Set database password
if [ "$3" ]; then
  DB_PASSWD=$3
else
  DB_PASSWD=$1
fi

## Add database and database user
sudo -u postgres createdb $1
sudo -u postgres psql -c "
    CREATE USER $1 WITH ENCRYPTED PASSWORD '${DB_PASSWD}';
    GRANT ALL ON DATABASE $1 TO $1;
    ALTER DATABASE $1 OWNER TO $1;
    REVOKE ALL ON DATABASE $1 FROM PUBLIC;
"
echo -e "Databese user '$1' with database password '${DB_PASSWD}' created.\n"

## Change database user password
#sudo -u postgres psql -c "ALTER ROLE $POSTGRES_USER WITH ENCRYPTED PASSWORD '$POSTGRES_PASSWORD';"

## -----------------------------------------------------------------------------

## Services
service apache2 reload
service postgresql reload