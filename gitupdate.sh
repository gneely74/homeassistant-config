#!/bin/bash

RSYNC="/usr/bin/rsync -avrz --progress --exclude='.git/'"
MOUNTDIR=/Volumes/config/
git add .
git status
echo -n "Enter the Description for the Change: " [Minor Update]
read CHANGE_MSG
git commit -m "${CHANGE_MSG}"
git push origin master

if [ ! -d $MOUNTDIR ];
    then
        open 'smb://Guest:password@hassio/config'
        sleep 5
        $RSYNC /Users/gneely/Documents/hassio/homeassistant-config/ $MOUNTDIR
        diskutil unmount $MOUNTDIR
    else
        $RSYNC /Users/gneely/Documents/hassio/homeassistant-config/ $MOUNTDIR
        diskutil unmount $MOUNTDIR
fi
    
exit
