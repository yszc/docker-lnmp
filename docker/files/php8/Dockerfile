FROM php:8.3-fpm-alpine

# 设置标签
LABEL maintainer="Your Name <your.email@example.com>"
LABEL version="1.0"
LABEL description="PHP 8.3 FPM with extensions for web development"

# 设置工作目录
WORKDIR /var/www/html

# 安装系统依赖
RUN apk add --no-cache \
    # intl扩展依赖
    icu-dev \
    # GD图形库依赖
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    # ZIP扩展依赖
    libzip-dev \
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
        mysqli; \
    
    # 安装PECL扩展
    pecl install apcu; \
    docker-php-ext-enable apcu; \
    
    # 清理缓存减小镜像体积
    rm -rf /tmp/* /var/cache/apk/*


# 选择开发环境配置（注释/取消注释以切换生产环境配置）
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
