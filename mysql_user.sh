#!/bin/sh
echo "Enter database host"
read HOST_NAME
while [ "$HOST_NAME" == "" ]
do
    read HOST_NAME
done

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

echo "Enter Access From (e.g localhost, %):"
read ACCESS_FROM
while [ "$ACCESS_FROM" == "" ]
do
    read ACCESS_FROM
done

echo "Enter MySQL root passowrd:"

cat << EOS | mysql -h $HOST_NAME -u root -p
CREATE USER $MYSQL_USER;
CREATE DATABASE $DATABASE_NAME;
GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO "$MYSQL_USER"@"$ACCESS_FROM" IDENTIFIED BY "$MYSQL_PASSWORD";
FLUSH PRIVILEGES;
EOS