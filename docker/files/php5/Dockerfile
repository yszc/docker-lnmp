FROM php:5.6-fpm-alpine

RUN apk add --no-cache \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    zlib-dev \
    libzip-dev \
    autoconf \
    g++ \
    make \
    && docker-php-ext-install gd pdo_mysql mysqli \
    && pecl install redis-3.1.6 \
    && docker-php-ext-enable redis \
    && rm -rf /tmp/* /var/cache/apk/*
