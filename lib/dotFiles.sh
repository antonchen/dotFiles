#!/bin/bash
# File: dotFiles.sh
# Usage:  ./dotFiles.sh
# Description: 
# Version: 0.1
# Create Date: 2016-01-16 15:24
# Modified: 2016-01-16 15:24
# Author: Anton Chen
# Author EMail: contact@antonchen.com
A_PATH="`pwd`/`dirname $0`"
dotFiles_PATH="$A_PATH/../dotFiles"

if [ -z $DUSER ]; then
    DUSER=`logname`
fi

tput setaf 4
echo -e "Copy dotFiles to $DUSER home"
tput sgr0
if [ -f $dotFiles_PATH/home/user/config/i3/conkyrc ]; then
    NICName=`ip a|grep '2:'|awk -F ":| " '{print $3}'`
    sed -i "s#eno16777736#$NICName#g" $dotFiles_PATH/home/user/config/i3/conkyrc
fi
for name in `ls $dotFiles_PATH/home/user/`; do
    cp -rf $dotFiles_PATH/home/user/$name /home/$DUSER/.${name}
done
chown -R $DUSER.$DUSER /home/$DUSER

if [ -f /home/$DUSER/.config/i3/conky-i3bar ]; then
    chmod +x /home/$DUSER/.config/i3/conky-i3bar
fi

if [ -d /usr/share/fonts/truetype ]; then
    cp -rf $dotFiles_PATH/fonts/* /usr/share/fonts/truetype/
else
    mkdir -p /usr/share/fonts/truetype
    cp -rf $dotFiles_PATH/fonts/* /usr/share/fonts/truetype/
fi

if [ -d /usr/share/slim/themes ]; then
    cp -rf $dotFiles_PATH/themes/Anton /usr/share/slim/themes/
else
    mkdir -p /usr/share/slim/themes
    cp -rf $dotFiles_PATH/themes/Anton /usr/share/slim/themes/
fi
cp -rf $dotFiles_PATH/etc/slim.conf /etc/

chsh $DUSER -s /usr/bin/zsh

wget -P /tmp/ http://files.byclouds.org/shell/deb/arc-theme_all.deb
wget -P /tmp/ http://files.byclouds.org/shell/deb/vibrancy-colors_2.6_all.deb

dpkg -i /tmp/vibrancy-colors_2.6_all.deb
dpkg -i /tmp/arc-theme_all.deb
apt-get -y -f install

# Add Sudoers
sed -i "/^root/a\\$DUSER\tALL=(ALL:ALL) ALL\n$DUSER\tALL=(ALL:ALL) NOPASSWD: /bin/systemctl" /etc/sudoers

# Oh My Vim
runuser - $DUSER -c 'git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim'
runuser - $DUSER -c 'vim +PluginInstall +qall'

if [ "$SKEL" == "Yes" ]; then
    tput setaf 4
    echo -e "Copy $DUSER dotFiles to SKEL"
    tput sgr0

    cp -rf $dotFiles_PATH/etc/X11/app-defaults/URxvt /etc/X11/app-defaults/URxvt
    for name in `ls $dotFiles_PATH/home/user/`; do
        cp -rf $dotFiles_PATH/home/user/$name /etc/skel/.${name}
    done
fi
