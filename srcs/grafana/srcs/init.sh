#!/bin/sh

telegraf --config /etc/telegraf.conf &

/usr/share/grafana/bin/grafana-server --homepath=/usr/share/grafana \
	cfg:default.paths.provisioning="$GF_PATHS_PROVISIONING"
