#!/bin/sh

. /functions.sh

ETCDCTL_WATCH=/services/phpfpm/reload
if [ ! -z "$1" ] ; then
    ETCDCTL_WATCH=$1
fi

while true ; do
    RESULT=`etcdctl watch ${ETCDCTL_WATCH}`
    
    if [ "${RESULT}" == "reload" ] ; then
	echo "Catched reload action. Reloading..."
	reload_nginx_config
    fi
    # To reduce CPU usage on etcd errors
    sleep 2
done