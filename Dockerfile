FROM alpine:edge
MAINTAINER Dmytro Shavaryn <shavarynd@gmail.com>

# Install PHP7 with needed exstentions, composer with hirak/prestissimo and imagemagick.
RUN apk add --no-cache \
    php7 \
    php7-dom \
    php7-curl \
    php7-json \
    php7-phar \
    php7-openssl \
    php7-mbstring \
    php7-ctype \
    php7-pdo_mysql \
    php7-session \
    curl \
    autoconf \
    g++ \
    imagemagick-dev \
    libtool \
    make \
    && rm -fr /var/cache/apk/* \
    && ln -s /usr/bin/php7 /usr/bin/php \
    && curl -sS https://getcomposer.org/installer | php -- --filename=composer \
    --install-dir=/usr/bin \
    && composer global require "hirak/prestissimo:^0.3"
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && apk del autoconf g++ libtool make

# Add files and folders to container.
ADD ["composer.json", "entrypoint.sh", "/srv/"]
WORKDIR /srv

# Install and initialize Behat, create folder for artifacts.
RUN composer install \
    && bin/behat --init \
    && mkdir -p artifacts

ENTRYPOINT ["/srv/entrypoint.sh"]
