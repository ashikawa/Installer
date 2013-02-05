#!/bin/sh

echo "install -y php php-devel php-mbstring php-pear php-xml php-mysql php-pgsql php-pecl-apc"
yum install -y php php-devel php-mbstring php-pear php-xml php-mysql php-pgsql php-pecl-apc

sed -i -e 's#memory_limit = .*M#memory_limit = 512M#g' /etc/php.ini
sed -i -e 's#;date.timezone =#date.timezone = "Asia/Tokyo"#g' /etc/php.ini

echo "/etc/init.d/httpd restart"
/etc/init.d/httpd restart
