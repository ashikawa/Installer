#!/bin/sh

echo "yum install -y httpd"
yum install -y httpd

echo "chkconfig httpd on"
chkconfig httpd on

echo "/etc/init.d/httpd start"
/etc/init.d/httpd start
