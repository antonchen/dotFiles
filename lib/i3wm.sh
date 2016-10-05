#!/bin/bash
# File: i3wm.sh
# Usage:  ./i3wm.sh
# Description: 
# Version: 0.1
# Create Date: 2016-03-09 14:25
# Modified: 2016-03-09 14:25
# Author: Anton Chen
# Author EMail: contact@antonchen.com
. `pwd`/`dirname $0`/functions.sh
A_PATH="`pwd`/`dirname $0`"
dotFiles_PATH="$A_PATH/../dotFiles"

tput setaf 6
cat << _START_
=======================Start===========================
               Install Xorg and i3wm
=======================Start===========================
_START_
tput sgr0

tput setaf 4
echo -e "\n*Installing Xorg."
tput sgr0
install_package xserver-xorg xserver-xorg-input-evdev xserver-xorg-input-kbd

tput setaf 4
echo -e "\n*Installing i3wm."
tput sgr0
install_package i3 conky feh

tput setaf 4
echo -e "\n*Installing DM."
tput sgr0
install_package slim

tput setaf 6
cat << _END_
=======================End===========================
               Install Xorg and i3wm
=======================End===========================
_END_
tput sgr0
