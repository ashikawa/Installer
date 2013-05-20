#!/bin/sh

echo "yum -y update"
yum -y update

echo "yum install -y gcc gcc-c++ make openssl-devel git subversion telnet mailx"
yum install -y gcc gcc-c++ make openssl-devel git subversion telnet

# SE Linux のオフ
setenforce 0
sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
