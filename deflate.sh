#!/bin/sh

CONFIGFILE="/etc/httpd/conf.d/deflate.conf"

## create deflate.conf
echo "create $CONFIGFILE"
cat << EOS > $CONFIGFILE
<Location />
# Insert filter
SetOutputFilter DEFLATE

# Netscape 4.x has some problems...
BrowserMatch ^Mozilla/4 gzip-only-text/html

# Netscape 4.06-4.08 have some more problems
BrowserMatch ^Mozilla/4\.0[678] no-gzip

# MSIE masquerades as Netscape, but it is fine
BrowserMatch \bMSIE !no-gzip !gzip-only-text/html

# Don't compress images
SetEnvIfNoCase Request_URI \.(?:gif|jpe?g|png)$ no-gzip dont-vary

# Make sure proxies don't deliver the wrong content
Header append Vary User-Agent env=!dont-vary
</Location>
EOS

## set permission
echo "chown apache:apache $CONFIGFILE"
chown apache:apache $CONFIGFILE

## httpd restart
echo "/etc/init.d/httpd graceful"
/etc/init.d/httpd graceful
