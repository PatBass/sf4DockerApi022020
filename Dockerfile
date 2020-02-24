FROM php:fpm-alpine as base

ENV WORKPATH "/var/www/api022020"
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS icu-dev postgresql-dev libzip-dev gnupg graphviz make autoconf git zlib-dev curl chromium go \
    && docker-php-ext-configure pgsql --with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install zip intl pdo_pgsql pdo_mysql opcache json pgsql mysqli \
    && pecl install apcu redis \
    && docker-php-ext-enable apcu mysqli redis 

#Custom php configuration
COPY ./docker/php/conf/dev/php.ini /usr/local/etc/php/php.ini

#Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN wget https://cs.symfony.com/download/php-cs-fixer-v2.phar -o php-cs-fixer \
    && chmod a+x php-cs-fixer \
    && mv php-cs-fixer /usr/local/bin/php-cs-fixer \
    && curl --insecure -LS https://get.sensiolabs.de/deptrac.phar -o deptrac.phar \
    && chmod a+x deptrac.phar \
    && mv deptrac.phar /usr/local/bin/deptrac
    
RUN mkdir -p ${WORKPATH}    

RUN rm -rf ${WORKPATH}/vendor \
    && ls -l ${WORKPATH}
    
RUN mkdir -p ${WORKPATH}/var \
    && mkdir ${WORKPATH}/var/cache \
    && mkdir ${WORKPATH}/var/logs \
    && mkdir ${WORKPATH}/var/sessions \
    && chown -R www-data ${WORKPATH}/var \
    && chown -R www-data /tmp
    
RUN chown www-data:www-data -R ${WORKPATH}

WORKDIR ${WORKPATH}

COPY . ./        

EXPOSE 9000
CMD ["php-fpm"]

#Production environment
FROM base

COPY ./docker/php/conf/prod/php.ini /usr/local/etc/php/php.ini
