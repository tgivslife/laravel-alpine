#!/bin/sh

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

#---------------------------------------------------------------------
# configurations
#---------------------------------------------------------------------

function php_fpm() {
  PHP_FPM_CONF_FILE="/usr/local/etc/php-fpm.d/www.conf"
  sed -i -e 's|pm.max_children =.*$|pm.max_children = '"${PHP_FPM_PM_MAX_CHILDREN}"'|g' "$PHP_FPM_CONF_FILE"
  sed -i -e 's|pm.start_servers =.*$|pm.start_servers = '"${PHP_FPM_PM_START_SERVERS}"'|g' "$PHP_FPM_CONF_FILE"
  sed -i -e 's|pm.min_spare_servers =.*$|pm.min_spare_servers = '"${PHP_FPM_PM_MIN_SPARE_SERVER}"'|g' "$PHP_FPM_CONF_FILE"
  sed -i -e 's|pm.max_spare_servers =.*$|pm.max_spare_servers = '"${PHP_FPM_PM_MAX_SPARE_SERVERS}"'|g' "$PHP_FPM_CONF_FILE"
}

echo "$(timestamp) Configure php-fpm started"
php_fpm
echo "$(timestamp) Configure php-fpm finished"