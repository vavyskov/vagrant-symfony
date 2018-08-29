#!/bin/bash

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

## Remove APT cache
echo -e "Remove APT cache\n"
apt-get clean -y
apt-get autoclean -y

## Zero free space to aid VM compression
echo -e "Zero free space to aid VM compression\n"
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

## Remove APT files
echo -e "Zero free space to aid VM compression\n"
find /var/lib/apt -type f | xargs rm -f

## Remove documentation files
echo -e "Remove documentation files\n"
find /var/lib/doc -type f | xargs rm -f

## vagrant: Remove Virtualbox specific files
#echo -e "vagrant: Remove Virtualbox specific files\n"
#rm -rf /usr/src/vboxguest* /usr/src/virtualbox-ose-guest*

## Remove Linux headers
echo -e "Remove Linux headers\n"
rm -rf /usr/src/linux-headers*

## Remove Unused locales (edit for your needs, this keeps only en*, pt_BR adn cs)
echo -e "Remove Unused locales (edit for your needs, this keeps only en* and pt_BR)
find\n"
find /usr/share/locale/{af,am,ar,as,ast,az,bal,be,bg,bn,bn_IN,br,bs,byn,ca,cr,csb,cy,da,de,de_AT,dz,el,en_AU,en_CA,eo,es,et,et_EE,eu,fa,fi,fo,fr,fur,ga,gez,gl,gu,haw,he,hi,hr,hu,hy,id,is,it,ja,ka,kk,km,kn,ko,kok,ku,ky,lg,lt,lv,mg,mi,mk,ml,mn,mr,ms,mt,nb,ne,nl,nn,no,nso,oc,or,pa,pl,ps,qu,ro,ru,rw,si,sk,sl,so,sq,sr,sr*latin,sv,sw,ta,te,th,ti,tig,tk,tl,tr,tt,ur,urd,ve,vi,wa,wal,wo,xh,zh,zh_HK,zh_CN,zh_TW,zu} -type d -delete

## Remove bash history
echo -e "Remove bash history\n"
unset HISTFILE
rm -f /root/.bash_history

## vagrant: Remove bash history
#echo -e "vagrant: Remove bash history\n"
#rm -f /home/vagrant/.bash_history

## Cleanup log files
echo -e "Cleanup log files\n"
find /var/log -type f | while read f; do echo -ne '' > $f; done;

## Cleanup tmp folder
## -A = list everything except . and ..
## -1 = put every item in one line
echo -e "Cleanup tmp folder\n"
cd /tmp | ls -A1 | xargs rm -rf
#rm -rf /tmp/*
#rm -rf /tmp/.* 2> /dev/null

## Whiteout root
echo -e "Whiteout root\n"
count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`;
count=$((count -= 1))
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count;
rm /tmp/whitespace;

## Whiteout /boot
echo -e "Whiteout /boot\n"
count=`df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}'`;
count=$((count -= 1))
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count;
rm /boot/whitespace;

## Whiteout swap
echo -e "Whiteout swap\n"
swappart=$(cat /proc/swaps | grep -v Filename | tail -n1 | awk -F ' ' '{print $1}')
if [ "$swappart" != "" ]; then
  swapoff $swappart;
  dd if=/dev/zero of=$swappart;
  mkswap $swappart;
  swapon $swappart;
fi

## After swap cleaning, we need to set the proper UUID for swap in /etc/fstab.
## 'sudo blkid' will give you current swap UUID
## Edit /etc/fstab to have proper UUID.