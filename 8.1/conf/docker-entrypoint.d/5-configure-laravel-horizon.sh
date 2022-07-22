#!/bin/sh

#---------------------------------------------------------------------
# configurations
#---------------------------------------------------------------------

function laravel_horizon() {
  if [[ "${LARAVEL_HORIZON_ENABLE}" != "1" ]]; then
    rm -f /etc/supervisor.d/horizon.ini
  fi
}

echo "Configure laravel horizon"
laravel_horizon