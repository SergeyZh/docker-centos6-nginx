#!/bin/sh

if [ -x "/etc/confd/config-reload.sh" ] ; then
    /etc/confd/config-reload.sh
fi

set | grep -E "ETCDCTL_PEERS" > /etc/sysconfig/etcdctl

if [ ! -z "${CONFD_PARAMS_BASE64}" ] ; then
    CONFD_PARAMS=`echo ${CONFD_PARAMS_BASE64} | openssl base64 -d`
fi

if [ ! -z "${CONFD_PARAMS}" ] ; then
    echo "other_args=\"${CONFD_PARAMS}\"" > /etc/sysconfig/confd
fi

if [ ! -z "${ETCDCTL_PEERS}" ] ; then
   echo "export ETCDCTL_PEERS=\"${ETCDCTL_PEERS}\"" >> /etc/sysconfig/confd
fi

echo "CONFD_PARAMS=${CONFD_PARAMS}"

trap "/sbin/service etcd stop; /sbin/service confd stop; killall reloader.sh; killall etcdctl; killall tail; exit 0" SIGINT SIGTERM SIGHUP

touch /var/log/confd /var/log/etcd

sleep 3
/sbin/service confd start

if [ ! -z "${ETCDCTL_PEERS}" ] ; then
    export ETCDCTL_PEERS
    /reloader.sh ${ETCDCTL_WATCH} &
fi

touch /var/log/container.log
tail -F /var/log/container.log /var/log/confd /var/log/etcd &

wait

