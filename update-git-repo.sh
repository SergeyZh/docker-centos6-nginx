#!/bin/bash

if [ -z "${GITPATH}" ] ; then
    exit 0
fi

CHANGED=0
cd /etc/confd
git pull | grep -q -v 'up-to-date' && CHANGED=1

if [ $CHANGED -eq 1 ]; then
    echo "Git repo was changed" >> /var/log/container.log
    /sbin/service confd restart
fi
