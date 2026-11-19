#!/bin/sh

# Fail fast: a failed step must abort container startup instead of booting misconfigured.
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

laravel_horizon() {
  CONFIG_PATH="/etc/supervisor.d/horizon.ini"
  DISABLED_CONFIG_PATH="/etc/supervisor.d/horizon.ini.disabled"

  if [ "${LARAVEL_HORIZON_ENABLE}" = "1" ]; then
    if [ -f "${DISABLED_CONFIG_PATH}" ]; then
      log "Enabling Laravel Horizon"
      mv "${DISABLED_CONFIG_PATH}" "${CONFIG_PATH}"
    else
      log "Laravel Horizon already enabled or config missing"
    fi
  else
    if [ -f "${CONFIG_PATH}" ]; then
      log "Disabling Laravel Horizon"
      mv "${CONFIG_PATH}" "${DISABLED_CONFIG_PATH}"
    else
      log "Laravel Horizon already disabled or config missing"
    fi
  fi
}

log "Configure laravel horizon started"
laravel_horizon
log "Configure laravel horizon finished"