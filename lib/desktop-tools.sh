#!/bin/bash
# File: desktop-tools.sh
# Usage:  ./desktop-tools.sh
# Description: 
# Version: 0.1
# Create Date: 2016-01-11 12:33
# Modified: 2016-01-11 12:33
# Author: Anton Chen
# Author EMail: contact@antonchen.com
. `pwd`/`dirname $0`/functions.sh
A_PATH="`pwd`/`dirname $0`"
dotFiles_PATH="$A_PATH/../dotFiles"

tput setaf 6
cat << _START_
=======================Start===========================
               Install Desktop Tools
=======================Start===========================
_START_
tput sgr0

if [ "$VM_TOOLS" == "Yes" ]; then
    # Install VMware Tools
    tput setaf 4
    echo -e "\n*Installing VMware Tools."
    tput sgr0
    install_package open-vm-tools open-vm-tools-desktop
fi

if [ "$ZH_SUPPORT" == "Yes" ]; then
    # Install fonts
    tput setaf 4
    echo -e "\n*Installing fonts."
    tput sgr0
    install_package ttf-wqy-zenhei ttf-wqy-microhei xfonts-wqy
    
    # Install fcitx
    tput setaf 4
    echo -e "\n*Installing Google Pinyin."
    tput sgr0
    install_package fcitx-googlepinyin
fi

# Install Netwrok Manager
tput setaf 4
echo -e "\n*Installing Network Manager."
tput sgr0
install_package network-manager-gnome network-manager-pptp-gnome
# network-manager-openvpn-gnome network-manager-vpnc-gnome
tput setaf 4
echo -e "\n*Setting Network Manager."
tput sgr0
cat > /etc/network/interfaces << _NM_
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback
_NM_
sed -i 's#managed=false#managed=ture#g' /etc/NetworkManager/NetworkManager.conf
systemctl enable NetworkManager.service

# Install ALSA
tput setaf 4
echo -e "\n*Installing ALSA"
tput sgr0
install_package alsa-utils
amixer -c 0 sset 'Master',0 100%,100% unmute
amixer -c 0 sset 'PCM',0 100% unmute

# Install Thunar
tput setaf 4
echo -e "\n*Installing Thunar"
tput sgr0
install_package thunar thunar-dbg thunar-vcs-plugin thunar-volman thunar-archive-plugin thunar-data

# Install GTK Setup Tools
tput setaf 4
echo -e "\n*Installing LXDE Tools"
tput sgr0
install_package lxappearance

# Install Display Settings
install_package lxrandr

# Install GUI sudo
install_package gksu

# Install terminator
tput setaf 4
echo -e "\n*Installing Terminal"
tput sgr0
install_package rxvt-unicode-256color zsh
if [ -d /etc/zsh ];then
cat >> /etc/zsh/zprofile <<_ZP_

PATH="$PATH:$HOME/bin"
export PATH

_src_etc_profile()
{
    # source profile
    if [ -f /etc/profile ]; then
        emulate sh -c 'source /etc/profile'
    fi
}
_src_etc_profile

unset -f _src_etc_profile
_ZP_
fi
# Copy config files
#/bin/cp -rf $dotFiles_PATH/etc/X11/app-defaults/*XTerm /etc/X11/app-defaults/
#/bin/cp -rf $dotFiles_PATH/home/user/.Xdefaults ~$DUSER/

# Install compton
install_package compton

# Install screenfetch
install_package screenfetch

# Install iceweasel
tput setaf 4
echo -e "\n*Installing iceweasel."
tput sgr0
install_package iceweasel iceweasel-l10n-zh-cn

# Install Flash plugin
tput setaf 4
echo -e "\n*Installing Flash plugin."
tput sgr0
install_package flashplugin-nonfree flashplugin-nonfree-extrasound

# Install Xephyr
# tput setaf 4
# echo -e "\n*Installing Xephyr."
# tput sgr0
# install_package xserver-xephyr
# 
# echo

tput setaf 6
cat << _END_
=======================End===========================
               Install Desktop Tools
=======================End===========================
_END_
tput sgr0
