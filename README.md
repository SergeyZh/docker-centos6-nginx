docker-configurator
====================

CentOS6 + confd + etcd inside.

The main purpose of this container is to serve & provide configuration files for different applications.
It create configuration files from templates with `etcd` & `confd` from `/etc/confd/` folder (could be provided by [`varsy/git-updater`](https://registry.hub.docker.com/u/varsy/git-updater/)).
You could get those configuration files from `/conf/` directory using `--volumes-from=` method.

### List of environment variables

* `CONFD_PARAMS` parameters passed to `confd` daemon. 
* `CONFD_PARAMS_BASE64` parameters passed to `confd` daemon encoded by base64 to avoid quotes.
* `ETCDCTL_PEERS` parameter to tell `etcd` peer address to work with.
* `ETCDCTL_WATCH` path inside etcd to watch update signal. Optional, refer to [`varsy/git-updater`](https://registry.hub.docker.com/u/varsy/git-updater/) Default: `/services/gitupdater/notify` 

### Example:

```
 docker run -d -e GITPATH=git://github.com/varsy/configurator-nginx-demo.git \ 
	-e CONFD_PARAMS="-node=172.17.42.1:4001 -interval=300 -prefix=/node-1" \
	-e ETCDCTL_PEERS="172.17.42.1:4001" --volumes-from=ssh-config-container varsy/configurator
```
