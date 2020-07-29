FROM phpdockerio/php74-fpm

RUN sed -i 's/\/\w\+.ubuntu.com/\/mirrors.163.com/gi' /etc/apt/sources.list

RUN apt-get update && apt-get install -y php7.4-mysql php7.4-gd php7.4-redis php7.4-memcache
