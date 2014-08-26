#!/bin/sh

ETCDCTL_WATCH=/services/gitupdater/notify
if [ ! -z "$1" ] ; then
    ETCDCTL_WATCH=$1
fi

while true ; do
    RESULT=`etcdctl watch ${ETCDCTL_WATCH}`
    
    if [ "${RESULT}" == "updated" ] ; then
	echo "`date +%Y-%m-%d-%H%M%S` - Catched reload action. Reloading..." >> /var/log/container.log
	/root/scripts/update-git-repo.sh
	/sbin/service confd restart
    fi
    # To reduce CPU usage on etcd errors
    sleep 2
done