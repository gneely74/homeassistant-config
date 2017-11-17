#!/bin/bash

RSYNC="/usr/bin/rsync -avrz --progress --exclude='.git/'"
MOUNTDIR=/Volumes/config/
git add .
git status
if [[ `git status --porcelain` ]]; then
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
    ssh -o StrictHostKeyChecking=no root@hassio.local hassio homeassistant restart   
else
  echo ""
fi
 
exit
