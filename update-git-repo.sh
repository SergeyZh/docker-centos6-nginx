#!/bin/bash

# Check: if no GIT repo here - no need to pull it
if [ ! -d /etc/confd/.git ] ; then
    exit 0
fi

CHANGED=0
cd /etc/confd
git pull | grep -q -v 'up-to-date' && CHANGED=1

if [ $CHANGED -eq 1 ]; then
    echo "Git repo was changed" >> /var/log/container.log
    /sbin/service confd restart
fi
