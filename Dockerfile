FROM php:7.1.0-apache 
RUN apt-get update
RUN apt-get install -y \
    zip unzip curl git \
    libfreetype6-dev libjpeg62-turbo-dev \
    libmcrypt-dev libpng12-dev

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
  php composer-setup.php --install-dir=/usr/bin --filename=composer && \
  php -r "unlink('composer-setup.php');"

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
                                --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd &&
  docker-php-ext-install mysqli

RUN cd /tmp && \
    git clone https://github.com/alextselegidis/easyappointments && \
    cd easyappointments && \
    /usr/bin/composer install && \
    cd src && cp -fdr * /var/www/html/

ADD config.php /var/www/html/config.php

