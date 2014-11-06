#!/bin/sh

. /functions.sh

ETCDCTL_WATCH=/services/nginx/reload
if [ ! -z "$1" ] ; then
    ETCDCTL_WATCH=$1
fi

while true ; do
    # Check for missed update
    RESULT=`etcdctl get ${ETCDCTL_WATCH}`

    if [ "${RESULT}" != "reload" ] ; then
        RESULT=`etcdctl watch ${ETCDCTL_WATCH}`
    fi

    if [ "${RESULT}" == "reload" ] ; then
        etcdctl set ${ETCDCTL_WATCH} empty
	echo "`date +%Y-%m-%d-%H%M%S` - Catched reload action. Reloading..."  >> /var/log/container.log
	reload_nginx_config
    fi
    # To reduce CPU usage on etcd errors
    sleep 2
done