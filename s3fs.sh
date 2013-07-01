# 
# @see http://lab.eli-sys.jp/2013/02/03/amazon-s3%E3%82%92%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0%E3%81%A8%E3%81%97%E3%81%A6%E3%83%9E%E3%82%A6%E3%83%B3%E3%83%88%E3%81%99%E3%82%8B/
# 

yum install gcc make libstdc++-devel gcc-c++ fuse  fuse-devel  curl-devel libxml2-devel openssl-devel mailcap

cd /usr/local/src/
wget http://s3fs.googlecode.com/files/s3fs-1.62.tar.gz
tar xvzf s3fs-1.62.tar.gz 
cd s3fs-1.62/

./configure --prefix=/usr 
make
make install

echo $AWS_API:$AWS_SECRET >> /etc/passwd-s3fs

mkdir /mnt/s3

cat << EOS >> /etc/fstab
s3fs#$BUCKET_NAME /mnt/s3 fuse allow_other 0 0
EOS

mount -a