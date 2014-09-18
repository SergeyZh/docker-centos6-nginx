#!/bin/sh

ETCDCTL_WATCH=/services/gitupdater/notify
if [ ! -z "$1" ] ; then
    ETCDCTL_WATCH=$1
fi

while true ; do
    # Check for missed update
    RESULT=`etcdctl get ${ETCDCTL_WATCH}`

    if [ "${RESULT}" != "updated" ] ; then
        RESULT=`etcdctl watch ${ETCDCTL_WATCH}`
    fi

    if [ "${RESULT}" == "updated" ] ; then
	etcdctl set ${ETCDCTL_WATCH} empty
	echo "`date +%Y-%m-%d-%H%M%S` - Catched reload action. Reloading..." >> /var/log/container.log
	if [ -x "/etc/confd/config-reload.sh" ] ; then
	    /etc/confd/config-reload.sh >> /var/log/container.log
	fi

	/sbin/service confd restart
    fi
    # To reduce CPU usage on etcd errors
    sleep 2
done