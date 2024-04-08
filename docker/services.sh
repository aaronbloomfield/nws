#!/bin/sh
#Start up script for metasploitable2 docker/gns3 image tleemcjr/metasploitable2

service apache2 start > /dev/null 2>&1
service atd start > /dev/null 2>&1
#service bind9 start
service cron start > /dev/null 2>&1
service distcc start > /dev/null 2>&1
#service klogd start
service mysql start > /dev/null 2>&1
service mysql-ndb start > /dev/null 2>&1
service mysql-ndb-mgm start > /dev/null 2>&1
service networking start > /dev/null 2>&1
#service nfs-common start
#service nfs-kernel-server start
service openbsd-inetd start > /dev/null 2>&1
service portmap start > /dev/null 2>&1
service postfix start > /dev/null 2>&1
service postgresql-8.3 start > /dev/null 2>&1
service proftpd start > /dev/null 2>&1
service rmnologin start > /dev/null 2>&1
service rsync start > /dev/null 2>&1
service samba start > /dev/null 2>&1
service snmpd start > /dev/null 2>&1
service ssh start > /dev/null 2>&1
service sysklogd start > /dev/null 2>&1
service tomcat5.5 start > /dev/null 2>&1
service xinetd start > /dev/null 2>&1
service x11-common start > /dev/null 2>&1
service xserver-xorg-input-wacom start > /dev/null 2>&1

/etc/init.d/rc.local start > /dev/null 2>&1
