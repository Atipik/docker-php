FROM marmotz/debian-fr

USER root

ADD init_php.sh /

# PHP
RUN echo 'deb http://packages.dotdeb.org jessie all' | tee /etc/apt/sources.list.d/dotdeb.list && \
    wget -O- -q https://www.dotdeb.org/dotdeb.gpg | apt-key add - && \
    apt-get update -y && \
    apt-get install -y --force-yes php-cli php-mysql php-json php-xsl php-intl php7.0-xdebug php-curl php-gd php7.0-apcu php-pear

# Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer

# Xdebug
ADD xdebug.ini /etc/php5/mods-available/xdebug.ini
RUN php5enmod xdebug

# TIMEZONE in php
RUN sed -i "s@^;date.timezone =.*@date.timezone = $TIMEZONE@" /etc/php/7.0/cli/php.ini

# DEV conf for php
RUN sed -i "s@^error_reporting =.*@error_reporting = E_ALL@" /etc/php/7.0/cli/php.ini
RUN sed -i "s@^display_errors =.*@display_errors = On@" /etc/php/7.0/cli/php.ini
RUN sed -i "s@^display_startup_errors =.*@display_startup_errors = On@" /etc/php/7.0/cli/php.ini

# Clean
RUN rm -rf /var/lib/apt/lists/*

USER nonrootuser

VOLUME [ "/var/php" ]
WORKDIR /var/php
CMD ["/init_php.sh"]
