ARG UBUNTU_VERSION=22.04
ARG PHP_VERSION=8.1.10
ARG NODE_VERSION=16
ARG REGISTRY=docker.io
ARG INCLUDE_BUILD_TOOLS=false

FROM ${REGISTRY}/ubuntu:${UBUNTU_VERSION}

LABEL maintainer="Teodor Ion"

WORKDIR /var/www/html

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       php8.1-fpm \
       supervisor \
       nginx

# Configure nginx
COPY conf/nginx/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx/default.conf /etc/nginx/http.d/default.conf
RUN chown -Rf www-data:www-data /var/lib/nginx

# Configure supervisor
COPY conf/supervisor/supervisord.conf /etc/supervisord.conf
COPY conf/supervisor/supervisor.d /etc/supervisor.d

# Configure entrypoint
COPY conf/docker-entrypoint.d /docker-entrypoint.d/
COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.d/* \
    && chmod +x /docker-entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["sh", "/docker-entrypoint.sh"]
CMD supervisord -c /etc/supervisord.conf