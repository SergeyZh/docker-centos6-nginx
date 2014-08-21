#!/bin/bash
. /etc/sysconfig/etcdctl
export ETCDCTL_PEERS=${ETCDCTL_PEERS}

# Check: if no GIT repo here - no need to pull it
if [ ! -d /etc/confd/.git ] ; then
    exit 0
fi

CHANGED=0
cd /etc/confd
git pull | grep -q -v 'up-to-date' && CHANGED=1

if [ $CHANGED -eq 1 ]; then
    echo "`date +%Y-%m-%d-%H%M%S` - Git repo was changed" >> /var/log/container.log
    if [ -x "/etc/confd/config-reload.sh" ] ; then
       /etc/confd/config-reload.sh >> /var/log/container.log
    fi
    /sbin/service confd restart

fi
