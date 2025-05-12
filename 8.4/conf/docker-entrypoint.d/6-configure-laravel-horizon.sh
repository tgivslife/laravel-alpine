#!/bin/sh

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

#---------------------------------------------------------------------
# configurations
#---------------------------------------------------------------------

function laravel_horizon() {
  if [[ "${LARAVEL_HORIZON_ENABLE}" != "1" ]]; then
    rm -f /etc/supervisor.d/horizon.ini
    echo "$(timestamp) Disabled laravel horizon"
  else
    echo "$(timestamp) Enabled laravel horizon"
  fi
}

echo "$(timestamp) Configure laravel horizon started"
laravel_horizon
echo "$(timestamp) Configure laravel horizon finished"