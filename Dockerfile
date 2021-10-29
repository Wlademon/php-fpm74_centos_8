FROM centos:8
RUN yum update -y

RUN yum -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
RUN yum install -y epel-release yum-utils
RUN dnf module reset php
RUN dnf module enable php:remi-7.4 -y
RUN yum -y update

RUN yum install -y  \
    vim \
    php \
    curl \
    htop \
    php-fpm \
    php-xml \
    php-cli \
    php-bcmath \
    php-dba \
    php-gd \
    php-zip \
    php-intl \
    php-mbstring \
    php-mysql \
    php-pdo \
    php-soap \
    php-pecl-apcu \
    php-pecl-imagick

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN groupadd -g 1000 www-data;
RUN useradd -M -d /var/www -u 1000 -g 1000 -s /bin/false www-data
RUN usermod -G www-data www-data

RUN mkdir -p /run/php-fpm && \
    chown www-data:www-data /run/php-fpm

RUN mkdir -p /var/lib/php/session && \
    chown www-data:www-data /var/lib/php/session

RUN mkdir -p /var/www && \
    chown www-data:www-data /var/www

RUN chmod 777 /var/run

COPY ./files/php-fpm.conf /etc/php-fpm.conf
COPY ./files/overrides.conf /etc/overrides.conf
COPY ./files/www.conf /etc/php-fpm.d/www.conf
COPY ./files/php.ini /etc/php.ini
COPY ./files/sleep.sh /etc/sleep.sh
RUN yum clean all

STOPSIGNAL SIGQUIT

WORKDIR /var/www/html

EXPOSE 9000

USER www-data

CMD ["php-fpm", "-F", "-R"]

RUN yum clean all

