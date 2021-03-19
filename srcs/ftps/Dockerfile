FROM	alpine:3.13
LABEL	maintainer="Tatsuhiro Komatsu <tkomatsu@student.42tokyo.jp>"

RUN		echo "https://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories
RUN		set -x \
		&& apk update \
		&& apk --no-cache add vsftpd openssl telegraf

COPY	./srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN		mkdir -p /etc/vsftpd/ssl \
		&& openssl req	-x509 \
						-nodes \
						-newkey rsa:4096 \
						-days 365 \
						-subj "/C=JP/ST=Tokyo/L=Minato-ku/O=42tokyo" \
						-keyout /etc/vsftpd/ssl/server.key \
						-out /etc/vsftpd/ssl/server.crt

COPY	./srcs/init.sh /
RUN		chmod +x /init.sh

CMD		[ "/init.sh" ]
