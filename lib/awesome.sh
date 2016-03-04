#!/bin/bash
# File: awesome.sh
# Usage:  ./awesome.sh
# Description: Install Sid Latest Awesome in Debian.
# Version: 0.1
# Create Date: 2016-01-10 14:34
# Modified: 2016-01-10 14:34
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
               Install Awesome in Debian
=======================Start===========================
_START_
tput sgr0

tput setaf 4
echo -e "\n*Installing base desktop.\n"
tput sgr0
install_package xorg slim
install_package curl wget

# Get Awesome Deb Packages Version & URL
tput setaf 4
echo -e "\n*Get Awesome Deb Packages Version.\n"
sourcesMain=`grep "deb \(.*\/\/.*\).*main" /etc/apt/sources.list|grep -v "\-.* main"|awk '{print $2}'`
AwesomeVer=`curl -s $sourcesMain/pool/main/a/awesome/|sed -n "s#.*deb\">awesome_\(.*\)_amd64.deb.*#\1#p"|sort -nr|head -n 1`
echo -e "*Latest Awesome Deb Packages Version = $AwesomeVer\n"
AwesomeDeb_x32="$sourcesMain/pool/main/a/awesome/awesome_${AwesomeVer}_i386.deb"
AwesomeDeb_x64="$sourcesMain/pool/main/a/awesome/awesome_${AwesomeVer}_amd64.deb"
echo -e "*Downloading Awesome Deb Packages\n"
tput sgr0

# Install Latest Awesome Deb Packages
MACHINE_TYPE=`uname -m`
if [ "$MACHINE_TYPE" == "x86_64" ]; then
    wget -c $AwesomeDeb_x64
    tput setaf 4
    echo -e "*Installing Awesome WM x64\n"
    tput sgr0
    dpkg -i awesome_${AwesomeVer}_amd64.deb
    tput setaf 4
    echo -e "\n*Installing depend packages.\n"
    tput sgr0
    apt-get -fy install
else
    wget -c $AwesomeDeb_x32
    tput setaf 4
    echo -e "*Installing Awesome WM x32\n"
    tput sgr0
    dpkg -i awesome_${AwesomeVer}_i386.deb
    tput setaf 4
    echo -e "\n*Installing depend packages.\n"
    tput sgr0
    apt-get -fy install
fi

tput setaf 6
cat << _END_
=======================End===========================
               Install Awesome in Debian
=======================End===========================
_END_
tput sgr0
