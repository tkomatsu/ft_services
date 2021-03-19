#!/bin/sh

telegraf --config /etc/telegraf.conf &

nginx

tail -f /var/log/nginx/access.log
