# Installer Scripts

サーバー初期化用のスクリプト

## Cent Default init

    yum install -y wget && wget "https://www.dropbox.com/s/e40k1zoize0u005/cent.sh?dl=1" -O /tmp/cent.sh && sh /tmp/cent.sh

リポジトリの追加

    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

手動で

    vi /etc/yum.repos.d/remi.repo 
    enabled=1
    mirrorlist の $releasever を 6 に書き換え

## Apache

    wget "https://www.dropbox.com/s/zads77926xhezrx/apache.sh?dl=1" -O /tmp/apache.sh && sh /tmp/apache.sh

作業ユーザーの追加

    useradd -g apache $USERNAME
    passwd $USERNAME
    echo "umask 002" >> /home/$USERNAME/.bashrc
    ln -s /var/www/$DOMAIN_NAME/public/ /home/$USERNAME/public
    chown $USERNAME:$USERNAME /home/$USERNAME/public

### Apache VirtualHost

    wget "https://www.dropbox.com/s/ujvnst2kjp5g07n/vhost.sh?dl=1" -O /tmp/vhost.sh && sh /tmp/vhost.sh

### Apache deflate

    wget "https://dl.dropbox.com/s/9gv3h7zh06elyhr/deflate.sh?dl=1" -O /tmp/deflate.sh && sh /tmp/deflate.sh

## MySql

    wget "https://www.dropbox.com/s/su7ebh0yrzd7zbc/mysql.sh?dl=1" -O /tmp/mysql.sh && sh /tmp/mysql.sh

ユーザーの追加

    mysql -u mysql

    SET PASSWORD FOR mysql@localhost=PASSWORD('new_password');
    GRANT ALL PRIVILEGES ON *.* TO newuser@localhost IDENTIFIED BY 'new_password';
    FLUSH PRIVILEGES;

    -- 外部からのアクセス
    GRANT ALL PRIVILEGES ON *.* TO newuser@"% IDENTIFIED BY 'new_password';

    CREATE DATABASE $DB_NAME;

## PHP

    wget "https://www.dropbox.com/s/6mpts33tjjwx6xh/php.sh?dl=1" -O /tmp/php.sh && sh /tmp/php.sh

## WordPress

    wget "https://www.dropbox.com/s/if5x3frcwqas6ef/wordpress.sh?dl=1" -O /tmp/wordpress.sh && sh /tmp/wordpress.sh

### FTP設定

wp-config.php に追記

    define('FS_METHOD', 'direct');

## Chroot

    wget "https://www.dropbox.com/s/w9pwfq0msrd1qcy/chroot.sh?dl=1" -O /tmp/chroot.sh && sh /tmp/chroot.sh

## Memcached

    wget "https://www.dropbox.com/s/xbo89gzzzebt30b/memcached.sh?dl=1" -O /tmp/memcached.sh && sh /tmp/memcached.sh


## AWS EC2

パスワードによるログインを許可

    sed -i -e 's#PasswordAuthentication no#PasswordAuthentication yes#g' /etc/ssh/sshd_config
    /etc/init.d/sshd restart

HealthCheck

    cat << EOS  > /etc/httpd/conf.d/healthcheck.conf
        Alias /healthcheck /var/www/healthcheck
    EOS

    cat << EOS  > /var/www/healthcheck/index.php
    <?php
    echo "success";
    EOS

## PhpMyAdmin

    yum --enablerepo=remi install phpMyAdmin

config

    vi /etc/httpd/cond.d/phpMyAdmin.conf
    # アクセス制限を調整
