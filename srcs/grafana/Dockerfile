FROM	alpine:3.13
LABEL	maintainer="Tatsuhiro Komatsu <tkomatsu@student.42tokyo.jp>"

RUN		echo "https://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories
RUN		set -x \
		&& apk update \
		&& apk --no-cache add openssl telegraf libc6-compat

ENV		GRAFANA_VERSION=7.4.5
RUN		wget https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
		&& tar -xvf grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
		&& rm grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
		&& mv grafana-${GRAFANA_VERSION} /usr/share/grafana

RUN		mkdir -p /etc/grafana/ssl \
		&& openssl req	-x509 \
						-nodes \
						-newkey rsa:4096 \
						-days 365 \
						-subj "/C=JP/ST=Tokyo/L=Minato-ku/O=42tokyo" \
						-keyout /etc/grafana/ssl/grafana.key \
						-out /etc/grafana/ssl/grafana.crt

ENV		GF_PATHS_CONFIG=/usr/share/grafana/conf/sample.ini \
		GF_PATHS_DATA=/var/lib/grafana \
		GF_PATHS_HOME=/usr/share/grafana \
		GF_PATHS_LOGS=/var/log/grafana \
		GF_PATHS_PLUGINS=/usr/share/grafana/plugins-bundled \
		GF_PATHS_PROVISIONING=/usr/share/grafana/conf \
		GF_SECURITY_ADMIN_USER=admin \
		GF_SECURITY_ADMIN_PASSWORD=admin

WORKDIR	/usr/share/grafana

COPY	./srcs/telegraf.conf /etc/telegraf.conf
COPY	./srcs/datasources.yaml /usr/share/grafana/conf/provisioning/datasources/datasources.yaml

COPY	./srcs/init.sh /
RUN		chmod +x /init.sh

CMD		/init.sh
