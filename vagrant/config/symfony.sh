#!/usr/bin/env bash
set -eux

## Variables
POSTGRES_ROOT_PASSWORD=postgres
#POSTGRES_DB=postgresql
#POSTGRES_USER=postgresql
#POSTGRES_PASSWORD=postgresql

## E-mail
#MX_RECORD=mail.website.cz
#EMAIL_DOMAIN=website.cz
#HOSTNAME=example.com

#EMAIL_SMTP = smtp.centrum.cz
#EMAIL_USERNAME = user@centrum.cz
#EMAIL_PASSWORD = password

## -----------------------------------------------------------------------------

## Sources
apt-get update
#apt-get upgrade -y

## Certificates
apt-get install -y ca-certificates openssl

## Language
apt-get install -y locales
locale-gen cs_CZ.UTF-8

## Configuration
apt-get install -y debconf-utils

## System tools
apt-get install -y curl zip unzip
#apt-get install -y wget nmon






## Vim
apt-get install -y vim
#cat >/etc/vim/vimrc.local <<'EOF'
#syntax on
#set background=dark
#set esckeys
#set ruler
#set laststatus=2
#set nobackup
#autocmd BufNewFile,BufRead Vagrantfile set ft=ruby
#EOF





## MC ?????????????????????
apt-get install -y mc
#cp /vagrant/config/mc /etc/mc/
#cp /vagrant/config/mc ~/.config/

## use_internal_edit=1

#cp /vagrant/config/mc/.mc.ini /home/vagrant/
#chown vagrant:vagrant /home/vagrant/.mc.ini
#chmod -R -x /home/vagrant/.mc.ini

## Edit=%var{EDITOR:editor} %f
#cp -p /vagrant/config/mc/mc.ext /home/vagrant/.config/mc/
#chown vagrant:vagrant /home/vagrant/.config/mc/mc.ext
# chmod -R -x /home/vagrant/.config/mc/mc.ext





## IPv6
echo "net.ipv6.conf.all.disable_ipv6=1" > /etc/sysctl.d/ipv6.conf
sysctl -p

## VMware
apt-get install -y open-vm-tools

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
cat > /var/www/html/index.html <<'EOF'
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

## New Project
cp /vagrant/config/new-project.sh /home/vagrant/

## -----------------------------------------------------------------------------

## PHP 7.0
#apt-get install -y php php-gd php-mbstring php-opcache php-xml php-curl php-zip php-ldap
##apt-get install -y php-cli php-xdebug libpng-dev

## PHP 7.2
apt-get install -y apt-transport-https lsb-release ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
apt-get update
## apt-cache search php7.2
apt-get install -y php7.2 php7.2-gd php7.2-mbstring php7.2-opcache php7.2-xml php7.2-curl php7.2-zip php7.2-ldap

## PHP configuration
#cp /vagrant/config/php.ini /etc/php/7.0/apache2/conf.d/
cp /vagrant/config/php.ini /etc/php/7.2/apache2/conf.d/

## -----------------------------------------------------------------------------

## Only once
FIRST_RUN=true
if [ -d "/usr/lib/postgresql" ]; then 
    FIRST_RUN=false
fi

## PostgreSQL
apt-get install -y postgresql php-pgsql

## Set PostgreSQL password
if [ $FIRST_RUN == true ]; then
  sudo -u postgres psql -c "ALTER ROLE postgres WITH PASSWORD '$POSTGRES_ROOT_PASSWORD'"
fi

## Enable password-base authentication
sed -i 's/local.*all.*postgres.*peer/local\tall\t\tpostgres\t\t\t\tmd5/' /etc/postgresql/9.6/main/pg_hba.conf
sed -i 's/local.*all.*all.*peer/local\tall\t\tall\t\t\t\t\tmd5/' /etc/postgresql/9.6/main/pg_hba.conf

## Init the database
#/etc/profile.d/profile.local.sh











#sudo -u postgres createdb $POSTGRES_DB
#sudo -u postgres createuser $POSTGRES_USER
#sudo -u postgres psql -c "
#  ALTER ROLE $POSTGRES_USER WITH ENCRYPTED PASSWORD '$POSTGRES_PASSWORD';
#  GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;
#"

## Notes:
##sudo -u postgres psql -c "CREATE DATABASE $POSTGRES_DB WITH OWNER $POSTGRES_USER;"
##sudo -u postgres psql -c "CREATE DATABASE music ENCODING 'UTF8'  LC_COLLATE 'utf8mb4_czech_ci';"





## -----------------------------------------------------------------------------

## Adminer (old)
#apt-get install -y adminer

## Adminer (latest)
mkdir -p /usr/share/adminer/adminer
wget "http://www.adminer.org/latest.php" -O /usr/share/adminer/adminer/index.php
echo '50 2 5 * * /usr/bin/wget "http://www.adminer.org/latest.php" -O /usr/share/adminer/adminer/index.php' > /etc/cron.d/adminer

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
#cp /vagrant/config/ssmtp.conf /etc/ssmtp/

#cat > /etc/ssmtp/ssmtp.conf <<'EOF'
#EOF

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





#if ! [ -L /var/www ]; then
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
