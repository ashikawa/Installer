#!/bin/sh

# WordPress

echo "wget -P /tmp/ http://ja.wordpress.org/latest-ja.tar.gz"
wget -P /tmp/ http://ja.wordpress.org/latest-ja.tar.gz
echo "tar zxvf /tmp/latest-ja.tar.gz -C /tmp/"
tar zxvf /tmp/latest-ja.tar.gz -C /tmp/


echo "Enter install dir"
read INSTALL_DIR
while [ "$INSTALL_DIR" == "" ]
do
    read INSTALL_DIR
done

echo "mkdir -p $INSTALL_DIR"
mkdir -p $INSTALL_DIR

echo "mv /tmp/wordpress/* $INSTALL_DIR"
mv /tmp/wordpress/* $INSTALL_DIR

echo "chown -R apache:apache $INSTALL_DIR"
chown -R apache:apache $INSTALL_DIR

# 設定ウィザードがあるので、wp-config.php　の設定は省略

