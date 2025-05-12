ARG ALPINE_VERSION=3.21
ARG PHP_VERSION=8.4.7
ARG REGISTRY=docker.io
ARG INCLUDE_BUILD_TOOLS=false

FROM ${REGISTRY}/php:${PHP_VERSION}-fpm-alpine${ALPINE_VERSION}

ARG INCLUDE_BUILD_TOOLS

ENV TZ="Europe/Bucharest" \
    \
    LARAVEL_SCHEDULER_ENABLE="1" \
    LARAVEL_HORIZON_ENABLE="0" \
    \
    PHP_MAX_EXECUTION_TIME="60" \
    PHP_MEMORY_LIMIT="128M" \
    PHP_UPLOAD_MAX_FILESIZE="50M" \
    PHP_POST_MAX_SIZE="50M" \
    \
    PHP_OPCACHE_ENABLE="1" \
    PHP_OPCACHE_ENABLE_CLI="1" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="512" \
    PHP_OPCACHE_INTERNED_STRINGS_BUFFER="128" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="65406" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="15" \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_SAVE_COMMENTS="1" \
    \
    PHP_FPM_PM_MAX_CHILDREN="50" \
    PHP_FPM_PM_START_SERVERS="20" \
    PHP_FPM_PM_MIN_SPARE_SERVER="10" \
    PHP_FPM_PM_MAX_SPARE_SERVERS="30" \
    \
    NGINX_FASTCGI_READ_TIMEOUT="60s" \
    NGINX_CLIENT_MAX_BODY_SIZE="50m" \
    NGINX_SET_REAL_IP_FROM="127.0.0.1"

# Add Build Dependencies | # Configure & Install Extension | # Remove Build Dependencies
RUN apk update \
    && apk add --no-cache tzdata \
    && apk add --no-cache --virtual .build-deps \
      zlib-dev \
      libjpeg-turbo-dev \
      libpng-dev \
      libxml2-dev \
      bzip2-dev \
      postgresql-dev \
      libzip-dev \
      freetype-dev \
      autoconf \
      icu-dev \
      gcc g++ \
      make \
      linux-headers \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/ \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-configure zip \
    && pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis \
    && docker-php-ext-install opcache \
      pdo \
      pdo_pgsql \
      pgsql \
      pdo_mysql \
      mysqli \
      sockets \
      intl \
      gd \
      xml \
      bz2 \
      zip \
      pcntl \
      bcmath \
      exif \
    && docker-php-source delete \
    && apk del .build-deps
RUN apk add --no-cache libbz2 \
      libpq \
      libpng \
      libjpeg-turbo \
      freetype \
      icu-libs \
      libzip \
      supervisor \
      nginx

RUN if [ "$INCLUDE_BUILD_TOOLS" = true ] ; then \
      php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin --filename=composer --version=2.8.8 \
      && apk add --no-cache git make nodejs npm ; \
    fi

# Configure php/php-fpm
COPY conf/php/php.ini $PHP_INI_DIR/
COPY conf/php/opcache.ini $PHP_INI_DIR/conf.d/
COPY conf/php-fpm/www.conf /usr/local/etc/php-fpm.d/

# Configure nginx
COPY conf/nginx/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx/default.conf /etc/nginx/http.d/default.conf
RUN addgroup nginx www-data

# Configure supervisor
COPY conf/supervisor/supervisord.conf /etc/supervisord.conf
COPY conf/supervisor/supervisor.d /etc/supervisor.d

# Configure entrypoint
COPY conf/docker-entrypoint.d /docker-entrypoint.d/
COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.d/* \
    && chmod +x /docker-entrypoint.sh

WORKDIR /var/www/html

EXPOSE 80
ENTRYPOINT ["sh", "/docker-entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisord.conf"]