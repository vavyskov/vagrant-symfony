#!/bin/bash

#set -eu

## Remove APT cache
echo -e "\nRemoving APT cache...\n"
apt-get clean -y
apt-get autoclean -y
apt-get autoremove -y
rm -r /var/lib/apt/lists/*

## Fix disk fragmentation (increases compression efficiency)
echo -e "\nFixing disk fragmentation...\n"
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

## -----------------------------------------------------------------------------

## Cleanup tmp folder
#echo -e "\nCleaning tmp folder...\n"
#rm -rf /tmp/*
#rm -rf /tmp/.* 2> /dev/null

## Remove unused locales (edit for your needs, this keeps only en* and cs*)
#echo -e "\nRemoving unused locales...\n"
#find /usr/share/locale/* -type d ! -path '*/en*' ! -path '*/cs*' -print0 | xargs -r0 -- rm -r


## vagrant up
## vagrant ssh
## aptitude clean
## cat /dev/zero > zero.fill;sync;sleep 1;sync;rm -f zero.fill
## exit
## vagrant package

## https://github.com/chef/bento/blob/master/debian/scripts/cleanup.sh

## Save a few more megabytes
#apt-get purge -y locate

## Delete any old dev libraries you likely won't need
#dpkg -l | grep -- '-dev' | xargs apt-get purge -y





## Remove documentation files
#echo -e "Remove documentation files\n"
#find /var/lib/doc -type f | xargs rm -f

## Remove Linux headers
#echo -e "Remove Linux headers\n"
#rm -rf /usr/src/linux-headers*


## Remove bash history
#echo -e "Remove bash history\n"
#unset HISTFILE
#rm -f /root/.bash_history

## Cleanup log files
#echo -e "Cleanup log files\n"
#find /var/log -type f | while read f; do echo -ne '' > $f; done;

## Whiteout root
#echo -e "Whiteout root\n"
#count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`;
#count=$((count -= 1))
#dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count;
#rm /tmp/whitespace;

## Whiteout /boot
#echo -e "Whiteout /boot\n"
#count=`df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}'`;
#count=$((count -= 1))
#dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count;
#rm /boot/whitespace;





## Whiteout swap
#echo -e "Whiteout swap\n"
#swappart=$(cat /proc/swaps | grep -v Filename | tail -n1 | awk -F ' ' '{print $1}')
#if [ "$swappart" != "" ]; then
#  swapoff $swappart;
#  dd if=/dev/zero of=$swappart;
#  mkswap $swappart;
#  swapon $swappart;
#fi

## After swap cleaning, we need to set the proper UUID for swap in /etc/fstab.
## 'sudo blkid' will give you current swap UUID
## Edit /etc/fstab to have proper UUID.





## -----------------------------------------------------------------------------

## for vagrant related tasks, uncomment vagrant comments

# vagrant: Unmount project
#echo -e "vagrant: Unmount project\n"
#umount /vagrant

#aptitude -y purge ri
#aptitude -y purge installation-report landscape-common wireless-tools wpasupplicant ubuntu-serverguide
#aptitude -y purge python-dbus libnl1 python-smartpm python-twisted-core libiw30
#aptitude -y purge python-twisted-bin libdbus-glib-1-2 python-pexpect python-pycurl python-serial python-gobject python-pam python-openssl libffi5
#apt-get purge -y linux-image-3.0.0-12-generic-pae

## vagrant: Remove Virtualbox specific files
#echo -e "vagrant: Remove Virtualbox specific files\n"
#rm -rf /usr/src/vboxguest* /usr/src/virtualbox-ose-guest*

## vagrant: Remove bash history
#echo -e "vagrant: Remove bash history\n"
#rm -f /home/vagrant/.bash_history

