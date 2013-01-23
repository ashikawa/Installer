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

# その他設定の追加
echo "add TraceEnable Off"
echo "TraceEnable Off" >> $CONFIGFILE


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


# Apache の再起動
echo "/etc/init.d/httpd restart"
/etc/init.d/httpd restart
