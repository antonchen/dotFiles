#!/bin/bash
# File: gvim.sh
# Usage:  ./gvim.sh
# Description: Compile Install GVim.
# Version: 0.1
# Create Date: 2016-01-10 14:41
# Modified: 2016-01-10 14:41
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
               Install Latest Vim in Debian
=======================Start===========================
_START_
tput sgr0

tput setaf 1
echo -e "\n*Remove all vim packages.\n\n"
tput sgr0
aptitude remove vim vim-runtime vim-gtk vim-tiny vim-common vim-gui-common

tput setaf 4
echo -e "\n*Installing depend packages.\n"
tput sgr0

# Installing curl wget unzip
install_package wget curl unzip
# Installing gcc python ruby tcl lua.
install_package gcc make ctags libncurses5-dev python-dev python3-dev ruby ruby-dev tcl-dev lua5.2 liblua5.2-dev libperl-dev
# Installing gtk dev
install_package libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev

# Get Vim Latest Version
tput setaf 4
echo -e "*Get Vim Latest Version."
vimVer=`curl -s https://github.com/vim/vim/releases|sed -n "s# *<span class=\"tag-name\">\(v.*\)<\/span>#\1#p"|sort -nr|head -n 1`
echo -e "*Vim Latest Version = $vimVer\n"
tput sgr0
vimSource="https://github.com/vim/vim/archive/${vimVer}.zip"

# Downloading Vim Latest Source
tput setaf 4
echo -e "\n*Downloading Vim Latest Source.\n"
tput sgr0
[[ -d /tmp/gvim/ ]]||mkdir /tmp/gvim
cd /tmp/gvim/
wget -c $vimSource

# Extract
unzip ${vimVer}.zip
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
    tput setaf 1
    echo -e "*Extract ${vimVer}.zip Fail.\n"
    tput sgr0
    exit $RETVAL
fi

# Configure
cd vim*/src
tput setaf 4
echo -e "\n*Configure ...\n"
tput sgr0
# Configure system vimrc file
echo '#define SYS_VIMRC_FILE       "/etc/vim/vimrc"' >>feature.h
# Configure system gvimrc file
echo '#define SYS_GVIMRC_FILE      "/etc/vim/gvimrc"' >>feature.h

./configure \
--prefix=/usr \
--with-features=huge \
--enable-fail-if-missing \
--enable-gui=gtk2 \
--enable-multibyte \
--enable-cscope \
--enable-rubyinterp \
--enable-pythoninterp \
--enable-python3interp \
--enable-perlinterp \
--enable-luainterp \
--enable-tclinterp \
--with-compiledby=Anton
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
    tput setaf 1
    echo -e "\n*Configure Fail.\n"
    tput sgr0
    exit $RETVAL
fi

# Make
tput setaf 4
echo -e "\n*Make ...\n"
tput sgr0
make
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
    tput setaf 1
    echo -e "\n*Make Fail.\n"
    tput sgr0
    exit $RETVAL
fi

# Installing Vim
tput setaf 4
echo -e "\n*Installing ...\n"
tput sgr0
make install
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
    tput setaf 1
    echo -e "\n*Install Fail.\n"
    tput sgr0
    exit $RETVAL
else
    tput setaf 2
    echo -e "\n*Install Vim $vimVer OK.\n"
    rm -f /etc/alternatives/editor
    ln -s /usr/bin/vim /etc/alternatives/editor
    tput sgr0
fi

# Default configuration
tput setaf 4
echo -e "*Add Default configuration.\n"
tput sgr0
cat > /etc/vim/vimrc <<_VIM_
"Default configuration By Anton
set nocompatible
set backspace=indent,eol,start
" <F3> Paste
set pastetoggle=<F3>
syntax on

" Set Tab
set ts=4
set expandtab
_VIM_
cp /etc/vim/vimrc /etc/vim/gvimrc
cat >> /etc/vim/gvimrc <<_GVIM_
" Set GUI
set guioptions-=m
set guioptions-=T
set guioptions-=L
set guioptions-=r
set guioptions-=b
set showtabline=0
_GVIM_

tput setaf 6
cat << _END_
=======================End===========================
               Install Latest Vim in Debian
=======================End===========================
_END_
tput sgr0
