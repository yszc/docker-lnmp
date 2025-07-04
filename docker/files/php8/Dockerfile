FROM php:8.3-fpm-alpine

# 设置标签
LABEL maintainer="Your Name <your.email@example.com>"
LABEL version="1.0"
LABEL description="PHP 8.3 FPM with extensions for web development"

# 设置工作目录
WORKDIR /var/www/html

# 使用阿里云镜像源（更稳定的选择）并确保启用community仓库
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    echo "https://mirrors.aliyun.com/alpine/v$(cat /etc/alpine-release | cut -d'.' -f1,2)/community" >> /etc/apk/repositories

# 更新包索引并确保community仓库启用
RUN apk update && apk upgrade

# 安装系统依赖
RUN apk add --no-cache \
    # intl扩展依赖
    icu-dev \
    # gettext扩展依赖
    gettext-dev \
    # GD图形库依赖
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    # ZIP扩展依赖（确保从community仓库安装）
    libzip \
    libzip-dev \
    # XML扩展依赖
    libxml2-dev \
    # CURL扩展依赖
    curl-dev \
    # BZ2扩展依赖
    bzip2-dev \
    # Sockets扩展依赖
    linux-headers \
    # 版本控制工具
    git \
    # 文本对比工具
    diffutils \
    # 构建工具
    autoconf \
    g++ \
    make

# 配置并安装PHP扩展
RUN set -ex; \
    # 配置GD扩展支持
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    
    # 安装核心扩展
    docker-php-ext-install -j$(nproc) \
        intl \
        gd \
        zip \
        opcache \
        pdo_mysql \
        mysqli \
        bcmath \
        bz2 \
        calendar \
        exif \
        gettext \
        sockets \
        dba \
        pcntl \
        shmop; \
    
    # 安装PECL扩展
    pecl install apcu redis igbinary msgpack; \
    docker-php-ext-enable apcu.so redis.so igbinary.so msgpack.so; \
    
    # 清理缓存减小镜像体积
    rm -rf /tmp/* /var/cache/apk/*


# Set environment variable for PHP configuration type (development/production)
ARG PHP_ENV=development

# Copy appropriate php.ini based on environment variable
RUN if [ "$PHP_ENV" = "production" ]; then \
        mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"; \
    else \
        mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"; \
    fi
