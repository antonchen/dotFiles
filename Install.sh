#!/bin/bash
# File: packages.sh
# Usage:  ./packages.sh
# Description: 
# Version: 0.1
# Create Date: 2016-01-10 14:27
# Modified: 2016-01-10 14:27
# Author: Anton Chen
# Author EMail: contact@antonchen.com

tput setaf 4
echo -e "\n*Installing Awesome in Debian\n"
tput sgr0

# Read DUSER
while true
do
    read -p "Please enter your desktop user(Default: `logname`):" read_user

    if [ -z $read_user ]; then
        read_user=`logname`
        break
    else
        id $read_user &>/dev/null
        if [ $? -ne 0 ]; then
            echo -e "\n\033[31m User does not exist,Please re-enter \033[0m\n"
            continue
        fi
        break
    fi
done
export DUSER=$read_user

# Read SKEL
while true
do
    read -p "Configure whether to add a new user(Yes/no):" add_skel
    if [ -z $add_skel ]; then
        add_skel="Yes"
    fi
	case "$add_skel" in
	y|Y|yes|Yes|YES)
	    add_skel="Yes"
	    break
	;;
	n|N|no|No|NO)
	    add_skel="No"
	    break
	;;
	*)
	    echo -e "\n\033[31m Input Error,Please re-enter \033[0m\n"
	    add_skel="Yes"
	    continue
	;;
	esac
done
export SKEL=$add_skel

while true
do
    read -p "Install open-vm-tools(Yes/no):" read_vm_tools
    if [ -z $read_vm_tools ]; then
        read_vm_tools="Yes"
    fi
	case "$read_vm_tools" in
	y|Y|yes|Yes|YES)
	    read_vm_tools="Yes"
	    break
	;;
	n|N|no|No|NO)
	    read_vm_tools="No"
	    break
	;;
	*)
	    echo -e "\n\033[31m Input Error,Please re-enter \033[0m\n"
	    read_vm_tools="Yes"
	    continue
	;;
	esac
done
export VM_TOOLS=$read_vm_tools

# Read Chinese support
while true
do
    read -p "Installation of Chinese support(Yes/no):" read_zh_support
    if [ -z $read_zh_support ]; then
        read_zh_support="Yes"
    fi
	case "$read_zh_support" in
	y|Y|yes|Yes|YES)
	    read_zh_support="Yes"
	    break
	;;
	n|N|no|No|NO)
	    read_zh_support="No"
	    break
	;;
	*)
	    echo -e "\n\033[31m Input Error,Please re-enter \033[0m\n"
	    read_zh_support="Yes"
	    continue
	;;
	esac
done
export ZH_SUPPORT=$read_zh_support

# System initialization
bash lib/init.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Install GVim
bash lib/gvim.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Install Awesome
bash lib/awesome.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Install Desktop Tools
bash lib/desktop-tools.sh
if [ $? -ne 0 ]; then
    exit $?
fi

# Copy dotFiles
bash lib/dotFiles.sh
if [ $? -ne 0 ]; then
    exit $?
fi
