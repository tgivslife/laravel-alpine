ARG ALPINE_VERSION=3.14
ARG PHP_VERSION=8.0.9
ARG INCLUDE_BUILD_TOOLS=false
ARG REPOS

FROM ${REPOS}php:${PHP_VERSION}-fpm-alpine${ALPINE_VERSION}

ARG INCLUDE_BUILD_TOOLS

ENV PHP_MAX_EXECUTION_TIME="30" \
    PHP_MEMORY_LIMIT="128M" \
    PHP_UPLOAD_MAX_FILESIZE="50M" \
    PHP_POST_MAX_SIZE="50M" \

    PHP_OPCACHE_ENABLE="1" \
    PHP_OPCACHE_ENABLE_CLI="1" \
    PHP_OPCACHE_REVALIDATE_FREQUENCY="0" \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="65407" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="512" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10" \
    PHP_OPCACHE_INTERNED_STRINGS_BUFFER="16" \

    PHP_FPM_PM_MAX_CHILDREN="50" \
    PHP_FPM_PM_START_SERVERS="20" \
    PHP_FPM_PM_MIN_SPARE_SERVER="10" \
    PHP_FPM_PM_MAX_SPARE_SERVERS="30" \

    NGINX_CLIENT_MAX_BODY_SIZE="50m" \
    NGINX_SET_REAL_IP_FROM="127.0.0.1" \

    LARAVEL_SCHEDULER_ENABLE="0" \
    LARAVEL_HORIZON_ENABLE="0"

# Add Build Dependencies | # Configure & Install Extension | # Remove Build Dependencies
RUN apk add --no-cache --virtual .build-deps \
      zlib-dev \
      libjpeg-turbo-dev \
      libpng-dev \
      libxml2-dev \
      bzip2-dev \
      postgresql-dev \
      libzip-dev \
      freetype-dev && \
    docker-php-ext-configure opcache --enable-opcache && \
    docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/ && \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql &&\
    docker-php-ext-configure zip && \
    docker-php-ext-install opcache \
      pdo_pgsql \
      pgsql \
      pdo \
      sockets \
      intl \
      gd \
      xml \
      bz2 \
      zip \
      pcntl \
      bcmath \
      exif && \
    docker-php-source delete && \
    apk del .build-deps && \
    apk add --no-cache libbz2 \
      libpq \
      libpng \
      libjpeg-turbo \
      freetype \
      icu-libs \
      libzip \
      supervisor \
      nginx

RUN if [ "$INCLUDE_BUILD_TOOLS" = true ] ; then apk add --no-cache git composer nodejs npm ; fi

# Configure php/php-fpm
COPY conf/php/php.ini $PHP_INI_DIR/
COPY conf/php/opcache.ini $PHP_INI_DIR/conf.d/
COPY conf/php-fpm/www.conf /usr/local/etc/php-fpm.d/

# Configure nginx
COPY conf/nginx/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx/default.conf /etc/nginx/http.d/default.conf

# Configure supervisor
COPY conf/supervisor/supervisord.conf /etc/supervisord.conf
COPY conf/supervisor/supervisor.d /etc/supervisor.d

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Setup Working Dir
WORKDIR /var/www/html

ENTRYPOINT ["sh", "/docker-entrypoint.sh"]
CMD supervisord -c /etc/supervisord.conf