#!/bin/bash
# @auther <1822581649@qq.com>

/usr/sbin/init
/usr/sbin/crond
echo "info: starting php-fpm.."
/usr/sbin/php-fpm -c /etc/php.ini -y /etc/php-fpm.conf
tail -f /dev/null