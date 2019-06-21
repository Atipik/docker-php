FROM marmotz/debian-fr

USER root

ADD init_php.sh /

# Add repo for php 7.3
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
RUN apt-get install -y --force-yes php7.3-cli php7.3-mysql php7.3-json php7.3-xsl php7.3-intl php7.3-xdebug \
                                   php7.3-curl php7.3-gd php7.3-apcu php7.3-mbstring php7.3-zip

# Xdebug
ADD xdebug.ini /etc/php/7.3/cli/conf.d/20-xdebug.ini

# Default php conf
RUN sed -i "s@^;date.timezone =.*@date.timezone = $TIMEZONE@" /etc/php/7.3/cli/php.ini

# DEV conf for php
RUN sed -i "s@^error_reporting =.*@error_reporting = E_ALL@" /etc/php/7.3/cli/php.ini
RUN sed -i "s@^display_errors =.*@display_errors = On@" /etc/php/7.3/cli/php.ini
RUN sed -i "s@^display_startup_errors =.*@display_startup_errors = On@" /etc/php/7.3/cli/php.ini

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
