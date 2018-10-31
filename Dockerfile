FROM php:7.2-fpm-alpine

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
RUN apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    argon2-dev \
    coreutils \
    curl-dev \
    libedit-dev \
    libressl-dev \
    libsodium-dev \
    libxml2-dev \
    sqlite-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    freetype-dev \
    libxpm-dev \
    && pecl install -o -f redis \
    && apk add --no-cache \
       bash \
       sed \
       nginx \
       supervisor \
       curl \
       libcurl \
       libpq \
       freetype \
       libxpm \
    && docker-php-ext-configure gd --with-jpeg-dir \
    --with-png-dir --with-zlib-dir --with-xpm-dir --with-freetype-dir \
    && apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv \
    && wget https://elasticache-downloads.s3.amazonaws.com/ClusterClient/PHP-7.0/latest-64bit \
    && tar --no-same-owner -zxvf latest-64bit \
    && mv artifact/amazon-elasticache-cluster-client.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718/ \
    && echo "extension=amazon-elasticache-cluster-client.so" | tee -a /usr/local/etc/php/conf.d/elasticache \
    && docker-php-ext-install gd mysqli opcache zip \
    && runDeps="$( \
        scanelf --needed --nobanner --recursive /usr/local \
                | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
                | sort -u \
                | xargs -r apk info --installed \
                | sort -u \
    )" \
    && apk add --virtual .wordpress-phpexts-rundeps $runDeps \
    && docker-php-ext-enable redis sodium \
    && docker-php-source delete \
    && rm -rf /tmp/pear /var/www/html/latest-64bit /var/www/html/artifact\
    && apk del .build-deps

COPY files/ /

EXPOSE 80 443

WORKDIR "/var/www/html"

CMD ["/start.sh"]
