#!/bin/sh

#---------------------------------------------------------------------
# configure php-fpm
#---------------------------------------------------------------------

function php() {
  PHP_INI_FILE="/usr/local/etc/php/php.ini"
  sed -i -e 's|{{PHP_MAX_EXECUTION_TIME}}|'"${PHP_MAX_EXECUTION_TIME}"'|g' "$PHP_INI_FILE"
  sed -i -e 's|{{PHP_MEMORY_LIMIT}}|'"${PHP_MEMORY_LIMIT}"'|g' "$PHP_INI_FILE"
  sed -i -e 's|{{PHP_UPLOAD_MAX_FILESIZE}}|'"${PHP_UPLOAD_MAX_FILESIZE}"'|g' "$PHP_INI_FILE"
  sed -i -e 's|{{PHP_POST_MAX_SIZE}}|'"${PHP_POST_MAX_SIZE}"'|g' "$PHP_INI_FILE"
}

function php_opcache() {
  PHP_INI_OPCACHE_FILE="/usr/local/etc/php/conf.d/opcache.ini"
  sed -i -e 's|{{PHP_OPCACHE_ENABLE}}|'"${PHP_OPCACHE_ENABLE}"'|g' "$PHP_INI_OPCACHE_FILE"
  sed -i -e 's|{{PHP_OPCACHE_ENABLE_CLI}}|'"${PHP_OPCACHE_ENABLE_CLI}"'|g' "$PHP_INI_OPCACHE_FILE"
  sed -i -e 's|{{PHP_OPCACHE_REVALIDATE_FREQUENCY}}|'"${PHP_OPCACHE_REVALIDATE_FREQUENCY}"'|g' "$PHP_INI_OPCACHE_FILE"
  sed -i -e 's|{{PHP_OPCACHE_VALIDATE_TIMESTAMPS}}|'"${PHP_OPCACHE_VALIDATE_TIMESTAMPS}"'|g' "$PHP_INI_OPCACHE_FILE"
  sed -i -e 's|{{PHP_OPCACHE_MAX_ACCELERATED_FILES}}|'"${PHP_OPCACHE_MAX_ACCELERATED_FILES}"'|g' "$PHP_INI_OPCACHE_FILE"
  sed -i -e 's|{{PHP_OPCACHE_MEMORY_CONSUMPTION}}|'"${PHP_OPCACHE_MEMORY_CONSUMPTION}"'|g' "$PHP_INI_OPCACHE_FILE"
  sed -i -e 's|{{PHP_OPCACHE_MAX_WASTED_PERCENTAGE}}|'"${PHP_OPCACHE_MAX_WASTED_PERCENTAGE}"'|g' "$PHP_INI_OPCACHE_FILE"
  sed -i -e 's|{{PHP_OPCACHE_INTERNED_STRINGS_BUFFER}}|'"${PHP_OPCACHE_INTERNED_STRINGS_BUFFER}"'|g' "$PHP_INI_OPCACHE_FILE"
}

function php_fpm() {
  PHP_FPM_CONF_FILE="/usr/local/etc/php-fpm.d/www.conf"
  sed -i -e 's|{{PHP_FPM_PM_MAX_CHILDREN}}|'"${PHP_FPM_PM_MAX_CHILDREN}"'|g' "$PHP_FPM_CONF_FILE"
  sed -i -e 's|{{PHP_FPM_PM_START_SERVERS}}|'"${PHP_FPM_PM_START_SERVERS}"'|g' "$PHP_FPM_CONF_FILE"
  sed -i -e 's|{{PHP_FPM_PM_MIN_SPARE_SERVER}}|'"${PHP_FPM_PM_MIN_SPARE_SERVER}"'|g' "$PHP_FPM_CONF_FILE"
  sed -i -e 's|{{PHP_FPM_PM_MAX_SPARE_SERVERS}}|'"${PHP_FPM_PM_MAX_SPARE_SERVERS}"'|g' "$PHP_FPM_CONF_FILE"
}

function nginx() {
  NGINX_CONF_FILE="/etc/nginx/nginx.conf"
  sed -i -e 's|{{NGINX_CLIENT_MAX_BODY_SIZE}}|'"${NGINX_CLIENT_MAX_BODY_SIZE}"'|g' "$NGINX_CONF_FILE"
  sed -i -e 's|{{NGINX_SET_REAL_IP_FROM}}|'"${NGINX_SET_REAL_IP_FROM}"'|g' "$NGINX_CONF_FILE"
}

function laravel_scheduler() {
  # Enable Laravel SCHEDULER
  if [[ "${LARAVEL_SCHEDULER_ENABLE}" == "1" ]]; then
    echo "* * * * * php-fpm /var/www/html/artisan schedule:run >> /dev/null 2>&1" >>/etc/crontabs/www-data
  else
    rm -f /etc/supervisor.d/cron.ini
  fi
}

function laravel_horizon() {
  if [[ "${LARAVEL_HORIZON_ENABLE}" != "1" ]]; then
    rm -f /etc/supervisor.d/horizon.ini
  fi
}

#---------------------------------------------------------------------
# run all functions
#---------------------------------------------------------------------

function run() {
  php
  php_opcache
  php_fpm
  nginx
  laravel_scheduler
  laravel_horizon
}

run

exec "$@"
