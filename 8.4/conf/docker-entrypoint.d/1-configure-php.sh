#!/bin/sh

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

#---------------------------------------------------------------------
# configurations
#---------------------------------------------------------------------

function php() {
  PHP_INI_FILE="/usr/local/etc/php/php.ini"
  sed -i -e 's|max_execution_time =.*$|max_execution_time = '"${PHP_MAX_EXECUTION_TIME}"'|g' "$PHP_INI_FILE"
  sed -i -e 's|memory_limit =.*$|memory_limit = '"${PHP_MEMORY_LIMIT}"'|g' "$PHP_INI_FILE"
  sed -i -e 's|upload_max_filesize =.*$|upload_max_filesize = '"${PHP_UPLOAD_MAX_FILESIZE}"'|g' "$PHP_INI_FILE"
  sed -i -e 's|post_max_size =.*$|post_max_size = '"${PHP_POST_MAX_SIZE}"'|g' "$PHP_INI_FILE"
}

#---------------------------------------------------------------------
# run configurations
#---------------------------------------------------------------------

echo "$(timestamp) Configure php started"
php
echo "$(timestamp) Configure php finished"