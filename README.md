# Installer Scripts

サーバー初期化用のスクリプト

## Cent Default init

```
yum install -y wget && wget "https://www.dropbox.com/s/e40k1zoize0u005/cent.sh?dl=1" -O /tmp/cent.sh && sh /tmp/cent.sh
```

## Apache

```
wget "https://www.dropbox.com/s/zads77926xhezrx/apache.sh?dl=1" -O /tmp/apache.sh && sh /tmp/apache.sh
```

### Apache VirtualHost

```
wget "https://www.dropbox.com/s/ujvnst2kjp5g07n/vhost.sh?dl=1" -O /tmp/vhost.sh && sh /tmp/vhost.sh
```

### Apache deflate

```
wget "https://dl.dropbox.com/s/9gv3h7zh06elyhr/deflate.sh?dl=1" -O /tmp/deflate.sh && sh /tmp/deflate.sh
```

## MySql

```
wget "https://www.dropbox.com/s/su7ebh0yrzd7zbc/mysql.sh?dl=1" -O /tmp/mysql.sh && sh /tmp/mysql.sh
```

## PHP

```
wget "https://www.dropbox.com/s/6mpts33tjjwx6xh/php.sh?dl=1" -O /tmp/php.sh && sh /tmp/php.sh
```

## WordPress

```
wget "https://www.dropbox.com/s/if5x3frcwqas6ef/wordpress.sh?dl=1" -O /tmp/wordpress.sh && sh /tmp/wordpress.sh
```

## Chroot

```
wget "https://www.dropbox.com/s/w9pwfq0msrd1qcy/chroot.sh?dl=1" -O /tmp/chroot.sh && sh /tmp/chroot.sh
```