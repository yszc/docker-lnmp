FROM phpdockerio/php56-fpm

RUN sed -i 's/\/\w\+.debian.org/\/mirrors.163.com/gi' /etc/apt/sources.list

RUN apt-get update && apt-get install -y php5-mysql php5-gd php5-redis php5-memcache
