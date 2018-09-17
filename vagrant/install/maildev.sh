#!/bin/bash
set -eu

## Detect permission
if [ $(id -u) != 0 ]; then
   echo -e "\nThis script must be run as root or with sudo prefix!\n"
   exit
fi



## Environment variables
#source "../config/env.sh"

## -----------------------------------------------------------------------------

## Sources
apt-get update

## MailDev
npm install -g maildev





## Set port (default 1025)
#maildev -s 25

## Set application port (default 1080)
#maildev -w8888

## Run MailDev
#maildev



## Run MailDev as service (version A)
#npm install -g forever
#forever start $(which maildev)

## Another forever commands
#forever list
#forever stop $(which maildev)
#forever stopall
#forever start --minUptime 1 --spinSleepTime 1000 -w $(which maildev)

## Run MailDev as service (version B)
cat << EOF > /etc/systemd/system/maildev.service
[Unit]
Description=Maildev SMTP Server and Web Interface
Before=apache2.service

[Service]
ExecStart=$(which maildev)
Restart=always
RestartSec=1

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
#service maildev start

## Make MailDev start on boot
echo "@reboot root service maildev start" >> /etc/crontab
update-rc.d cron defaults

## postfix
sed -i "s/relayhost = $/relayhost = 127.0.0.1:1025/" /etc/postfix/main.cf

## php.ini
##;sendmail_path = /usr/sbin/sendmail -t -i -S maildev:1025
#SMTP = localhost
#smtp_port = 1025

## -----------------------------------------------------------------------------

## Services
#service apache2 reload
service postfix restart
service maildev restart
