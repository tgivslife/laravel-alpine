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

php_opcache() {
  PHP_INI_OPCACHE_FILE="/usr/local/etc/php/conf.d/opcache.ini"
  sed -i -e 's|opcache.enable=.*$|opcache.enable='"${PHP_OPCACHE_ENABLE}"'|g' "$PHP_INI_OPCACHE_FILE"
  sed -i -e 's|opcache.enable_cli=.*$|opcache.enable_cli='"${PHP_OPCACHE_ENABLE_CLI}"'|g' "$PHP_INI_OPCACHE_FILE"
  sed -i -e 's|opcache.memory_consumption=.*$|opcache.memory_consumption='"${PHP_OPCACHE_MEMORY_CONSUMPTION}"'|g' "$PHP_INI_OPCACHE_FILE"
  sed -i -e 's|opcache.interned_strings_buffer=.*$|opcache.interned_strings_buffer='"${PHP_OPCACHE_INTERNED_STRINGS_BUFFER}"'|g' "$PHP_INI_OPCACHE_FILE"
  sed -i -e 's|opcache.max_accelerated_files=.*$|opcache.max_accelerated_files='"${PHP_OPCACHE_MAX_ACCELERATED_FILES}"'|g' "$PHP_INI_OPCACHE_FILE"
  sed -i -e 's|opcache.max_wasted_percentage=.*$|opcache.max_wasted_percentage='"${PHP_OPCACHE_MAX_WASTED_PERCENTAGE}"'|g' "$PHP_INI_OPCACHE_FILE"
  sed -i -e 's|opcache.validate_timestamps=.*$|opcache.validate_timestamps='"${PHP_OPCACHE_VALIDATE_TIMESTAMPS}"'|g' "$PHP_INI_OPCACHE_FILE"
  sed -i -e 's|opcache.save_comments=.*$|opcache.save_comments='"${PHP_OPCACHE_SAVE_COMMENTS}"'|g' "$PHP_INI_OPCACHE_FILE"
}

log "Configure php opcache started"
php_opcache
log "Configure php opcache finished"