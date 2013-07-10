#!/bin/sh

echo "yum -y update"
yum -y update

echo "yum install -y gcc gcc-c++ make openssl-devel git subversion telnet mailx sysstat"
yum install -y gcc gcc-c++ make openssl-devel git subversion telnet sysstat

echo "yum --enablerepo=epel -y install inotify-tools"
yum --enablerepo=epel -y install inotify-tools

# SE Linux のオフ
setenforce 0
sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
