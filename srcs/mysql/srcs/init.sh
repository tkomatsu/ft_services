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
	if [ -z "$MYSQL_ROOT_PASSWORD" || -z "$MYSQL_DATABASE" || -z "$MYSQL_USER" || -z "$MYSQL_PASSWORD" || -z "$MYSQL_HOST" ]; then
		mysql_error $'You neeed to specify all of MYSQL_ROOT_PASSWORD, MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD, MYSQL_HOST'
	fi
}

if [ ! -d /var/lib/mysql/]; then
	verify_env
# initialize MariaDB
# https://mariadb.com/kb/en/mysql_install_db/
	mysql_install_db --datadir=/var/lib/mysql --auth-root-authentication-method=normal
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

/usr/bin/mysqld_safe --datadir='/var/lib/mysql'
tail -f /var/lib/mysql/mysql-deployment-*.err
