FROM php:7.4-fpm

RUN apt-get update && apt-get -y install libbz2-dev libzip-dev libpng-dev libgmp3-dev libicu-dev libjpeg62-turbo-dev libfreetype6-dev \
    libxrender1 libfontconfig1 libxext6 fonts-ipafont git vim locales && \
    docker-php-ext-install mysqli pdo_mysql bz2 gd zip gmp intl && \
    docker-php-ext-configure gd --with-freetype --with-jpeg  && \
    docker-php-ext-install -j$(nproc) gd && \
    pecl install pcov && docker-php-ext-enable pcov && \
    apt-get clean

RUN cd /opt && curl -LO https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz && \
    tar vxf wkhtmltox-0.12.3_linux-generic-amd64.tar.xz && \
    cp wkhtmltox/bin/wk* /usr/local/bin/

RUN set -x \
  && docker-php-ext-install opcache \
  && docker-php-ext-enable opcache
