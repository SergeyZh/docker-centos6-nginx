docker-configurator
====================

CentOS6 + confd + etcd + git inside.

The main purpose of this container is to serve & provide configuration files for different applications.
It create configuration files from templates with `etcd` & `confd` from git repository (provided by `GITPATH` parameter).
You could get those configuration files from `/conf/` directory using `--volumes-from=` method.

### List of environment variables

* `GITPATH` path to git repository with /etc/confd configuration
* `CONFD_PARAMS` parameters passed to `confd` daemon. 
* `CONFD_PARAMS_BASE64` parameters passed to `confd` daemon encoded by base64 to avoid quotes.
* `ETCDCTL_PEERS` parameter to tell `etcd` peer address to work with.

### SSH private keys
You may need to access private GIT repository with confd config files. In such case you have put ssh config file and private key to folder `/sshconfig`.
It can be done by the small secure data container on the same docker host and param `--volumes-from=ssh-config-container` for your container.

### Example:

```
 docker run -d -e GITPATH=git://github.com/varsy/configurator-nginx-demo.git \ 
	-e CONFD_PARAMS="-node=172.17.42.1:4001 -interval=300 -prefix=/node-1" \
	-e ETCDCTL_PEERS="172.17.42.1:4001" --volumes-from=ssh-config-container varsy/configurator
```
