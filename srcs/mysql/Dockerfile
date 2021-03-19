FROM	alpine:3.13
LABEL	maintainer="Tatsuhiro Komatsu <tkomatsu@student.42tokyo.jp>"

RUN		echo "https://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories
RUN		set -x \
		&& apk update \
		&& apk --no-cache add mariadb telegraf

RUN		sed -i -e s/skip-networking/'#skip-networking'/ /etc/my.cnf.d/mariadb-server.cnf

COPY	./srcs/telegraf.conf /etc/telegraf.conf

COPY	./srcs/init.sh /
RUN		chmod 755 /init.sh

CMD		[ "/init.sh" ]
