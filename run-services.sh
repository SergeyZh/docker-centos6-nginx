#!/bin/sh

if [ ! -z "${GITPATH}" ] ; then
    rm -rf /etc/confd/
    echo "Cloning ${GITPATH} repo"
    RETVAL=-1
    while [ ${RETVAL} -ne 0 ]; do
	git clone ${GITPATH} /etc/confd
	let RETVAL=$?
	sleep 5
    done
    if [ -x "/etc/confd/config-reload.sh" ] ; then
	/etc/confd/config-reload.sh
    fi
else
    echo "Using default configuration. You should set GITPATH to git repo with confd configuration."
    echo "Use git://github.com/varsy/configurator-nginx-demo.git as example."
fi

if [ ! -z "${CONFD_PARAMS_BASE64}" ] ; then
    CONFD_PARAMS=`echo ${CONFD_PARAMS_BASE64} | openssl base64 -d`
fi

if [ ! -z "${CONFD_PARAMS}" ] ; then
    echo "other_args=\"${CONFD_PARAMS}\"" > /etc/sysconfig/confd
fi

echo "CONFD_PARAMS=${CONFD_PARAMS}"

trap "/etc/init.d/crond stop; /etc/init.d/etcd stop; /etc/init.d/confd stop; killall tail; exit 0" SIGINT SIGTERM SIGHUP

touch /var/log/confd /var/log/etcd

/etc/init.d/crond start
/etc/init.d/confd start

touch /var/log/container.log
tail -F /var/log/container.log /var/log/confd /var/log/etcd &

wait

