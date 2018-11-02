FROM marmotz/debian-fr

USER root

ADD init_php.sh /

# Add repo for php 7.2
RUN apt-get update -y && \
    apt-get -y install --force-yes apt-transport-https lsb-release ca-certificates && \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' && \
    apt-get update -y

# Upgrade PECL
# RUN apt-get update -y && \
#     apt-get install -y --force-yes php-pear && \
#     pear upgrade

# PHP
RUN apt-get install -y --force-yes php7.2-cli php7.2-mysql php7.2-json php7.2-xsl php7.2-intl php7.2-xdebug \
                                   php7.2-curl php7.2-gd php7.2-apcu php7.2-mbstring php7.2-zip

# Xdebug
ADD xdebug.ini /etc/php/7.2/cli/conf.d/20-xdebug.ini

# Default php conf
RUN sed -i "s@^;date.timezone =.*@date.timezone = $TIMEZONE@" /etc/php/7.2/cli/php.ini

# DEV conf for php
RUN sed -i "s@^error_reporting =.*@error_reporting = E_ALL@" /etc/php/7.2/cli/php.ini
RUN sed -i "s@^display_errors =.*@display_errors = On@" /etc/php/7.2/cli/php.ini
RUN sed -i "s@^display_startup_errors =.*@display_startup_errors = On@" /etc/php/7.2/cli/php.ini

# Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer

# Mysql client
RUN apt-get install -y mysql-client

# Clean
RUN rm -rf /var/lib/apt/lists/*

USER nonrootuser

VOLUME [ "/var/php" ]
WORKDIR /var/php
CMD ["/init_php.sh"]
