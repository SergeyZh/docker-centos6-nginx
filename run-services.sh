#!/bin/sh

. /functions.sh

reload_nginx_config

trap "/sbin/service nginx stop; killall reloader.sh; killall etcdctl; killall tail; exit 0" SIGINT SIGTERM SIGHUP

/sbin/service nginx start

touch /var/log/container.log
tail -F /var/log/container.log &

if [ ! -z "${ETCDCTL_PEERS}" ] ; then
    export ETCDCTL_PEERS
    /reloader.sh ${ETCDCTL_WATCH} &
fi


wait

