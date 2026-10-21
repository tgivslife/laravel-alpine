ARG ALPINE_VERSION=3.24
ARG PHP_VERSION=8.5.12
ARG NGINX_VERSION=1.30.6-r1
ARG COMPOSER_VERSION=2.10.3
ARG REGISTRY=docker.io
ARG INCLUDE_BUILD_TOOLS=false

FROM ${REGISTRY}/php:${PHP_VERSION}-fpm-alpine${ALPINE_VERSION}

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
    NGINX_SET_REAL_IP_FROM="127.0.0.1" \
    NGINX_WORKER_RLIMIT_NOFILE="65535" \
    NGINX_WORKER_CONNECTIONS="4096"

# Add Build Dependencies | # Configure & Install Extension | # Remove Build Dependencies | # Add runtime deps
RUN apk add --no-cache tzdata \
      libbz2 \
      libpq \
      libpng \
      libjpeg-turbo \
      freetype \
      icu-libs \
      libzip \
      supervisor \
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
    && docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/ \
    && docker-php-ext-configure pgsql --with-pgsql=/usr/local/pgsql \
    && docker-php-ext-configure zip \
    && pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis \
    && docker-php-ext-install pdo \
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

# Declared here, not after FROM, so an nginx update reuses the extension layer above from cache.
ARG NGINX_VERSION

# nginx from the nginx.org stable repository, which gets security releases sooner than Alpine's own package. Its signing
# key must match the checksum pinned by the official nginx image. The package adds the nginx user to www-data, so the
# workers can use the php-fpm socket; its default vhost goes, as conf.d is included in the main context here.
RUN curl -fsSL -o /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
    && echo "e09fa32f0a0eab2b879ccbbc4d0e4fb9751486eedda75e35fac65802cc9faa266425edf83e261137a2f4d16281ce2c1a5f4502930fe75154723da014214f0655 */tmp/nginx_signing.rsa.pub" | sha512sum -c - \
    && mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/ \
    && apk add --no-cache -X "https://nginx.org/packages/alpine/v$(grep -oE '^[0-9]+\.[0-9]+' /etc/alpine-release)/main" \
      nginx="${NGINX_VERSION}" \
    && id -nG nginx | grep -qw www-data \
    && rm -f /etc/nginx/conf.d/default.conf \
    && nginx -v

# Declared here, not after FROM, so the -build variant reuses the layers above from cache.
ARG INCLUDE_BUILD_TOOLS
ARG COMPOSER_VERSION

RUN if [ "$INCLUDE_BUILD_TOOLS" = true ] ; then \
      php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
      && apk add --no-cache git make nodejs npm ; \
    fi

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

# Configure entrypoint
COPY --chmod=755 conf/docker-entrypoint.d /docker-entrypoint.d/
COPY --chmod=755 docker-entrypoint.sh /

WORKDIR /var/www/html

EXPOSE 80

# Probes nginx -> unix socket -> php-fpm in one request, so it fails if any link in the chain is down.
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD wget -qO- http://127.0.0.1/ping || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisord.conf"]