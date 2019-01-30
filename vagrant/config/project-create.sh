#!/bin/bash
#set -eu
set -e

HOSTNAME=$(hostname)
DOMAIN=$(hostname --domain)
VHOST_PATH="/etc/apache2/sites-available/"

# If HOST contains string
if [[ ${HOSTNAME} =~ .*dev.* ]]; then
    HOST='dev.'
elif [[ ${HOSTNAME} =~ .*test.* ]]; then
    HOST='test.'
else
    HOST=''
fi

## -----------------------------------------------------------------------------

## Detect permission
if [[ $(id -u) != 0 ]]; then
    echo -e "\nRun script as a 'root' user or with 'sudo' at the beginning!\n"
    exit
fi

## Get variables
while true; do

    while true; do
        read -e -p "Project name: " -i ${PROJECT:-''} PROJECT
        ## https://regex101.com/
        ## ^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#$^+=!*()@%&]).{4,}$
        if [[ ${PROJECT} =~ ^([a-z]+[-]*)+[a-z]+$ ]]; then
            break
        else
            echo -e "Allowed characters are lowercase letters and dash (e.g. 'project' or 'my-project') with the minimum length 2 characters."
        fi
    done

    USER=${PROJECT}
    while true; do
        read -e -p "User password: " -i ${USER_PASSWD:-${PROJECT}} USER_PASSWD
        if [[ ${USER_PASSWD} =~ ^.{2,}$ ]]; then
            break
        else
            echo -e "The minimum length is 2 characters."
        fi
    done

    # Replace character(-) in a string with another character(_)
    DB=${PROJECT//[-]/_}
    DB_USER=${PROJECT//[-]/_}

    while true; do
        read -e -p "Database password: " -i ${DB_PASSWD:-${PROJECT}} DB_PASSWD
        if [[ ${DB_PASSWD} =~ ^.{2,}$ ]]; then
            break
        else
            echo -e "The minimum length is 2 characters."
        fi
    done

    echo -e "\nYour configuration"
    echo -e "------------------"
    echo -e "Project name:  $(tput setaf 1)${PROJECT}$(tput sgr 0)"
    echo -e "User:          $(tput setaf 1)${USER}$(tput sgr 0)"
    echo -e "Password:      $(tput setaf 1)${USER_PASSWD}$(tput sgr 0)"
    echo -e "Virtual host:  $(tput setaf 1)${HOST}${PROJECT}.${DOMAIN}$(tput sgr 0)"
    echo -e "Database:      $(tput setaf 1)${DB}$(tput sgr 0) (replace -/_)"
    echo -e "Database user: $(tput setaf 1)${DB_USER}$(tput sgr 0) (replace -/_)"
    echo -e "Dat. password: $(tput setaf 1)${DB_PASSWD}$(tput sgr 0)\n"

    read -e -p 'Is it correct? (Yes/No/Cancel): ' -n 1 CONTINUE
    if [[ ${CONTINUE} =~ ^[Yy].*$ ]]; then
        break
    elif [[ ${CONTINUE} =~ ^[Cc].*$ ]]; then
        exit
    fi
    echo -e ''
done

#read -e -p 'Is it correct? (y/n): ' -n 1 CONTINUE
#case ${CONTINUE} in
#    [Yy]* )
#        break;;
#    [Nn]* )
#        exit 0;;
#    * )
#        echo -e "Answer either 'y' or 'n'."
#esac

#echo "Do you wish to install this program?"
#select yn in "Yes" "No"; do
#    case ${yn} in
#        Yes )
#            echo "yes"
#            break;;
#        No )
#            exit;;
#    esac
#done


## -----------------------------------------------------------------------------

# Detect user
if id ${USER} >/dev/null 2>&1; then
  echo -e "\nUser '${USER}' exists!\n"
  exit
fi

## Detect virtual host
if [[ -f "${VHOST_PATH}${HOST}${PROJECT}.conf" ]]; then
  echo -e "\nVirtual host '${PROJECT}' exists!\n"
  exit
fi

## Detect database
if sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw ${DB}; then
  echo -e "\nDatabase '${DB}' exists!\n"
  exit
fi

## Detect database user
if sudo -u postgres psql -t -c '\du' | cut -d \| -f 1 | grep -qw ${DB_USER}; then
  echo -e "\nDatabase user '${DB_USER}' exists!\n"
  exit
fi

## -----------------------------------------------------------------------------

## Show user UID and GID
# id -u username
# id -G username

## Add user
useradd ${USER} -p ${USER_PASSWD} -m -s /bin/bash
mkdir -p /home/${USER}/www/public
mkdir -p /home/${USER}/www/private
chown -R ${USER}:${PROJECT} /home/${USER}/www
echo -e "\nUser $(tput setaf 2)${USER}$(tput sgr 0) with password $(tput setaf 2)${USER_PASSWD}$(tput sgr 0) created."

## Add virtual host
cat << EOF > ${VHOST_PATH}${HOST}${PROJECT}.conf
<VirtualHost ${HOST}${PROJECT}.${DOMAIN}:80>
  ServerName ${HOST}${PROJECT}.${DOMAIN}
  #ServerAlias mywebsite.cz

  ServerAdmin webmaster@localhost
  DocumentRoot /home/${USER}/www/public

  <Directory "/home/${USER}/www/public">
    Options +FollowSymLinks -Indexes +MultiViews
    AllowOverride all
    Order allow,deny
    Allow from all
    Require all granted
  </Directory>

  ErrorLog \${APACHE_LOG_DIR}/error_${PROJECT}.log
  CustomLog \${APACHE_LOG_DIR}/access_${PROJECT}.log combined

  <IfModule mpm_itk_module>
    AssignUserId ${USER} ${PROJECT}
  </IfModule>
</VirtualHost>
EOF
a2ensite -q ${HOST}${PROJECT} 1>/dev/null
echo -e "Virtual host $(tput setaf 2)${HOST}${PROJECT}.${DOMAIN}$(tput sgr 0) created."

## Add database and database user
sudo -u postgres createdb ${DB}
sudo -u postgres psql -c "
    CREATE USER ${DB_USER} WITH ENCRYPTED PASSWORD '${DB_PASSWD}';
    GRANT ALL ON DATABASE ${DB} TO ${DB_USER};
    ALTER DATABASE ${DB} OWNER TO ${DB_USER};
    REVOKE ALL ON DATABASE ${DB} FROM PUBLIC;
" 1>/dev/null
echo -e "Databese $(tput setaf 2)${DB}$(tput sgr 0) and user $(tput setaf 2)${DB_USER}$(tput sgr 0) with password $(tput setaf 2)${DB_PASSWD}$(tput sgr 0) created.\n"

## Change database user password
#sudo -u postgres psql -c "ALTER ROLE $POSTGRES_USER WITH ENCRYPTED PASSWORD '$POSTGRES_PASSWORD';"

## -----------------------------------------------------------------------------

## Services
service apache2 reload
service postgresql reload
