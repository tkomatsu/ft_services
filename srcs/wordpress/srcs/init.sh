#!/bin/sh

sed -e s/database_name_here/$MYSQL_DATABASE/g \
	-e s/username_here/$MYSQL_USER/g \
	-e s/password_here/$MYSQL_PASSWORD/g \
	-e s/localhost/$MYSQL_HOST/g \
	/var/www/html/wp-config-sample.php \
	> /var/www/html/wp-config.php

sed -i -e s/'user = nobody'/'user = nginx'/g \
	-e s/'group = nobody'/'group = nginx'/g \
	-e s/';listen.owner = nobody'/'listen.owner = nginx'/g \
	-e s/';listen.group = nobody'/'listen.group = nginx'/g \
	/etc/php7/php-fpm.d/www.conf

sed -i -e s/';listen.group = nginx'/'listen.group = nginx'/g \
	/etc/php7/php-fpm.d/www.conf

php-fpm7
nginx

#tail -f /var/log/nginx/access.log
tail -f /dev/null
