#!/bin/sh

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

#---------------------------------------------------------------------
# configurations
#---------------------------------------------------------------------

function laravel_scheduler() {
  if [[ "${LARAVEL_SCHEDULER_ENABLE}" == "1" ]]; then
    echo "* * * * * php /var/www/html/artisan schedule:run 2>&1" >> /etc/crontabs/www-data
    echo "$(timestamp) Enabled laravel scheduler"
  else
    rm -f /etc/supervisor.d/cron.ini
    echo "$(timestamp) Disabled laravel scheduler"
  fi
}

echo "$(timestamp) Configure laravel scheduler started"
laravel_scheduler
echo "$(timestamp) Configure laravel scheduler finished"