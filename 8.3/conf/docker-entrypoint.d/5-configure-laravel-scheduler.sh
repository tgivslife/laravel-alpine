#!/bin/sh

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

log() {
  echo "$(timestamp) $*"
}

#---------------------------------------------------------------------
# configurations
#---------------------------------------------------------------------

laravel_scheduler() {
  if [ "${LARAVEL_SCHEDULER_ENABLE}" = "1" ]; then
    echo "* * * * * php /var/www/html/artisan schedule:run 2>&1" > /etc/crontabs/www-data
    log "Enabled laravel scheduler"
  else
    echo "#* * * * * php /var/www/html/artisan schedule:run 2>&1" > /etc/crontabs/www-data
    log "Disabled laravel scheduler"
  fi
}

log "Configure laravel scheduler started"
laravel_scheduler
log "Configure laravel scheduler finished"