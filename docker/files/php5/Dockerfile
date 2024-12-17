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
    
# RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"