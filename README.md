docker-centos6-nginx
====================

CentOS6 + Nginx 1.7.0 + configurator support


### List of environment variables

* `ETCDCTL_PEERS` - address of etcd service to watch reload signal. Optional.
* `ETCDCTL_WATCH` - path inside etcd to watch reload signal. Optional.
* `ETCDCTL_NOTIFY` - path inside etcd to notify about state of reload [reloaded, error]. Optional.

### Example:

```
 docker run -d -e -e ETCDCTL_PEERS="172.17.42.1:4001" \
	-e ETCDCTL_WATCH=/services/nginx/reload \
	-e ETCDCTL_NOTIFY=/services/nginx/notify \
	--volumes-from=configurator sergeyzh/centos6-nginx
```
