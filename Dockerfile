FROM php:7.2-fpm-alpine3.8

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
    && pecl install xdebug-2.6.0 \
    && apk add --no-cache \
       bash \
       sed \
       vim \
       git \
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
    && docker-php-ext-configure gd --with-jpeg-dir --with-png-dir --with-zlib-dir --with-xpm-dir --with-freetype-dir \
    && apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv \
    && cd /var/www \
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
    && mkdir -p -m 0700 /var/lib/nginx/.ssh \
    && echo "" > /var/lib/nginx/.ssh/config \
    && echo -e "Host *\n\tStrictHostKeyChecking no\n" >> /var/lib/nginx/.ssh/config \
    && ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa \
    && ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa \
    && ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa \
    && ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519 \
    && chmod go-rwx /etc/ssh/ssh_host_rsa_key \
    && chmod go-rwx /etc/ssh/ssh_host_dsa_key \
    && chmod go-rwx /etc/ssh/ssh_host_ecdsa_key \
    && chmod go-rwx /etc/ssh/ssh_host_ed25519_key \
    && mkdir -p /var/run/sshd \
    && rm -rf /tmp/pear /var/www/latest-64bit /var/www/artifact \
    && rm -rf /var/cache/apk/* /opt/installer \
    && rm -rf /usr/local/etc/php-fpm* \
    && apk del .build-deps \
    && chown -R www-data:www-data /var/www/* \
    && chmod 775 -R /var/www/* \
    && echo -e "ea01609e5cc4407f\nea01609e5cc4407f" | passwd nginx

COPY files/ /

STOPSIGNAL SIGTERM

EXPOSE 80 22

WORKDIR "/var/www"

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/sbin/runsvdir", "-P", "/etc/service"]
