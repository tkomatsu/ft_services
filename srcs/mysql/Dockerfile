FROM	alpine:3.13
LABEL	miantainer="Tatsuhiro Komatsu <tkomatsu@student.42tokyo.jp>"

# default password
ENV		MYSQL_ROOT_PASSWORD=password

RUN		set -x \
		&& apk update \
		&& apk --no-cache add mariadb mariadb-client

EXPOSE	3306

# initialize MariaDB
# https://mariadb.com/kb/en/mysql_install_db/
RUN		/usr/bin/mysql_install_db --user=mysql --datadir=/var/lib/mysql --auth-root-authentication-method=normal

COPY	./srcs/init.sh /
RUN		chmod 755 /init.sh

CMD		[ "/init.sh" ]
