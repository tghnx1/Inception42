FROM alpine:3.23.3

ARG PHP_VERSION=83

RUN apk add --no-cache \
    #Base PHP runtime. Required -  without it nothing runs.
    php${PHP_VERSION} \
    #PHP FastCGI Process Manager. Required if you use Nginx (standard Docker setup). 
	# listens on port 9000;
	# executes PHP scripts; 
        # isolates PHP from web server
    php${PHP_VERSION}-fpm \
    #MySQL/MariaDB driver.
    php${PHP_VERSION}-mysqli \
    #JSON parsing. WordPress core + REST API + plugins rely on JSON.
    php${PHP_VERSION}-json \
    #HTTP requests. Required for:
    	#plugin/theme downloads
    	#external APIs
    	#WordPress updates
    	#REST integrations
    php${PHP_VERSION}-curl \
    #Required by XML features
    php${PHP_VERSION}-dom \
    #Remove - images may upload rotated
    php${PHP_VERSION}-exif \
    #verify types of uploaded media. Secure reasons.
    php${PHP_VERSION}-fileinfo \
    #Removeâ- broken characters, plugin failures
    php${PHP_VERSION}-mbstring \
    #Remove - WordPress cannot fetch updates
    php${PHP_VERSION}-openssl \
    #XML handling
    php${PHP_VERSION}-xml \
    #Remove - cannot install plugins from dashboard
    php${PHP_VERSION}-zip \
    netcat-openbsd \
    #For the automatoc wp installation
    php${PHP_VERSION}-phar \
    wget unzip

# Configure PHP-FPM to listen on port 9000 (for Docker networking)
RUN sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" /etc/php${PHP_VERSION}/php-fpm.d/www.conf

# Symlink php83 -> php (wp-cli needs 'php' in PATH)
RUN ln -s /usr/bin/php83 /usr/local/bin/php

# Install wp-cli
RUN wget -O /tmp/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && php /tmp/wp-cli.phar --info \
    && mv /tmp/wp-cli.phar /usr/local/bin/wp \
    && chmod +x /usr/local/bin/wp

WORKDIR /usr/src

# Download WordPress
RUN wget https://wordpress.org/latest.zip \
 && unzip latest.zip \
 && rm latest.zip

# Copy entrypoint script that will generate wp-config at runtime
COPY conf/wp-config-create.sh /wp-config-create.sh
RUN chmod +x /wp-config-create.sh

ENTRYPOINT ["/wp-config-create.sh"]
CMD ["/usr/sbin/php-fpm83", "-F"]

