#!/bin/sh

echo "yum install -y httpd"
yum install -y httpd

echo "chkconfig httpd on"
chkconfig httpd on


CONFIGFILE="/etc/httpd/conf/httpd.conf"

# 不要な設定のコメントアウト
echo "comment out default Aliases"
sed -i -e 's#Alias /icons/ "/var/www/icons/"#\#Alias /icons/ "/var/www/icons/"#g' $CONFIGFILE
sed -i -e 's#ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"#\#ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"#g' $CONFIGFILE
sed -i -e 's#Alias /error/ "/var/www/error/"#\#Alias /error/ "/var/www/error/"#g' $CONFIGFILE

echo "Name VirtualHost on"
sed -i -e 's#\#NameVirtualHost \*:80#NameVirtualHost *:80#g' $CONFIGFILE

# その他設定の追加
echo "add TraceEnable Off"
cat << EOS > /etc/httpd/conf.d/notrace.conf
# This directive overrides the behavior of TRACE for both the core server and
# mod_proxy. The default TraceEnable on permits TRACE requests per RFC 2616,
# which disallows any request body to accompany the request. TraceEnable off
# causes the core server and mod_proxy to return a 405 (Method not allowed)
# error to the client.
TraceEnable off
EOS
chown apache:apache /etc/httpd/conf.d/notrace.conf


# キャッシュヘッダの設定
echo "set expires header"
EXPIRES="/etc/httpd/conf.d/expires.conf"

cat << EOS > $EXPIRES
<FilesMatch "\.(gif|jpe?g|png|js|css)$">
    ExpiresActive On
    ExpiresDefault "access plus 7 days"
</FilesMatch>
EOS
chown apache:apache $EXPIRES


# mimetypes の追加
echo "add mimetypes"
MIME="/etc/httpd/conf.d/mimes.conf"

cat << EOS > $MIME
<IfModule mime_module>
    AddType text/cache-manifest .appcache
    AddType image/svg+xml .svg
    AddType font/woff .woff
    AddType font/ttf .ttf
    AddType video/mp4 .mp4
    AddType application/vnd.android.package-archive .apk
</IfModule>
EOS
chown apache:apache $MIME

echo "ltsv log"
LTSV="/etc/httpd/conf.d/ltsv.conf"
car << EOS > $LTSV
# LTSV combined log
# @see http://ltsv.org/
#
LogFormat "time:%t\tforwardedfor:%{X-Forwarded-For}i\thost:%h\treq:%r\tstatus:%>s\tsize:%b\treferer:%{Referer}i\tua:%{User-Agent}i\treqtime_microsec:%D\tcache:%{X-Cache}o\truntime:%{X-Runtime}o\tvhost:%{Host}i" ltsv
# CustomLog logs/access_log ltsv
EOS
chown apache:apache $LTSV

# Apache の再起動
echo "/etc/init.d/httpd restart"
/etc/init.d/httpd restart
