#!/bin/sh

# LTSV カスタムログ
echo "ltsv log"
LTSV="/etc/httpd/conf.d/ltsv.conf"
cat << EOS > $LTSV
# LTSV combined log
# @see http://ltsv.org/
#
LogFormat "time:%{%d/%b/%Y:%H:%M:%S %z}t\tforwardedfor:%{X-Forwarded-For}i\thost:%h\tmethod:%m\tpath:%U%q\tprotocol:%H\tstatus:%>s\tsize:%b\treferer:%{Referer}i\tua:%{User-Agent}i\treqtime_microsec:%D\tcache:%{X-Cache}o\truntime:%{X-Runtime}o\tvhost:%{Host}i" ltsv
# CustomLog logs/access_log ltsv
EOS
chown apache:apache $LTSV

# LTSV パーサー
echo "ltsv parser"
PARSER="/usr/local/bin/ltsv"
cat << EOS > $PARSER
#!/usr/bin/env ruby
while gets
  record = Hash[$_.split("\t").map{|f| f.split(":", 2)}]
  p record
end
EOS

chmod +x $PARSER

# Apache の再起動
echo "/etc/init.d/httpd restart"
/etc/init.d/httpd restart