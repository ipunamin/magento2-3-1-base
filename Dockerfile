FROM php:7.2.11-apache
MAINTAINER Ipun Amin <ipun.amin@gmail.com>

RUN apt-get update \
  && apt-get install -y \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxslt1-dev \
    git \
    vim \
    wget \
    lynx \
    psmisc \
    nodejs \
    mysql-server \ 
  && apt-get clean

RUN docker-php-ext-configure \
    gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/; \
  docker-php-ext-install \
    gd \
    intl \
    mbstring \
    pdo_mysql \
    xsl \
    zip \
    opcache \
    bcmath \
    soap

RUN apt-get update \
    && apt-get install -y libmcrypt-dev \
    && yes '' | pecl install mcrypt-1.0.1 \
    && echo 'extension=mcrypt.so' > /usr/local/etc/php/conf.d/mcrypt.ini

RUN a2enmod rewrite
RUN echo "memory_limit=2048M" > /usr/local/etc/php/conf.d/memory-limit.ini

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV ROOT_DOCUMENT /var/www/html/
COPY src /var/www/html/

RUN cd $ROOT_DOCUMENT \
	&& chmod -R 0777 Magento-CE-2-3-1/var \
	&& chmod -R 0777 Magento-CE-2-3-1/pub \
	&& chmod -R 0777 Magento-CE-2-3-1/generated

RUN chown -R www-data:www-data $ROOT_DOCUMENT
