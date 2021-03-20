#!/bin/sh

telegraf --config /etc/telegraf.conf &

/usr/share/grafana/bin/grafana-server \
	--homepath="$GF_PATHS_HOME" \
	--config="$GF_PATHS_CONFIG" \
	--packaging=docker \
	cfg:default.log.mode="console" \
	cfg:default.paths.data="$GF_PATHS_DATA" \
	cfg:default.paths.logs="$GF_PATHS_LOGS" \
	cfg:default.paths.provisioning="$GF_PATHS_PROVISIONING"
