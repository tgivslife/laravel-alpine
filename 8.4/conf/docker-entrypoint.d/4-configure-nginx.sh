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
  sed -i -e 's|^\([[:space:]]*\)set_real_ip_from .*$|\1set_real_ip_from '"${NGINX_SET_REAL_IP_FROM}"';|g' "$NGINX_CONF_FILE"
  sed -i -e 's|^\([[:space:]]*\)worker_rlimit_nofile .*$|\1worker_rlimit_nofile '"${NGINX_WORKER_RLIMIT_NOFILE}"';|g' "$NGINX_CONF_FILE"
  sed -i -e 's|^\([[:space:]]*\)worker_connections .*$|\1worker_connections '"${NGINX_WORKER_CONNECTIONS}"';|g' "$NGINX_CONF_FILE"
  sed -i -e 's|^\([[:space:]]*\)fastcgi_read_timeout .*$|\1fastcgi_read_timeout '"${NGINX_FASTCGI_READ_TIMEOUT}"';|g' "$NGINX_CONF_FILE"
  sed -i -e 's|^\([[:space:]]*\)client_max_body_size .*$|\1client_max_body_size '"${NGINX_CLIENT_MAX_BODY_SIZE}"';|g' "$NGINX_CONF_FILE"
}

log "Configure nginx started"
nginx
log "Configure nginx finished"
