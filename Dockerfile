FROM php:7.0.32-fpm-alpine3.7

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so
RUN set -ex; \
    apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    #argon2-dev \
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
    libmcrypt-dev \
    bzip2-dev \
    gettext-dev \
    gmp-dev \
    libxslt-dev \
    && apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv \
    && apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community php7-pecl-igbinary \
    && apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/main argon2-dev \
    && apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/main apk-cron \
    && pecl channel-update pecl.php.net \
    && pecl install -o -f igbinary \
    && pecl install -o -f xdebug \
    && pecl install -o -f mcrypt \
    && pecl install -o -f redis \
    && pecl install -o -f libsodium \
    && apk add --no-cache \
       bash \
       sed \
       vim \
       git \
       python3 \
       openssh-server \
       openssh-client \
       nginx \
       ca-certificates \
       runit \
       dumb-init \
       curl \
       libcurl \
       libpq \
       freetype \
       libxpm \
       shadow \
    && pip3 install --upgrade pip \
    && pip3 install --upgrade awscli \
    && cd /var/www \
    && wget https://elasticache-downloads.s3.amazonaws.com/ClusterClient/PHP-7.0/latest-64bit \
    && tar --no-same-owner -zxvf latest-64bit \
    && mv artifact/amazon-elasticache-cluster-client.so /usr/local/lib/php/extensions/no-debug-non-zts-20151012/ \
    && echo "extension=amazon-elasticache-cluster-client.so" | tee -a /usr/local/etc/php/conf.d/elasticache \
    && docker-php-ext-configure gd --with-jpeg-dir --with-png-dir --with-zlib-dir --with-xpm-dir --with-freetype-dir \
    && docker-php-ext-install gd mysqli opcache zip bz2 exif gettext gmp shmop soap sysvmsg sysvsem sysvshm xsl \
    && runDeps="$( \
        scanelf --needed --nobanner --recursive /usr/local \
                | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
                | sort -u \
                | xargs -r apk info --installed \
                | sort -u \
    )" \
    && apk add --virtual .wordpress-phpexts-rundeps $runDeps \
    && docker-php-ext-enable redis sodium gd mysqli opcache zip bz2 exif gettext gmp igbinary mcrypt shmop soap sysvmsg sysvsem sysvshm xsl \
    && docker-php-source delete \
    && mkdir -p /var/run/sshd \
    && ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa \
    && ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa \
    && ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa \
    && ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519 \
    && chmod go-rwx /etc/ssh/ssh_host_rsa_key \
                    /etc/ssh/ssh_host_dsa_key \
                    /etc/ssh/ssh_host_ecdsa_key \
                    /etc/ssh/ssh_host_ed25519_key \
    && mkdir -p /var/www/.ssh \
    && touch /var/www/.ssh/authorized-keys \
    && chmod -R go-rwx /var/www/.ssh \
    && touch /var/log/script.log \
    && chown root:root /var /var/www \
    && chown nginx:nginx /var/www/.ssh /var/www/.ssh/authorized-keys \
    && chown nginx:nginx /var/www/html \
    && rm -rf /tmp/pear /var/www/latest-64bit /var/www/artifact /var/www/localhost \
    && rm -rf /var/cache/apk/* /opt/installer \
    && rm -rf /usr/local/etc/php-fpm* \
    && apk del .build-deps


COPY files/ /

STOPSIGNAL SIGTERM

EXPOSE 80 22

WORKDIR "/var/www"

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/start.sh"]
