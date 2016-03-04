#!/bin/bash
# File: functions.sh
# Usage:  ./functions.sh
# Description: My Desktop Shell function.
# Version: 0.1
# Create Date: 2016-01-11 13:09
# Modified: 2016-01-11 13:09
# Author: Anton Chen
# Author EMail: contact@antonchen.com

install_package ()
{
    if [ $# -eq 0 ]; then
        tput setaf 1
        echo -e "*Install Package Error,No Package Name."
        tput sgr0
        exit 1
    fi
    package_list=$@
    for package_name in $package_list; do
        apt-get -y install $package_name
        RETVAL=$?
        if [ $RETVAL -eq 0 ]; then
            tput setaf 2
            echo -e "*Install $package_name OK.\n"
            tput sgr0
        else
            tput setaf 1
            echo -e "*Install $package_name Fail.\n"
            tput sgr0
            exit $RETVAL
        fi
    done
}


