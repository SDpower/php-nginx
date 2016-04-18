#!/bin/sh

touch /var/log/nginx/access.log
touch /var/log/nginx/error.log

chown -R www-data:www-data /var/www

tail --follow --retry /var/log/nginx/*.log &

/usr/local/sbin/php-fpm &
/etc/init.d/nginx start
