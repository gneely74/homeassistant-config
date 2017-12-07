#!/bin/bash
dir="/config"
lock=/tmp/update.lock
msglog="/var/log/update.log"

log()
{
        echo "$(date) ${1:-missing}" >> $msglog
}

git config --global user.email "grady.neely@icloud.com"

if [ -f $lock ]; then
        log "Already run, exiting..."
else
        > $lock
        git -C $dir remote update &> /dev/null
        checkgit=`git -C $dir status`
        if [[ ! "$checkgit" =~ "Your branch is up-to-date" ]]; then
                cd $dir
                log "-------------- Update ---------------"
                git stash &>> $msglog
                git -C $dir pull &>> $msglog
                git stash clear
                log "-------------------------------------"
                /usr/bin/hassio homeassistant restart
        fi
        rm $lock

fi
exit 0
