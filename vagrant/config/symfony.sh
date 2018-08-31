#!/bin/sh
set -eux

## E-mail
#MX_RECORD=mail.website.cz
#EMAIL_DOMAIN=website.cz
#HOSTNAME=example.com

#EMAIL_SMTP = smtp.centrum.cz
#EMAIL_USERNAME = user@centrum.cz
#EMAIL_PASSWORD = password

## -----------------------------------------------------------------------------

## Apt configuration
cat << EOF > /etc/apt/apt.conf.d/99minimal
Apt::Install-Recommends false;
Apt::Install-Suggests false;
Apt::AutoRemove::RecommendsImportant false;
Apt::AutoRemove::SuggestsImportant false;
EOF

## Sources
apt-get update
apt-get upgrade -y

## Certificates
apt-get install -y ca-certificates openssl

## Language
apt-get install -y locales
sed -i "s/# cs_CZ.UTF-8/cs_CZ.UTF-8/" /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG=cs_CZ.UTF-8

## Configuration
apt-get install -y debconf-utils

## System tools
apt-get install -y wget curl zip unzip
#apt-get install -y nmon



## Vim
apt-get install -y vim
#cat << EOF > /etc/vim/vimrc.local
#syntax on
#set background=dark
#set esckeys
#set ruler
#set laststatus=2
#set nobackup
#autocmd BufNewFile,BufRead Vagrantfile set ft=ruby
#EOF



## MC
apt-get install -y mc
#cp ./mc /etc/mc/
#cp ./mc ~/.config/

## use_internal_edit=1

#cp ./mc/.mc.ini /home/vagrant/
#chown vagrant:vagrant /home/vagrant/.mc.ini
#chmod -R -x /home/vagrant/.mc.ini

## Edit=%var{EDITOR:editor} %f
#cp -p ./mc/mc.ext /home/vagrant/.config/mc/
#chown vagrant:vagrant /home/vagrant/.config/mc/mc.ext
# chmod -R -x /home/vagrant/.config/mc/mc.ext



## Sudo
apt-get install -y sudo
sed -i 's/%sudo.*ALL=(ALL:ALL) ALL/%sudo\tALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers

## IPv6
echo "net.ipv6.conf.all.disable_ipv6=1" > /etc/sysctl.d/ipv6.conf
sysctl -p

## VMware
apt-get install -y open-vm-tools

## NTP
apt-get install -y ntp
sed -i 's/poll/#poll/' /etc/ntp.conf
sed -i '/#poll 3/a\poll hodiny.ispovy.acr iburst' /etc/ntp.conf
service ntp restart
timedatectl set-timezone Europe/Prague

## SNMP
apt-get install -y snmpd
#sed -i 's/xyz/xyz/' /etc/snmp/snmpd.conf
#service snmpd restart

## SSH
sed -i 's/#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config
#sed -i 's/#PermitEmptyPasswords/PermitEmptyPasswords/' /etc/ssh/sshd_config

## -----------------------------------------------------------------------------

## Node.js (latest)
#curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

## Node.js (LTS)
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

## Node.js
apt-get install -y nodejs

## Node.js - Yarn (a node module manager)
npm install yarn -g

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

## PHP 7.0
#apt-get install -y php php-gd php-mbstring php-opcache php-xml php-curl php-zip php-ldap
##apt-get install -y php-cli php-xdebug libpng-dev

## PHP 7.2
apt-get install -y apt-transport-https lsb-release ca-certificates
wget https://packages.sury.org/php/apt.gpg -O /etc/apt/trusted.gpg.d/php.gpg
sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
apt-get update
## apt-cache search php7.2
apt-get install -y php7.2 php7.2-gd php7.2-mbstring php7.2-opcache php7.2-xml php7.2-curl php7.2-zip php7.2-ldap

