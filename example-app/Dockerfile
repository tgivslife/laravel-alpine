ARG REGISTRY=docker.io/stsdockerhub
ARG LARAVEL_TRIXIE_VERSION=8.5.8-laravel-trixie

FROM ${REGISTRY}/php:${LARAVEL_TRIXIE_VERSION}-build AS build-container

WORKDIR /var/www/html

# copy app source code
COPY . .
COPY .env.example .env

# build source code
RUN composer install --no-dev --no-interaction --prefer-dist \
    && php artisan key:generate --force \
    && npm ci \
    && npm run build \
    && tar --owner=www-data --group=www-data --exclude=.git --exclude=docker --exclude=node_modules -czf /tmp/app.tar.gz .

###################################################################################################

FROM ${REGISTRY}/php:${LARAVEL_TRIXIE_VERSION}

WORKDIR /var/www/html

COPY --from=build-container /tmp/app.tar.gz .

RUN tar -xf app.tar.gz \
    && rm -rf app.tar.gz

# Configure entrypoint
COPY docker/docker-entrypoint.d /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/*
