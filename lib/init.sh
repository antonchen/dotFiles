#!/bin/bash
# File: init.sh
# Usage:  ./init.sh
# Description: 
# Version: 0.1
# Create Date: 2016-01-10 17:34
# Modified: 2016-01-10 17:34
# Author: Anton Chen
# Author EMail: contact@antonchen.com
. `pwd`/`dirname $0`/functions.sh

if [ `id -u` -ne 0 ]; then
    tput setaf 1
    echo -e "*You must be root to run this script.\n"
    tput sgr0
    exit 1
fi

tput setaf 6
cat << _START_
=======================Start===========================
                  System initialization
=======================Start===========================
_START_
tput sgr0

# Basic setting
dpkg-reconfigure console-setup
dpkg-reconfigure tzdata
dpkg-reconfigure locales

# Setting console locales
tput setaf 4
echo -e "\n*Setting console locales.\n"
tput sgr0
cat >> /etc/profile <<_LANG_
if [ "\$TERM" = "linux" ]; then
  export LANG="en_US.UTF-8"
  export LANGUAGE=en_US:en
fi
_LANG_

# Setting apt sources
tput setaf 4
echo -e "*Setting apt sources.\n"
tput sgr0
cat > /etc/apt/sources.list <<_APT_

# deb cdrom:[Debian GNU/Linux 8.2.0 _Jessie_ - Official amd64 CD Binary-1 20150906-11:13]/ jessie main

deb http://mirrors.ustc.edu.cn/debian jessie main contrib non-free
deb-src http://mirrors.ustc.edu.cn/debian jessie main contrib non-free

deb http://mirrors.ustc.edu.cn/debian jessie-proposed-updates main contrib non-free
deb-src http://mirrors.ustc.edu.cn/debian jessie-proposed-updates main contrib non-free

deb http://mirrors.ustc.edu.cn/debian jessie-updates main contrib non-free
deb-src http://mirrors.ustc.edu.cn/debian jessie-updates main contrib non-free
_APT_
apt-get update

# Install aptitude
tput setaf 4
echo -e "\n*Installing Tools.\n"
tput sgr0
install_package aptitude

# Install Tools
install_package lrzsz unzip git sudo gawk htop tree

# Setting SSHD
tput setaf 4
echo -e "*Setting SSH Server.\n"
tput sgr0
cat /dev/null >/etc/motd
echo 'UseDNS no' >>/etc/ssh/sshd_config
sed -i '/PermitRootLogin/d' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
sed -i 's#GSSAPIAuthentication yes#GSSAPIAuthentication no#g' /etc/ssh/sshd_config
systemctl restart sshd

# Setting display resolution
tput setaf 4
echo -e "*Setting display resolution.\n"
tput sgr0
sed -i "/'Debian GNU\/Linux'/a \\\tgfxpayload='1440x900'" /boot/grub/grub.cfg

tput setaf 6
cat << _END_
=======================End===========================
                  System initialization
=======================End===========================
_END_
tput sgr0
