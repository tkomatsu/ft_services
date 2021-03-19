#!/bin/sh

mysql_log() {
	local type="$1"; shift
	printf '[%s] [Entrypoint]: %s\n' "$type" "$*"
}

mysql_error() {
	myeql_log ERROR "$@" >&2
	exit 1
}

verify_env() {
	if [ -z "$MYSQL_ROOT_PASSWORD" -o -z "$MYSQL_DATABASE" -o -z "$MYSQL_USER" -o -z "$MYSQL_PASSWORD" -o  -z "$MYSQL_HOST" ]; then
		mysql_error $'You neeed to specify all of MYSQL_ROOT_PASSWORD, MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD, MYSQL_HOST'
	fi
}

if [ ! -d /var/lib/mysql/$MYSQL_DATABASE ]; then
	verify_env
# initialize MariaDB
# https://mariadb.com/kb/en/mysql_install_db/
	mysql_install_db --user=mysql --datadir=/var/lib/mysql --auth-root-authentication-method=normal
	cat << EOF > init.sql
USE mysql;
FLUSH PRIVILEGES ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
CREATE DATABASE ${MYSQL_DATABASE} CHARACTER SET utf8;
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' ;
GRANT ALL ON ${MYSQL_DATABASE}.* TO ${MYSQL_USER}@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' ;
FLUSH PRIVILEGES ;
EOF
	/usr/bin/mysqld --user=mysql --bootstrap < init.sql
	rm -f init.sql
fi

chown -R mysql:mysql /var/lib/mysql/

telegraf --config /etc/telegraf.conf &

/usr/bin/mysqld_safe --datadir=/var/lib/mysql --plugin-dir=/usr/lib/mariadb/plugin
tail -f /var/lib/mysql/mysql-*.err
