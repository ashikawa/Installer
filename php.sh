#!/bin/sh

echo "yum install -y php php-devel php-mbstring php-pear php-xml php-mysql php-pgsql"
yum install -y php php-devel php-mbstring php-pear php-xml php-mysql php-pgsql php-pecl-apc

echo "/etc/init.d/httpd restart"
/etc/init.d/httpd restart
