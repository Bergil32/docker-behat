FROM debian:jessie
MAINTAINER Dmytro Shavaryn <shavarynd@gmail.com>

# Update and install packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get install -y curl git \
    && apt-get install -y -q php5-cli \
    php5-curl \
    php5-mysqlnd

# Create "behat" user with password crypted "behat"
RUN useradd -d /home/behat -m -s /bin/bash behat \
    && echo "behat:behat" | chpasswd

# Behat alias in docker container
ADD behat /home/behat/behat
RUN chmod +x /home/behat/behat \

    && mkdir -p /home/behat/data/build/html/behat/ \

# Fix permissions
    && chown -R behat:behat /home/behat \

# Add "behat" to "sudoers"
    && echo "behat        ALL=(ALL:ALL) ALL" >> /etc/sudoers

USER behat
WORKDIR /home/behat
ENV HOME /home/behat
ENV PATH $PATH:/home/behat

# Install Behat
RUN mkdir /home/behat/composer
ADD composer.json /home/behat/composer/composer.json
RUN cd /home/behat/composer && curl http://getcomposer.org/installer | php \
    && cd /home/behat/composer && php composer.phar install --prefer-source
ADD behat.yml /home/behat/behat.yml
ADD features/ /home/behat/features
ADD reports/ /home/behat/build/test
