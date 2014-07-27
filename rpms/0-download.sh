# http://nginx.org/packages/mainline/centos/6/x86_64/RPMS/
wget -c http://nginx.org/packages/mainline/centos/6/x86_64/RPMS/nginx-1.7.0-1.el6.ngx.x86_64.rpm

# crontab
yumdownloader yum-cron crontabs cronie.x86_64 cronie-anacron.x86_64 cyrus-sasl.x86_64 logrotate.x86_64 mysql-libs.x86_64 postfix.x86_64 rsyslog.x86_64 yum-plugin-downloadonly.noarch

#git
yumdownloader git fipscheck.x86_64 fipscheck-lib.x86_64 libedit.x86_64 openssh.x86_64  openssh-clients.x86_64  perl-Error.noarch  perl-Git.noarch rsync.x86_64 

#golang
yumdownloader --resolve golang
