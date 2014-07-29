docker-centos6-nginx
====================

CentOS6 + Nginx 1.7.0 + confd + etcd


### List of environment variables

* `GITPATH` path to git repository with /etc/confd configuration
* `CONFD_PARAMS` parameters passed to `confd` daemon. 
* `CONFD_PARAMS_BASE64` parameters passed to `confd` daemon encoded by base64 to avoid quotes.

### SSH private keys
You may need to access private GIT repository with confd config files. In such case you have put ssh config file and private key to folder `/sshconfig`.
It can be done by the small secure data container on the same docker host and param `--volumes-from=ssh-config-container` for Nginx container.

### Example:

```
 docker run -d -e GITPATH=git://github.com/SergeyZh/confd-nginx-default.git \ 
	-e CONFD_PARAMS="-node=172.17.42.1:4001 -interval=300 -prefix=/node-1" \
	--volumes-from=ssh-config-container sergeyzh/centos6-nginx
```
