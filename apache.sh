#!/bin/sh

echo "yum install -y httpd"
yum install -y httpd

echo "chkconfig httpd on"
chkconfig httpd on


# 不要な設定のコメントアウト
echo "comment out default Aliases"
sed -i -e 's#Alias /icons/ "/var/www/icons/"#\#Alias /icons/ "/var/www/icons/"#g' /etc/httpd/conf/httpd.conf
sed -i -e 's#ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"#\#ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"#g' /etc/httpd/conf/httpd.conf
sed -i -e 's#Alias /error/ "/var/www/error/"#\#Alias /error/ "/var/www/error/"#g' /etc/httpd/conf/httpd.conf

# その他設定の追加
echo "add TraceEnable Off"
echo "TraceEnable Off" >> /etc/httpd/conf/httpd.conf

# Apache の再起動
echo "/etc/init.d/httpd restart"
/etc/init.d/httpd restart
