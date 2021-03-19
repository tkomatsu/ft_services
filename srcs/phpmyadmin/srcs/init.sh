#!/bin/sh

sed	-e "s/localhost/$PMA_HOST/g" \
	/var/www/phpmyadmin/config.sample.inc.php \
	> /var/www/phpmyadmin/config.inc.php

sed -i \
	-e s/';listen.owner = nobody'/'listen.owner = nginx'/g \
	-e s/';listen.group = nobody'/'listen.group = nginx'/g \
	-e s/'user = nobody'/'user = nginx'/g \
	-e s/'group = nobody'/'group = nginx'/g \
	/etc/php7/php-fpm.d/www.conf

telegraf --config /etc/telegraf.conf &

php-fpm7
nginx

tail -f /var/log/nginx/access.log
