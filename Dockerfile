FROM sergeyzh/centos6-epel

MAINTAINER Sergey Zhukov, sergey@jetbrains.com

ADD rpms/ /root/rpms/
RUN rpm --rebuilddb ; yum localinstall -y /root/rpms/*.rpm ; yum -y update openssl

RUN yum install -y nginx-1.10.1
ADD etcd-v0.4.5-linux-amd64.tar.gz /
RUN cd /etcd-v0.4.5-linux-amd64 ; mv etcdctl /usr/bin/ ; rm -rf /etcd-v0.4.5-linux-amd64

ADD reloader.sh /
RUN chmod a+x /reloader.sh

ADD functions.sh /

ADD run-services.sh /
RUN chmod +x /run-services.sh ; mkdir -p /conf/nginx

# Change config paths to relative
RUN sed -i 's|/etc/nginx/||g' /etc/nginx/nginx.conf

CMD /run-services.sh

EXPOSE 80 443