## PHP configuration
#cat << EOF > /etc/php/7.0/apache2/conf.d/php.ini
cat << EOF > /etc/php/7.2/apache2/conf.d/php.ini
;; Time zone
date.timezone = Europe/Prague

;; Error reporting
;log_errors = On
;error_log = php_error.log
error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT
display_errors = Off
;display_startup_errors = Off
;track_errors = Off
;mysqlnd.collect_memory_statistics = Off
;zend.assertions = -1
;opcache.huge_code_pages = 1

;; Upload files
post_max_size = 64M
upload_max_filesize = 32M

;; Performance
memory_limit = 256M
max_execution_time = 120
max_input_time  =  60

;; OPcode extension
opcache.memory_consumption = 128
opcache.interned_strings_buffer = 8
opcache.max_accelerated_files = 4000
opcache.revalidate_freq = 60
opcache.fast_shutdown = 1
opcache.enable_cli = 1

;; Drupal Commerce Kickstart
;mbstring.http_input = pass
;mbstring.http_output = pass

;; MongoDB
;extension = mongo.so
;extension = mongodb.so

;; E-mail
;sendmail_path = /usr/sbin/ssmtp -t
;sendmail_path = /usr/sbin/sendmail -t
EOF

## -----------------------------------------------------------------------------

## PostgreSQL
apt-get install -y postgresql php-pgsql

## Enable password-base authentication
sed -i 's/local.*all.*postgres.*peer/local\tall\t\tpostgres\t\t\t\ttrust/' /etc/postgresql/9.6/main/pg_hba.conf
sed -i 's/local.*all.*all.*peer/local\tall\t\tall\t\t\t\t\tmd5/' /etc/postgresql/9.6/main/pg_hba.conf



## Permission - all new databases are created from "template1" by default
## Schema - https://wiki.hackzine.org/sysadmin/postgresql-change-default-schema.html
## Public - https://blog.dbi-services.com/avoiding-access-to-the-public-schema-in-postgresql/
#sudo -u postgres psql template1 -c "
#    REVOKE ALL ON SCHEMA public FROM PUBLIC;
#    GRANT ALL ON SCHEMA public TO PUBLIC;
#"

#CREATE SCHEMA private;
#SET search_path TO private;
#ALTER ROLE <role_name> IN DATABASE <db_name> SET search_path TO schema1,schema2;
#GRANT USAGE ON SCHEMA private TO new_user;

#REVOKE ALL ON SCHEMA public FROM PUBLIC;

#ALTER SCHEMA private OWNER TO { new_owner | CURRENT_USER | SESSION_USER };
#ALTER DEFAULT PRIVILEGES FOR ROLE xyz REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;









## Enable postgres password-base authentication
#sudo -u postgres psql -c "ALTER ROLE postgres WITH PASSWORD '$POSTGRES_ROOT_PASSWORD'"
#sed -i 's/local.*all.*postgres.*peer/local\tall\t\tpostgres\t\t\t\tmd5/' /etc/postgresql/9.6/main/pg_hba.conf





## Share PostgreSQL data
#chown -R postgres:postgres /var/lib/postgresql
#chown -R postgres:postgres /etc/postgresql/9.6

## Only once
#FIRST_RUN=true
#if [[ -d "/usr/lib/postgresql" ]]; then
#if [[ -d "/var/lib/postgresql" ]]; then
#    FIRST_RUN=false
#fi


## Set PostgreSQL password
#if [[ $FIRST_RUN = true ]]; then
#  sudo -u postgres psql -c "ALTER ROLE postgres WITH PASSWORD '$POSTGRES_ROOT_PASSWORD'"
#fi





#if [[ -f "/etc/postgresql/9.6/main/pg_hba.conf" ]]; then


#fi





## Init the database
#/etc/profile.d/profile.local.sh











#sudo -u postgres createdb $POSTGRES_DB
#sudo -u postgres createuser $POSTGRES_USER
#sudo -u postgres psql -c "
#  ALTER ROLE $POSTGRES_USER WITH ENCRYPTED PASSWORD '$POSTGRES_PASSWORD';
#  GRANT ALL ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;
#"

