#!/bin/sh

echo "yum install -y memcached"
yum install -y memcached memcached-devel php-pecl-memcached

echo "chkconfig memcached on"
chkconfig memcached on

# memcached の再起動
echo "/etc/init.d/memcached start"
/etc/init.d/memcached start

# apache(php) の再起動
echo "/etc/init.d/httpd restart"
/etc/init.d/httpd restart
