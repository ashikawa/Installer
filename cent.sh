#!/bin/sh

echo "yum -y update"
yum -y update

# Epel
rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6
rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/epel.repo

# Remi
rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/remi.repo

# CentAlt
cat > /etc/yum.repos.d/centos.alt.ru.repo <<EOF
[CentALT]
name=CentALT Packages for Enterprise Linux 6 - \$basearch
baseurl=http://centos.alt.ru/repository/centos/6/\$basearch/
enabled=0
gpgcheck=0
EOF


echo "yum install -y gcc gcc-c++ make openssl-devel git subversion telnet mailx sysstat"
yum install -y gcc gcc-c++ make openssl-devel git subversion telnet sysstat

echo "yum --enablerepo=epel -y install inotify-tools"
yum --enablerepo=epel -y install inotify-tools

echo "yum -y install zsh"
yum -y install zsh

# SE Linux のオフ
setenforce 0
sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
