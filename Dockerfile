FROM alpine:edge
MAINTAINER Dmytro Shavaryn <shavarynd@gmail.com>

#Install PHP7 with needed exstentions and composer.
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --update \
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
    && rm -fr /var/cache/apk/* \
    && ln -s /usr/bin/php7 /usr/bin/php \
    && curl -sS https://getcomposer.org/installer | php -- --filename=composer \
    --install-dir=/usr/bin --version=1.0.0 \

# Install Behat.
WORKDIR /srv
ADD composer.json composer.json
RUN composer install \
    && rm composer.lock

# ADD behat.yml and features folder.
ADD behat.yml behat.yml \
    features/ features/

# Initialize Behat.
WORKDIR /srv/bin
RUN behat --init

# Copy entrypoint.sh script.
COPY entrypoint.sh /entrypoint.sh

WORKDIR /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["--format=pretty", "--out=std", "--format=cucumber_json", "--out=std"]
