#!/bin/bash

RSYNC="/usr/bin/rsync -avrz --progress --delete"
MOUNTDIR=/Volumes/config
git add .
git status
echo -n "Enter the Description for the Change: " [Minor Update]
read CHANGE_MSG
git commit -m "${CHANGE_MSG}"
git push origin master

if [ ! -d $MOUNTDIR ];
    then
        open 'smb://Guest:password@hassio/config'
        $RSYNC /Users/gneely/Documents/hassio/homeassistant-config/ /Volumes/config/
        diskutil unmount /Volumes/config
    else
        $RSYNC /Users/gneely/Documents/hassio/homeassistant-config/ /Volumes/config/
        diskutil unmount /Volumes/config
fi
    
exit
