FROM alpine:edge
MAINTAINER Dmytro Shavaryn <shavarynd@gmail.com>

#Install PHP7 with needed exstentions and composer.
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --update php7@testing \
    php7-dom@testing \
    php7-curl@testing \
    php7-json@testing \
    php7-phar@testing \
    php7-openssl@testing \
    php7-mbstring@testing \
    php7-ctype@testing \
    php7-pdo_mysql@testing \
    curl \
    && rm -fr /var/cache/apk/* \
    && ln -s /usr/bin/php7 /usr/bin/php \
    && curl -sS https://getcomposer.org/installer | php -- --filename=composer \
    --install-dir=/usr/bin --version=1.0.0 \

# Install Behat.
WORKDIR /srv
ADD composer.json composer.json
RUN composer install \
    && rm composer.lock
ADD behat.yml /srv/behat.yml
ADD features/ /srv/features

# Create folder for reports.
RUN mkdir -p artefacts/

# Initialize Behat.
WORKDIR /srv/bin
RUN behat --init

# Run behat and change permissions for reports folder.
WORKDIR /srv
CMD behat --format=pretty --out=std --format=cucumber_json --out=std ; chmod -R 777 artefacts/
