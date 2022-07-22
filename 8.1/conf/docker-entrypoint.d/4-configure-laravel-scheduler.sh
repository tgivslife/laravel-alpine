#!/bin/sh

#---------------------------------------------------------------------
# configurations
#---------------------------------------------------------------------

function laravel_scheduler() {
  # Enable Laravel SCHEDULER
  if [[ "${LARAVEL_SCHEDULER_ENABLE}" == "1" ]]; then
    echo "* * * * * php-fpm /var/www/html/artisan schedule:run >> /dev/null 2>&1" >>/etc/crontabs/www-data
  else
    rm -f /etc/supervisor.d/cron.ini
  fi
}

echo "Configure laravel scheduler"
laravel_scheduler