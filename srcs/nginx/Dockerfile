FROM	alpine:3.13
LABEL	maintainer="Tatsuhiro Komatsu <tkomatsu@student.42tokyo.jp>"

RUN		echo "https://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories
RUN		set -x \
		&& apk update \
		&& apk --no-cache add nginx openssl telegraf

RUN		mkdir /etc/nginx/ssl \
		&& openssl genrsa -out /etc/nginx/ssl/server.key 2048 \
		&& openssl req -new \
						-x509 \
						-days 3650 \
						-key /etc/nginx/ssl/server.key \
						-out /etc/nginx/ssl/server.crt \
						-subj "/C=JP/ST=Tokyo/L=Minato-ku/O=42tokyo"

RUN		mkdir -p /run/nginx

COPY	./srcs/telegraf.conf /etc/telegraf.conf

COPY	./srcs/default.conf /etc/nginx/conf.d/default.conf
COPY	./srcs/index.html /var/www/index.html

COPY	./srcs/init.sh /
RUN		chmod +x /init.sh

CMD		[ "/init.sh" ]
