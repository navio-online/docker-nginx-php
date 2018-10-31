#!/bin/bash

cp /usr/local/etc/php/php.ini-${ENVIRONMENT} /usr/local/etc/php/php.ini

sed -i "s#set_real_ip_from 10.0.0.0/8;#set_real_ip_from $REAL_IP_FROM;#" /etc/nginx/conf.d/default.conf

exec /usr/bin/supervisord -n -c /etc/supervisord.conf