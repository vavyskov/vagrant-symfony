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

## Apt configuration
cat << EOF > /etc/apt/apt.conf.d/99minimal
Apt::Install-Recommends false;
Apt::Install-Suggests false;
Apt::AutoRemove::RecommendsImportant false;
Apt::AutoRemove::SuggestsImportant false;
EOF

## Sources
apt-get update
#apt-get upgrade -y
#apt-get dist-upgrade -y
apt-get full-upgrade -y

## Language
apt-get install -y locales
sed -i "s/# cs_CZ.UTF-8/cs_CZ.UTF-8/" /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG=cs_CZ.UTF-8

## NTP
apt-get install -y ntp
sed -i 's/poll/#poll/' /etc/ntp.conf
sed -i '/#poll 3/a\poll hodiny.ispovy.acr iburst' /etc/ntp.conf
service ntp restart
timedatectl set-timezone Europe/Prague

## VMware
apt-get install -y open-vm-tools

## Sudo
apt-get install -y sudo
sed -i 's/%sudo.*ALL=(ALL:ALL) ALL/%sudo\tALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers

## IPv6
echo "net.ipv6.conf.all.disable_ipv6=1" > /etc/sysctl.d/ipv6.conf
sysctl -p

## SNMP
apt-get install -y snmpd
#sed -i 's/xyz/xyz/' /etc/snmp/snmpd.conf
#service snmpd restart

## -----------------------------------------------------------------------------

## Certificates
apt-get install -y ca-certificates openssl

## Configuration
apt-get install -y debconf-utils

## System tools
apt-get install -y wget curl zip unzip lsb-release
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



## SSH
sed -i 's/#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config
#sed -i 's/#PermitEmptyPasswords/PermitEmptyPasswords/' /etc/ssh/sshd_config


## -----------------------------------------------------------------------------

## Git
apt-get install -y git

## -----------------------------------------------------------------------------

## E-mail

## Postfix
sudo debconf-set-selections <<< "postfix postfix/mailname string $(hostname -d)"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt-get install -y postfix
sed -i "s/inet_interfaces = all/inet_interfaces = loopback-only/" /etc/postfix/main.cf



## /etc/postfix/main.cf
##mydestination = $myhostname, localhost.$mydomain, $mydomain



##php.ini
#sendmail_path = /usr/bin/env catchmail -f devel@example.com



## SSMTP
#apt-get install -y ssmtp
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

## Services
#service postfix restart

## -----------------------------------------------------------------------------

#mv /var/www/html/index.html /var/www/html/info.html
#rm -rf /var/www/html



#if ! [[ -L /var/www ]]; then
#  rm -rf /var/www
#  ln -fs /vagrant /var/www
#fi

## -----------------------------------------------------------------------------

## LDAP
#source ./ldap.sh

## -----------------------------------------------------------------------------

## New Project
cp $CURRENT_DIRECTORY/../config/project-create.sh /home/
chmod u+x /home/project-create.sh

## Detect Vagrant
if [ -d "/vagrant" ]; then
    ## New Project
#    cp /vagrant/config/project-create.sh /home/
#    chmod u+x /home/project-create.sh

    ## Enable execute install scripts
    chmod u+x /vagrant/install/*.sh

    ## -----------------------------------------------------------------------------

    ## NTP
    sed -i 's/#poll/poll/' /etc/ntp.conf
    sed -i 's/poll hodiny/#poll hodiny/' /etc/ntp.conf
    service ntp restart


    ## -----------------------------------------------------------------------------

    ## Project 2
    #cd /vagrant/config
    #./project-create.sh project2
    #chown -R project2:project2 /home/project2

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
fi

## -----------------------------------------------------------------------------

## Services
#service apache2 reload
