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
cp -rf $dotFiles_PATH/home/user/.* /home/$DUSER/
chown -R $DUSER.$DUSER /home/$DUSER

if [ "$SKEL" == "Yes" ]; then
    tput setaf 4
    echo -e "Copy dotFiles to $DUSER SKEL"
    tput sgr0
    cp -rf $dotFiles_PATH/home/user/.* /etc/skel/
fi
