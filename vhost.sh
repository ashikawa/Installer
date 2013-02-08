#!/bin/sh

echo "Enter your domain name:"
read DOMAIN_NAME
while [ "$DOMAIN_NAME" == "" ]
do
    read DOMAIN_NAME
done


## DocumentRoot
echo "mkdir -p /var/www/$DOMAIN_NAME/public"
mkdir -p /var/www/$DOMAIN_NAME/public

## log dir
echo "mkdir -p /var/www/$DOMAIN_NAME/logs"
mkdir -p /var/www/$DOMAIN_NAME/logs

## create httpd-vhots.conf
echo "create /etc/httpd/conf.d/$DOMAIN_NAME.conf"
cat << EOS > /etc/httpd/conf.d/$DOMAIN_NAME.conf
<VirtualHost *:80>
    ServerName $DOMAIN_NAME
    DocumentRoot "/var/www/$DOMAIN_NAME/public" 
	
    CustomLog "|/usr/sbin/rotatelogs /var/www/$DOMAIN_NAME/logs/access_log_%Y%m%d 86400 540" combined
    ErrorLog  "|/usr/sbin/rotatelogs /var/www/$DOMAIN_NAME/logs/error_log_%Y%m%d 86400 540" 
	
#    CustomLog /var/www/$DOMAIN_NAME/logs/access_log combined
#    ErrorLog  /var/www/$DOMAIN_NAME/logs/error_log 
	
    <Directory "/var/www/$DOMAIN_NAME/public">
        Options -Indexes FollowSymLinks
        order deny,allow
        deny from ALL
        allow from ALL
        AllowOverride All
    </Directory>
</VirtualHost>
EOS

## htpasswd empty file
## htpasswd -cb /var/www/$DOMAIN_NAME/htpasswd user password
echo "create /var/www/$DOMAIN_NAME/htpasswd"
touch /var/www/$DOMAIN_NAME/htpasswd


## htaccess sample
echo "create /var/www/$DOMAIN_NAME/public/.htaccess"
cat << EOS > /var/www/$DOMAIN_NAME/public/.htaccess
#AuthType Basic
#AuthName "Please enter your ID and password"
#AuthUserFile /var/www/$DOMAIN_NAME/htpasswd
#AuthGroupFile /dev/null
#require valid-user

#Satisfy Any
#Order Allow,Deny

# 許可するIP 1
#Allow from xxx.xxx.xxx.xxx
# 許可するIP 2
#Allow from yyy.yyy.yyy.yyy

# FB のクローラを許可
#SetEnvIf User-Agent "^facebookexternalhit.*$" fb_crawler
#SetEnvIf User-Agent "^facebookplatform.*$" fb_crawler
#Allow from env=fb_crawler

AddDefaultCharset UTF-8
EOS

## set permission
echo "chown -R apache:apache /var/www/$DOMAIN_NAME"
chown -R apache:apache /var/www/$DOMAIN_NAME
chmod g+w -R /var/www/$DOMAIN_NAME

## httpd restart
echo "/etc/init.d/httpd graceful"
/etc/init.d/httpd graceful
