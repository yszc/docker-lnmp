FROM php:7.4-fpm-alpine

# 使用腾讯云镜像源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.cloud.tencent.com/g' /etc/apk/repositories

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
    && pecl install redis \
    && docker-php-ext-enable redis \
    && rm -rf /tmp/* /var/cache/apk/*

# Set environment variable for PHP configuration type (development/production)
ARG PHP_ENV=development

# Copy appropriate php.ini based on environment variable
RUN if [ "$PHP_ENV" = "production" ]; then \
        mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"; \
    else \
        mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"; \
    fi
