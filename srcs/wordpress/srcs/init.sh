#!/bin/sh

sed -e "s/database_name_here/$WORDPRESS_DB_NAME/g" \
	-e "s/username_here/$WORDPRESS_DB_USER/g" \
	-e "s/password_here/$WORDPRESS_DB_PASSWORD/g" \
	-e "s/localhost/$WORDPRESS_DB_HOST/g" \
	/var/www/wordpress/wp-config-sample.php \
	> /var/www/wordpress/wp-config.php

sed -i \
	-e s/';listen.owner = nobody'/'listen.owner = nginx'/g \
	-e s/';listen.group = nobody'/'listen.group = nginx'/g \
	-e s/'user = nobody'/'user = nginx'/g \
	-e s/'group = nobody'/'group = nginx'/g \
	/etc/php7/php-fpm.d/www.conf

php-fpm7
nginx

until wp core install --url=192.168.49.2:5050 --title=$WP_TITLE --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_MAIL --allow-root --path=/var/www/wordpress; do
	sleep 5
done

wp user create $WP_USER1 $WP_MAIL1 --role=editor --user_pass=$WP_PASS1 --path=/var/www/wordpress --allow-root
wp user create $WP_USER2 $WP_MAIL2 --role=editor --user_pass=$WP_PASS2 --path=/var/www/wordpress --allow-root

tail -f /var/log/nginx/access.log
