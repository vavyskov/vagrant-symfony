#!/usr/bin/env bash
set -eux

## -----------------------------------------------------------------------------

## Apache
#mkdir -p /home/vagrant/www/public
cp /vagrant/config/apache.conf /etc/apache2/sites-available/000-default.conf

## -----------------------------------------------------------------------------

## PHP configuration
#cp /vagrant/config/php-dev.ini /etc/php/7.0/apache2/conf.d/
cp /vagrant/config/php-dev.ini /etc/php/7.2/apache2/conf.d/

## -----------------------------------------------------------------------------

## XDebug (version A)
#apt-get install -y php-xdebug
#cp xdebug-docker.ini /usr/local/etc/php/conf.d/
#echo "zend_extension = '$(find / -name xdebug.so 2> /dev/null)'\n$(cat /usr/local/etc/php/conf.d/xdebug-docker.ini)" > /usr/local/etc/php/conf.d/xdebug-docker.ini
#cp /usr/local/etc/php/conf.d/xdebug-docker.ini /etc/php5/cli/conf.d/

## XDebug (version B)
#apt-get install -y php-pear php-dev xdebug
#echo "
#[xdebug]
#zend_extension=/usr/lib/php/20170718/xdebug.so
#xdebug.remote_enable=1
#xdebug.remote_host=192.168.33.1
#xdebug.remote_port=9000">>/etc/php/7.2/apache2/php.ini

## -----------------------------------------------------------------------------

## PostgreSQL
##
## sudo -u postgres psql
## SHOW data_directory;
## \q
##

## Change data direcotry (variant A)
#mkdir /var/lib/postgresql/data
#chown postgres:postgres /var/lib/postgresql/data
#su postgres
#/usr/lib/postgresql/9.6/bin/initdb -D /var/lib/postgresql/data
#exit
#service postgresql stop
#sed -i "s/#data_directory = 'ConfigDir'/data_directory = '\/var\/lib\/postgresql\/data'/" /var/lib/postgresql/data/postgresql.conf
#service postgresql start

## Change data direcotry (variant B)
#mkdir /var/lib/postgresql/data
#chown postgres:postgres /var/lib/postgresql/data
#systemctl stop postgresql
#rsync -av /var/lib/postgresql/9.6/main /var/lib/postgresql/data
#sed -i "s/#data_directory = 'ConfigDir'/data_directory = '\/var\/lib\/postgresql\/data'/" /var/lib/postgresql/data/postgresql.conf
#systemctl start postgresql

## -----------------------------------------------------------------------------

## E-mail
#cp /vagrant/config/ssmtp-dev.conf /etc/ssmtp/ssmtp.conf
#cp /vagrant/config/revaliases-dev /etc/ssmtp/revaliases

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

## -----------------------------------------------------------------------------

## Services
service apache2 reload