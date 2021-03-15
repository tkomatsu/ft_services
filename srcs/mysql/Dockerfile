FROM	alpine:3.13
LABEL	miantainer="Tatsuhiro Komatsu <tkomatsu@student.42tokyo.jp>"

RUN		set -x \
		&& apk update \
		&& apk --no-cache add mariadb mariadb-client

RUN		sed -i -e s/skip-networking/'#skip-networking'/ /etc/my.cnf.d/mariadb-server.cnf

COPY	./srcs/init.sh /
RUN		chmod 755 /init.sh

CMD		[ "/init.sh" ]
