#!/bin/sh

# WordPress

echo "Enter database name"
read DATABASE_NAME
while [ "$DATABASE_NAME" == "" ]
do
    read DATABASE_NAME
done

echo "Enter mysql user name:"
read MYSQL_USER
while [ "$MYSQL_USER" == "" ]
do
    read MYSQL_USER
done

echo "Enter $MYSQL_USER's password:"
read MYSQL_PASSWORD
while [ "$MYSQL_PASSWORD" == "" ]
do
    read MYSQL_PASSWORD
done


echo "Enter MySQL root passowrd:"

cat << EOS | mysql -u root -p
CREATE USER $MYSQL_USER;
CREATE DATABASE $DATABASE_NAME;
GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO "$MYSQL_USER"@"localhost" IDENTIFIED BY "$MYSQL_PASSWORD";
FLUSH PRIVILEGES;
EOS

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

