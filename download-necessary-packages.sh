#!/bin/sh

docker run -i -t --rm -v `pwd`/rpms:/rpms sergeyzh/centos6-epel /bin/bash -c "yum install -y yum-utils; cd /rpms; bash"

wget https://github.com/coreos/etcd/releases/download/v0.4.5/etcd-v0.4.5-linux-amd64.tar.gz

