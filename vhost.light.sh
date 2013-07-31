#!/bin/sh
CMDNAME=`basename $0`

while getopts n:d: OPT
do
    case $OPT in
        "n" ) SERVER_NAME="$OPTARG";;
        "d" ) DOCUMENT_ROOT="$OPTARG";;
    esac
done

if [ "$SERVER_NAME" == "" ]; then
  echo "Usage: $CMDNAME -n SERVER_NAME -d DOCUMENT_ROOT" 1>&2
  exit 1 ;
fi

if [ "$DOCUMENT_ROOT" == "" ]; then
  echo "Usage: $CMDNAME -n SERVER_NAME -d DOCUMENT_ROOT" 1>&2
  exit 1 ;
fi

## DocumentRoot
echo "mkdir -p $DOCUMENT_ROOT"
mkdir -p $DOCUMENT_ROOT

## create httpd-vhots.conf
echo "create /etc/httpd/conf.d/$SERVER_NAME.conf"
cat << EOS > /etc/httpd/conf.d/$SERVER_NAME.conf
<VirtualHost *:80>
    ServerName $SERVER_NAME
    DocumentRoot "$DOCUMENT_ROOT" 

    <Directory "$DOCUMENT_ROOT">
        Options -Indexes FollowSymLinks
        order deny,allow
        deny from ALL
        allow from ALL
        AllowOverride All
    </Directory>
</VirtualHost>
EOS

## htpasswd empty file
## htpasswd -cb $DOCUMENT_ROOT/.htpasswd user password
echo "create $DOCUMENT_ROOT/.htpasswd"
touch $DOCUMENT_ROOT/.htpasswd

## htaccess sample
echo "create $DOCUMENT_ROOT/.htaccess"
cat << EOS > $DOCUMENT_ROOT/.htaccess
#AuthType Basic
#AuthName "Please enter your ID and password"
#AuthUserFile $DOCUMENT_ROOT/htpasswd
#AuthGroupFile /dev/null
#require valid-user

#Satisfy Any
#Order Allow,Deny

# allow IP 1
#Allow from xxx.xxx.xxx.xxx
# allow 2
#Allow from yyy.yyy.yyy.yyy

# FB bot
#SetEnvIf User-Agent "^facebookexternalhit.*$" fb_crawler
#SetEnvIf User-Agent "^facebookplatform.*$" fb_crawler
#Allow from env=fb_crawler

AddDefaultCharset UTF-8
EOS

## set permission
echo "chown -R apache:apache $DOCUMENT_ROOT"
chown -R apache:apache $DOCUMENT_ROOT
chmod g+w -R $DOCUMENT_ROOT
