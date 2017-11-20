#!/bin/bash

git add .
git status
if [[ `git status --porcelain` ]]; then
    echo -n "Enter the Description for the Change: " [Minor Update]
    read CHANGE_MSG
    git commit -m "${CHANGE_MSG}"
    git push origin master
    /usr/bin/rsync -avrz --progress --exclude='.git/' -e 'ssh -p 9922 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null' /Users/gneely/Documents/hassio/homeassistant-config/ root@home.theneelyfamily.net:/config/
    ssh -p 9922 -o StrictHostKeyChecking=no root@home.theneelyfamily.net hassio homeassistant restart  
else
  echo ""
fi
 
exit
