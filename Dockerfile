FROM php:7.2-fpm-alpine

RUN set -xe && \
    apk add --repository http://dl-3.alpinelinux.org/alpine/edge/main/ \
            --no-cache \
      icu \
      glib \
      libxrender \
      libxext \
      fontconfig \
      libpng \
      libjpeg-turbo && \
    apk add --repository http://dl-3.alpinelinux.org/alpine/v3.8/main/ \
            --no-cache \
      libssl1.0 \
      libcrypto1.0 && \
    apk add --no-cache --virtual .php-deps \
      make && \
    apk add --no-cache --virtual .build-deps \
      $PHPIZE_DEPS \
      zlib-dev \
      icu-dev \
      libpng-dev \
      libjpeg-turbo-dev \
      g++ && \
    docker-php-ext-configure intl && \
    docker-php-ext-configure gd --with-png-dir=/usr/include/ \
                                --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install mbstring pdo_mysql intl gd && \
    apk del .php-deps .build-deps && \
    rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/*
