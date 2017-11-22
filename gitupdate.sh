#!/bin/bash

git add .
git status
if [[ `git status --porcelain` ]]; then
    echo -n "Enter the Description for the Change: " [Minor Update]
    read CHANGE_MSG
    git commit -m "${CHANGE_MSG}"
    git push origin master
    ssh -p 9922 -o StrictHostKeyChecking=no root@home.theneelyfamily.net /etc/periodic/15min/git_pull.sh  
else
  echo ""
fi
exit
