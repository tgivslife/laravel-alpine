#!/bin/sh

# Fail fast: a failed sed must abort container startup instead of booting with wrong config.
set -e

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

log() {
  echo "$(timestamp) $*"
}

#---------------------------------------------------------------------
# configurations
#---------------------------------------------------------------------

nginx() {
  NGINX_CONF_FILE="/etc/nginx/nginx.conf"
  sed -i -e 's|set_real_ip_from .*$|set_real_ip_from '"${NGINX_SET_REAL_IP_FROM}"';|g' "$NGINX_CONF_FILE"
  sed -i -e 's|worker_rlimit_nofile .*$|worker_rlimit_nofile '"${NGINX_WORKER_RLIMIT_NOFILE}"';|g' "$NGINX_CONF_FILE"
  sed -i -e 's|worker_connections .*$|worker_connections '"${NGINX_WORKER_CONNECTIONS}"';|g' "$NGINX_CONF_FILE"
  sed -i -e 's|fastcgi_read_timeout .*$|fastcgi_read_timeout '"${NGINX_FASTCGI_READ_TIMEOUT}"';|g' "$NGINX_CONF_FILE"
  sed -i -e 's|client_max_body_size .*$|client_max_body_size '"${NGINX_CLIENT_MAX_BODY_SIZE}"';|g' "$NGINX_CONF_FILE"
}

log "Configure nginx started"
nginx
log "Configure nginx finished"
