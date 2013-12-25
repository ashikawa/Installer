# Installer Scripts

サーバー初期化用のスクリプト

## Cent Default init

```sh
yum install -y wget && wget "https://raw.github.com/m-s-modified/Installer/master/cent.sh" -O /tmp/cent.sh && sh /tmp/cent.sh
```

公開鍵を追加

```sh
curl https://github.com/m-s-modified.keys >> ~/.ssh/authorized_keys
```

## Apache

```sh
wget "https://raw.github.com/m-s-modified/Installer/master/apache.sh" -O /tmp/apache.sh && sh /tmp/apache.sh
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
wget "https://raw.github.com/m-s-modified/Installer/master/vhost.sh" -O /tmp/vhost.sh && sh /tmp/vhost.sh

# 簡易版
wget "https://raw.github.com/m-s-modified/Installer/master/vhost.light.sh" -O vhost.light.sh
```

### Apache deflate

```sh
wget "https://raw.github.com/m-s-modified/Installer/master/deflate.sh" -O /tmp/deflate.sh && sh /tmp/deflate.sh
```

## MySql

```sh
wget "https://raw.github.com/m-s-modified/Installer/master/mysql.sh" -O /tmp/mysql.sh && sh /tmp/mysql.sh
```

初期設定

```sh
mysql_secure_installation
```

### Mysql UserAdd

```sh
wget "https://raw.github.com/m-s-modified/Installer/master/mysql_user.sh" -O /tmp/mysql_user.sh && sh /tmp/mysql_user.sh
```

## PHP

```sh
wget "https://raw.github.com/m-s-modified/Installer/master/php.sh" -O /tmp/php.sh && sh /tmp/php.sh
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
wget "https://raw.github.com/m-s-modified/Installer/master/chroot.sh" -O /tmp/chroot.sh && sh /tmp/chroot.sh
```

## Memcached

```sh
wget "https://raw.github.com/m-s-modified/Installer/master/memcached.sh" -O /tmp/memcached.sh && sh /tmp/memcached.sh
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

## FTP

```sh
wget "https://raw.github.com/m-s-modified/Installer/master/ftp.sh" -O /tmp/ftp.sh && sh /tmp/ftp.sh
```


## Nikto

```
cd /usr/local/src/
wget http://www.cirt.net/nikto/nikto-current.tar.gz
tar zxvf nikto-current.tar.gz
cd nikto-2.1.5
perl nikto.pl -update

# Run
perl nikto.pl -host http://localhost
```