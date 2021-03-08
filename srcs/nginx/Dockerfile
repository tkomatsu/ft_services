FROM	alpine:3.13
LABEL	miantainer="Tatsuhiro Komatsu <tkomatsu@student.42tokyo.jp>"

RUN		set -x \
		&& apk --update --no-cache add nginx openssl

RUN		mkdir /etc/nginx/ssl \
		&& openssl genrsa -out /etc/nginx/ssl/server.key 2048 \
		&& openssl req -new \
						-x509 \
						-days 3650 \
						-key /etc/nginx/ssl/server.key \
						-out /etc/nginx/ssl/server.crt \
						-subj "/C=JP/ST=Tokyo/L=Minato-ku/O=42tokyo"

RUN		mkdir -p /run/nginx

COPY	./srcs/default.conf /etc/nginx/http.d/default.conf
COPY	./srcs/index.html /var/www/index.html

CMD		[ "nginx", "-g", "daemon off;" ]
