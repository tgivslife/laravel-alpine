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

laravel_scheduler() {
  CONFIG_PATH="/etc/supervisor.d/scheduler.ini"
  DISABLED_CONFIG_PATH="/etc/supervisor.d/scheduler.ini.disabled"

  if [ "${LARAVEL_SCHEDULER_ENABLE}" = "1" ]; then
    if [ -f "${DISABLED_CONFIG_PATH}" ]; then
      log "Enabling Laravel scheduler"
      mv "${DISABLED_CONFIG_PATH}" "${CONFIG_PATH}"
    else
      log "Laravel scheduler already enabled or config missing"
    fi
  else
    if [ -f "${CONFIG_PATH}" ]; then
      log "Disabling Laravel scheduler"
      mv "${CONFIG_PATH}" "${DISABLED_CONFIG_PATH}"
    else
      log "Laravel scheduler already disabled or config missing"
    fi
  fi
}

log "Configure laravel scheduler started"
laravel_scheduler
log "Configure laravel scheduler finished"