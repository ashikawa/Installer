#!/bin/sh

echo "yum -y update"
yum -y update

echo "yum install -y gcc gcc-c++ make openssl-devel git subversion"
yum install -y gcc gcc-c++ make openssl-devel git subversion
