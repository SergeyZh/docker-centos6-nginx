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
else
    echo "Using default configuration. You should set GITPATH to git repo with confd configuration."
    echo "Use git://github.com/SergeyZh/confd-nginx-default.git as example."
fi

if [ ! -z "${CONFD_PARAMS_BASE64}" ] ; then
    CONFD_PARAMS=`echo ${CONFD_PARAMS_BASE64} | openssl base64 -d`
fi

if [ ! -z "${CONFD_PARAMS}" ] ; then
    echo "other_args=\"${CONFD_PARAMS}\"" > /etc/sysconfig/confd
fi

echo "CONFD_PARAMS=${CONFD_PARAMS}"

trap "/sbin/service crond stop; /sbin/service rsyslog stop; /sbin/service nginx stop; /sbin/service confd stop" SIGINT SIGTERM SIGHUP

touch /var/log/confd /var/log/etcd

/sbin/service rsyslog start
/sbin/service crond start

/sbin/service nginx start
/sbin/service confd start

touch /var/log/container.log
tail -F /var/log/container.log /var/log/confd /var/log/etcd &

wait

