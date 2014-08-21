FROM sergeyzh/centos6-epel

MAINTAINER Sergey Zhukov, sergey@jetbrains.com; Andrey Sizov, andrey.sizov@jetbrains.com

RUN mkdir -p /conf/nginx/conf.d

VOLUME ["/conf/"]

RUN cp -f /usr/share/zoneinfo/Europe/Moscow /etc/localtime

#ADD rpms/ /root/rpms/
#RUN yum localinstall -y /root/rpms/*.rpm
RUN yum install -y git cronie

ADD crontab.root /root/
RUN sed -i "/pam_loginuid.so/ s/\(.*\)/#\1/" /etc/pam.d/crond
RUN crontab -uroot /root/crontab.root

ADD update-git-repo.sh /root/scripts/

RUN ln -s /sshconfig /root/.ssh

ADD etcd-v0.4.5-linux-amd64.tar.gz /
RUN cd /etcd-v0.4.5-linux-amd64 ; mv etcdctl /usr/bin/ ; mv etcd /usr/sbin/ ; rm -rf /etcd-v0.4.5-linux-amd64

ADD confd-0.5.0-linux-amd64 /usr/sbin/confd
RUN chmod +x /usr/sbin/confd

ADD confd /etc/confd/
ADD init.d /etc/rc.d/init.d/

ADD reloader.sh /
RUN chmod a+x /reloader.sh

ADD run-services.sh /
RUN chmod +x /run-services.sh

CMD /run-services.sh