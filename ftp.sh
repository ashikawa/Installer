#!/bin/sh

echo 'yum install -y vsftpd'
yum install -y vsftpd
echo 'chkconfig vsftpd on'
chkconfig vsftpd on

echo 'replace /etc/vsftpd/vsftpd.conf'
sed -i -e 's#anonymous_enable=YES#anonymous_enable=NO#g' /etc/vsftpd/vsftpd.conf
sed -i -e 's#\#xferlog_file=/var/log/xferlog#xferlog_file=/var/log/xferlog#g' /etc/vsftpd/vsftpd.conf
sed -i -e 's#\#ls_recurse_enable=YES#ls_recurse_enable=YES#g' /etc/vsftpd/vsftpd.conf

echo 'use_localtime=YES' >> /etc/vsftpd/vsftpd.conf

echo 'vsftpd restart'
/etc/init.d/vsftpd restart
