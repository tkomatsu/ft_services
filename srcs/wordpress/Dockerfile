FROM	alpine:3.13
LABEL	miantainer="Tatsuhiro Komatsu <tkomatsu@student.42tokyo.jp>"

RUN		set -x \
		&& apk --update --no-cache add	fcgi \
										nginx \
										openssl \
										php7 \
										php7-cgi \
										php7-common \
										php7-ctype \
										php7-curl \
										php7-dom \
										php7-fpm \
										php7-gd \
										php7-gettext \
										php7-iconv \
										php7-imap \
										php7-json \
										php7-ldap \
										php7-mcrypt \
										php7-mysqli \
										php7-pdo \
										php7-pdo_mysql \
										php7-posix \
										php7-soap \
										php7-xml \
										php7-xmlrpc

RUN		mkdir /etc/nginx/ssl \
		&& openssl genrsa -out /etc/nginx/ssl/server.key 2048 \
		&& openssl req -new \
						-x509 \
						-days 3650 \
						-key /etc/nginx/ssl/server.key \
						-out /etc/nginx/ssl/server.crt \
						-subj "/C=JP/ST=Tokyo/L=Minato-ku/O=42tokyo"

COPY	./srcs/wordpress /var/www/html

RUN		mkdir -p /run/nginx
RUN		mkdir -p /run/php-fpm
COPY	./srcs/default.conf /etc/nginx/http.d/default.conf
COPY	./srcs/www.conf /etc/php7/php-fpm.d/www.conf

#COPY	./srcs/init.sh /
#RUN		chmod 755 /init.sh

#CMD		[ "/init.sh" ]
CMD			[ "nginx", "-g", "daemon off;" ]
