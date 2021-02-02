FROM php:7.4-fpm

RUN apt-get update && \
    apt-get -y install libbz2-dev libzip-dev libpng-dev libgmp3-dev libicu-dev libjpeg62-turbo-dev libfreetype6-dev sudo \
    libxrender1 libfontconfig1 libxext6 fonts-ipafont git locales cron procps unzip wkhtmltopdf && \
    curl https://s3.ap-northeast-1.amazonaws.com/amazon-ssm-ap-northeast-1/latest/debian_amd64/amazon-ssm-agent.deb -o /tmp/amazon-ssm-agent.deb && \
    dpkg -i /tmp/amazon-ssm-agent.deb && \
    curl -L https://github.com/DataDog/dd-trace-php/releases/download/0.46.0/datadog-php-tracer_0.46.0_amd64.deb -o /tmp/datadog-php-tracer.deb && \
    dpkg -i /tmp/datadog-php-tracer.deb && \
    cp /etc/amazon/ssm/seelog.xml.template /etc/amazon/ssm/seelog.xml && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip " -o "awscliv2.zip" && /usr/bin/unzip awscliv2.zip && ./aws/install && \
    docker-php-ext-install mysqli pdo_mysql bz2 gd zip gmp intl && \
    docker-php-ext-configure gd --with-freetype --with-jpeg  && \
    docker-php-ext-install -j$(nproc) gd && \
    set -x && \
    docker-php-ext-install opcache && \
    docker-php-ext-enable opcache && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* aws* /tmp/*.deb
