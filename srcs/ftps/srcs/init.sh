#!/bin/sh

adduser -h /var/lib/ftp -D $FTP_USER && echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
#echo -e "$FTP_PASSWORD\n$FTP_PASSWORD" | adduser -D $FTP_USER
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
