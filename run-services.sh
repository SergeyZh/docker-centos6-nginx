#!/bin/sh

. /functions.sh

reload_nginx_config

trap "/sbin/service nginx stop; killall reloader.sh; killall etcdctl; killall tail; exit 0" SIGINT SIGTERM SIGHUP

/sbin/service nginx start

touch /var/log/container.log
tail -F /var/log/container.log &

ETCDCTL_NOTIFY=${ETCDCTL_NOTIFY:-"/services/nginx/notify"}

if [ ! -z "${ETCDCTL_PEERS}" ] ; then
    export ETCDCTL_PEERS
    export ETCDCTL_NOTIFY
    /reloader.sh ${ETCDCTL_WATCH} &
fi


wait

