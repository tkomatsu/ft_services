FROM	alpine:latest
LABEL	miantainer="Tatsuhiro Komatsu <tkomatsu@student.42tokyo.jp>"

RUN		echo -e "http://nl.alpinelinux.org/alpine/v3.5/main\nhttp://nl.alpinelinux.org/alpine/v3.5/community" > /etc/apk/repositories
RUN		set -x \
		&& apk update \
		&& apk --no-cache add nginx openssl

RUN		mkdir /etc/nginx/ssl \
		&& openssl genrsa -out /etc/nginx/ssl/server.key 2048 \
		&& openssl req -new \
						-x509 \
						-days 3650 \
						-key /etc/nginx/ssl/server.key \
						-out /etc/nginx/ssl/server.crt \
						-subj "/C=JP/ST=Tokyo/L=Minato-ku/O=42tokyo"

RUN		mkdir -p /run/nginx

COPY	./srcs/default.conf /etc/nginx/conf.d/default.conf
COPY	./srcs/index.html /var/www/index.html

CMD		[ "nginx", "-g", "daemon off;" ]
