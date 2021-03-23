#!/bin/sh

touch /var/log/influxd.log
influxd --config /etc/influxdb.conf 2> /var/log/influxd.log &

telegraf --config /etc/telegraf.conf &

tail -f /var/log/influxd.log
