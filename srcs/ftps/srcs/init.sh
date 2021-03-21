#!/bin/sh

adduser -h /var/lib/ftp -D $FTP_USER && echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
