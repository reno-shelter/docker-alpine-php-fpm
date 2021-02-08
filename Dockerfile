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
    docker-php-ext-enable opcache

# wkhtmltopdf
RUN apt-get -y install xfonts-75dpi xfonts-base gvfs colord glew-utils libvisual-0.4-plugins gstreamer1.0-tools \
    opus-tools qt5-image-formats-plugins qtwayland5 qt5-qmltooling-plugins librsvg2-bin lm-sensors && \
    curl -LO https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb && \
    dpkg -i wkhtmltox_0.12.5-1.stretch_amd64.deb && \
    cp /usr/local/bin/wkhtmlto* /usr/bin/ && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* aws* /tmp/*.deb