## Notes:
##sudo -u postgres psql -c "CREATE DATABASE $POSTGRES_DB WITH OWNER $POSTGRES_USER;"
##sudo -u postgres psql -c "CREATE DATABASE music ENCODING 'UTF8'  LC_COLLATE 'utf8mb4_czech_ci';"



## Remove database
#sudo -u postgres dropdb $POSTGRES_DB



## -----------------------------------------------------------------------------

## Adminer (old)
#apt-get install -y adminer

## Adminer (latest)
mkdir -p /usr/share/adminer/adminer
wget https://www.adminer.org/latest.php -O /usr/share/adminer/adminer/index.php
echo '50 2 5 * * /usr/bin/wget https://www.adminer.org/latest.php -O /usr/share/adminer/adminer/index.php' > /etc/cron.d/adminer

## Adminer - alias
echo "Alias /adminer /usr/share/adminer/adminer" | sudo tee /etc/apache2/conf-available/adminer.conf
a2enconf adminer.conf
service apache2 restart

## -----------------------------------------------------------------------------

## Git
apt-get install -y git

## Composer (old)
#apt-get install -y composer

## Composer (latest)
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

## Swap (variant A)
## Enble dynamic swap space to prevent "Out of memory" crashes
apt-get install -y swapspace

## Swap (variant B)
## https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-14-04
#fallocate -l 4G /swapfile
#chmod 0600 /swapfile
#mkswap /swapfile
#swapon /swapfile
#echo '/swapfile none swap sw 0 0' >> /etc/fstab
#echo vm.swappiness = 10 >> /etc/sysctl.conf
#echo vm.vfs_cache_pressure = 50 >> /etc/sysctl.conf
#sysctl -p

## -----------------------------------------------------------------------------

## Image tools
#apt-get install -y libjpeg-progs optipng gifsicle php-imagick

## -----------------------------------------------------------------------------

## Services
service apache2 reload
service postgresql reload
#service swapspace status

## -----------------------------------------------------------------------------

## E-mail
apt-get install -y ssmtp
#cp ./ssmtp.conf /etc/ssmtp/

#cat << EOF > /etc/ssmtp/ssmtp.conf
#root=user@host.name
#hostname=host.name
#mailhub=smtp.host.name:465
#FromLineOverride=YES
#AuthUser=username@gmail.com
#AuthPass=password
#AuthMethod=LOGIN
#UseTLS=YES
#EOF

#sed -i 's/root=postmaster/root=postmaster@example.com/' /etc/ssmtp/ssmtp.conf
#sed -i 's/mailhub=mail/mailhub=mail.example.com/' /etc/ssmtp/ssmtp.conf
#sed -i 's/#rewriteDomain=/rewriteDomain=example.com/' /etc/ssmtp/ssmtp.conf
#sed -i 's/#FromLineOverride=YES/FromLineOverride=YES/' /etc/ssmtp/ssmtp.conf

#apt-get install -y sendmail

## -----------------------------------------------------------------------------

## Security





## -----------------------------------------------------------------------------

#mv /var/www/html/index.html /var/www/html/info.html
#rm -rf /var/www/html





#if ! [[ -L /var/www ]]; then
#  rm -rf /var/www
#  ln -fs /vagrant /var/www
#fi

## -----------------------------------------------------------------------------

## Cleaning
#apt-get clean
#apt-get autoclean
#apt-get -y autoremove
#rm -rf /var/lib/apt/lists/*

## -----------------------------------------------------------------------------

## LDAP
#source ./ldap.sh

## -----------------------------------------------------------------------------

## Fix disk fragmentation (increases compression efficiency)
#sudo dd if=/dev/zero of=/EMPTY bs=1M
#sudo rm -f /EMPTY
