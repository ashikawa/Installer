#!/bin/bash

#
# Usage: ./create_chroot_env5 username
# 事前に
#     useradd -d $USERDIR USERNAME
# をしておくこと
#


# Here specify the apps you want into the enviroment
APPS="/bin/bash /bin/cat /bin/cp /bin/chmod /bin/ls \
/bin/mkdir /bin/mv /bin/touch /bin/pwd /bin/rm /bin/vi \
/usr/bin/id /usr/bin/scp /usr/bin/sftp \
/usr/libexec/openssh/sftp-server /lib64/ld-linux-x86-64.so.2"


# Obtain username and HomeDir
echo "enter username"
read CHROOT_USERNAME
while [ "$CHROOT_USERNAME" == "" ]
do
    read CHROOT_USERNAME
done

echo "mk home dir"
HOMEDIR=`grep /etc/passwd -e "^$CHROOT_USERNAME" | cut -d':' -f 6`
mkdir $HOMEDIR
chown root:root $HOMEDIR
chmod 755 $HOMEDIR

cd $HOMEDIR

# Create writeable Directories only for you
#mkdir {data,public_html}
#chown $1:$1 {data,public_html}
#chmod 711 {data,public_html}


# Create Directories no one will do it for you
echo "Create Directories no one will do it for you"
mkdir {etc,bin,dev}
mkdir -p usr/bin
#mkdir -p usr/local/{bin,libexec}

MAKEDEV -d dev -x null random zero tty

# Create short version to /usr/bin/groups
# On some system it requires /bin/sh,
# which is generally unnessesary in a chroot cage

echo "Create short version to /usr/bin/groups"
echo "#!/bin/bash" > usr/bin/groups
echo "id -Gn" >> usr/bin/groups

# Add some users to ./etc/passwd
echo "Add some users to ./etc/passwd"
grep /etc/passwd -e "^root" -e "^$CHROOT_USERNAME" > etc/passwd
grep /etc/group -e "^root" -e "^$CHROOT_USERNAME" > etc/group


# Copy the apps and the related libs
echo "Copy the apps and the related libs"
for prog in $APPS; do
    cp $prog ./$prog

    # obtain a list of related libraryes
    ldd $prog > /dev/null
    if [ "$?" = 0 ] ; then
        LIBS=`ldd $prog | awk '{ print $3 }'`
        for l in $LIBS; do
            mkdir -p ./`dirname $l` > /dev/null 2>&1
            cp $l ./$l
        done
    fi
done


# From some strange reason these 3 libraries are not in the ldd output,
# but without them some stuff will not work, like usr/bin/groups
cp /lib/{libnss_compat.so.2,libnsl.so.1,libnss_files.so.2} ./lib/


# My original openssh'settings needs
# error: /dev/pts/2: No such file or directory て怒られたとき
cp -L /lib/ld-linux.so.2 ./lib/
cp /etc/{ld.so.cache,ld.so.conf,localtime} ./etc/


# AmazonLinux でエラーが出る場合
mkdir dev/pts
mount -t devpts devpts dev/pts 

echo "write sshd config to /etc/ssh/sshd_config"
cat << EOS >> /etc/ssh/sshd_config
Match User $CHROOT_USERNAME
    PasswordAuthentication yes
    AllowAgentForwarding no
    AllowTcpForwarding no
    ChrootDirectory $HOMEDIR
EOS

echo "sshd restart"
/etc/init.d/sshd restart
