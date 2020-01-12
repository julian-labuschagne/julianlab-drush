###
# Download and build composer
###

FROM php:7.3.11-apache-stretch
MAINTAINER Julian Labuschagne "julian.labuschagne@gmail.co.za"
ENV REFRESHED_AT 2021-01-08

# Create a non privileged user
RUN groupadd -g 1000 php && \
    useradd -r -u 1000 -g php php

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
      wget \
      git-core \
      unzip \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libpng-dev \
      libzip-dev

RUN docker-php-ext-install -j$(nproc) opcache mysqli pdo_mysql zip && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install -j$(nproc) gd

# Copy the custom php.ini file
COPY conf/php/ $PHP_INI_DIR/

RUN wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar && \
    mv drush.phar /usr/local/bin/drush && \
    chmod 755 /usr/local/bin/drush


WORKDIR /home/php
USER php
VOLUME /home/php

CMD ['/usr/local/bin/drush']
