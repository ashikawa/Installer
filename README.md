# Installer Scripts

サーバー初期化用のスクリプト

## Cent Default init

```sh
yum install -y wget && wget "https://www.dropbox.com/s/e40k1zoize0u005/cent.sh?dl=1" -O /tmp/cent.sh && sh /tmp/cent.sh
```

リポジトリの追加

```sh
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
```

手動で

```sh
vi /etc/yum.repos.d/remi.repo 
enabled=1
mirrorlist の $releasever を 6 に書き換え
```

## Apache

```sh
wget "https://www.dropbox.com/s/zads77926xhezrx/apache.sh?dl=1" -O /tmp/apache.sh && sh /tmp/apache.sh
```

作業ユーザーの追加

```sh
useradd -g apache $USERNAME
passwd $USERNAME
echo "umask 002" >> /home/$USERNAME/.bashrc
ln -s /var/www/$DOMAIN_NAME/public/ /home/$USERNAME/public
chown $USERNAME:$USERNAME /home/$USERNAME/public

vi /etc/ssh/sshd_config
# Subsystem       sftp    /usr/libexec/openssh/sftp-server –u 002
Subsystem sftp internal-sftp -u 0002

/etc/init.d/sshd restart
```

### Apache VirtualHost

```sh
wget "https://www.dropbox.com/s/ujvnst2kjp5g07n/vhost.sh?dl=1" -O /tmp/vhost.sh && sh /tmp/vhost.sh

# 簡易版
wget "https://www.dropbox.com/s/4s96m0g5jolnta6/vhost.light.sh?dl=1" -O vhost.light.sh
```

### Apache deflate

```sh
wget "https://dl.dropbox.com/s/9gv3h7zh06elyhr/deflate.sh?dl=1" -O /tmp/deflate.sh && sh /tmp/deflate.sh
```

## MySql

```sh
wget "https://www.dropbox.com/s/su7ebh0yrzd7zbc/mysql.sh?dl=1" -O /tmp/mysql.sh && sh /tmp/mysql.sh
```

初期設定

```sh
mysql_secure_installation
```

### Mysql UserAdd

```sh
wget "https://www.dropbox.com/s/jo9dxyxnelw9r3r/mysql_user.sh?dl=1" -O /tmp/mysql_user.sh.sh && sh /tmp/mysql_user.sh.sh
```

## PHP

```sh
wget "https://www.dropbox.com/s/6mpts33tjjwx6xh/php.sh?dl=1" -O /tmp/php.sh && sh /tmp/php.sh
```

## WordPress

```
curl http://wp-cli.org/installer.sh | bash
cd DOCUMENT_ROOT

wp core download --locale=ja

wp core config \
    --dbhost=$DBHOST \
    --dbname=$DBNAME \
    --dbuser=$DBUSER \
    --dbpass=$DBPASS
 
wp core install \
    --url=$SITE_DOMAIN \
    --title=$SITE_TITLE \
    --admin_name=$ADMIN_NAME \
    --admin_email=admin@example.com \
    --admin_password=password 
```

### FTP設定

wp-config.php に追記

```php
define('FS_METHOD', 'direct');
```

### パーミッション設定

wp-config.php に追記

```php
define('FS_CHMOD_DIR', 0775);
define('FS_CHMOD_FILE', 0664);
```

## Chroot

```sh
wget "https://www.dropbox.com/s/w9pwfq0msrd1qcy/chroot.sh?dl=1" -O /tmp/chroot.sh && sh /tmp/chroot.sh
```

## Memcached

```sh
wget "https://www.dropbox.com/s/xbo89gzzzebt30b/memcached.sh?dl=1" -O /tmp/memcached.sh && sh /tmp/memcached.sh
```

## AWS EC2

パスワードによるログインを許可

```sh
sed -i -e 's#PasswordAuthentication no#PasswordAuthentication yes#g' /etc/ssh/sshd_config
/etc/init.d/sshd restart
```

HealthCheck

```sh
cat << EOS  > /etc/httpd/conf.d/healthcheck.conf
    Alias /healthcheck /var/www/healthcheck
EOS

mkdir /var/www/healthcheck
cat << EOS  > /var/www/healthcheck/index.php
<?php
echo "success";
EOS
```

.htaccess

```.htaccess
SetEnvIf X-Forwarded-For "xxx.xxx.xxx.xxx" allowedip
Allow from env=allowedip
```

## PhpMyAdmin

```sh
yum --enablerepo=remi install phpMyAdmin
```

config

```sh
vi /etc/httpd/cond.d/phpMyAdmin.conf
# アクセス制限を調整
```

## Nginx

```sh
# epel enabled=1
yum -y install nginx

/etc/init.d/nginx start
chkconfig nginx on
chkconfig --list
```
