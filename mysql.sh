#!/bin/sh

echo "yum install -y mysql mysql-devel mysql-libs mysql-server"
yum install -y mysql mysql-devel mysql-libs mysql-server

echo "cp /etc/my.cnf /etc/my.cnf.org"
cp /etc/my.cnf /etc/my.cnf.org

echo "create /etc/my.cnf"
cat << EOS  > /etc/my.cnf
[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid

[mysqld]
datadir         = /var/lib/mysql
user            = mysql

character-set-server = utf8
collation-server = utf8_general_ci
init-connect = SET NAMES utf8

[mysqldump]
default-character-set = utf8

[mysql]
default-character-set = utf8
EOS

echo "Enter MySQL root user pass:"
read ROOT_PASS
while [ "$ROOT_PASS" == "" ]
do
	read ROOT_PASS
done

echo "/usr/bin/mysqladmin -u root password $ROOT_PASS"
/usr/bin/mysqladmin -u root password $ROOT_PASS

echo "chkconfig mysqld on"
chkconfig mysqld on

echo "/etc/init.d/mysqld start"
/etc/init.d/mysqld start
