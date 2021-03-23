#!/bin/sh

telegraf --config /etc/telegraf.conf &

/usr/sbin/sshd
nginx

tail -f /var/log/nginx/access.log
