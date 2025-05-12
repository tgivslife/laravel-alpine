#!/bin/sh

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

#---------------------------------------------------------------------
# configurations
#---------------------------------------------------------------------

function nginx() {
  NGINX_CONF_FILE="/etc/nginx/nginx.conf"
  sed -i -e 's|client_max_body_size .*$|client_max_body_size '"${NGINX_CLIENT_MAX_BODY_SIZE}"';|g' "$NGINX_CONF_FILE"
  sed -i -e 's|set_real_ip_from .*$|set_real_ip_from '"${NGINX_SET_REAL_IP_FROM}"';|g' "$NGINX_CONF_FILE"
}

echo "$(timestamp) Configure nginx started"
nginx
echo "$(timestamp) Configure nginx finished"
