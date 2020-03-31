FROM php:7.2-fpm-alpine3.11

RUN set -xe && \
    apk add --repository http://dl-3.alpinelinux.org/alpine/v3.11/main/ \
            --no-cache \
      icu \
      glib \
      libxrender \
      libxext \
      fontconfig \
      libpng \
      libjpeg-turbo \
      libzip-dev && \
    apk add --no-cache --virtual .build-deps \
      $PHPIZE_DEPS \
      zlib-dev \
      icu-dev \
      libpng-dev \
      libjpeg-turbo-dev \
      oniguruma-dev && \
    docker-php-ext-configure intl && \
    docker-php-ext-configure gd --with-png-dir=/usr/include/ \
                                --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-configure zip --with-libzip=/usr/include && \
    docker-php-ext-install pdo_mysql intl gd zip opcache && \
    apk del .build-deps && \
    rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/*
