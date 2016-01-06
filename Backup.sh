#!/bin/bash
# File: Backup.sh
# Usage:  ./Backup.sh
# Description: 
# Version: 0.1
# Create Date: 2016-01-06 16:09
# Modified: 2016-01-06 16:09
# Author: Anton Chen
# Author EMail: contact@antonchen.com
Backup_Path=~/Working/dotFiles
BAK_Home="$Backup_Path/home/user"
BAK_etc="$Backup_Path/etc"

[[ -d $BAK_Home ]]||mkdir -p $BAK_Home
# zsh
cp -rf ~/.zshrc $BAK_Home

# urxvt xterm
cp -rf ~/.Xdefaults $BAK_Home

# vim
cp -rf ~/.vimrc ~/.vim $BAK_Home

# OpenBox
[[ -d $BAK_Home/.config ]]||mkdir -p $BAK_Home/.config
cp -rf ~/.config/openbox $BAK_Home/.config

# OpenBox Themes
cp -rf ~/.themes $BAK_Home

# tint2
cp -rf ~/.config/tint2 $BAK_Home

# conky
cp -rf ~/.conkyrc $BAK_Home

# GTK
cp -rf ~/.gtkrc-2.0 $BAK_Home
cp -rf ~/.config/gtk-* $BAK_Home/.config

# terminator
cp -rf ~/.config/terminator $BAK_Home/.config

# Wallpaper
cp -rf ~/.Wallpaper $BAK_Home


cd $Backup_Path
[[ -d $Backup_Path/.git ]]||git init&&git remote add origin https://github.com/antonchen/dotFiles.git
git add .
git commit -m "Auto Backup $(date +'%Y-%m-%d %H:%M')"
git push -u origin master
