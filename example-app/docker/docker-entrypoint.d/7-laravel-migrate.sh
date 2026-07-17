#!/bin/sh

# Fail fast: a failed step must abort container startup instead of booting misconfigured.
set -e

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

log() {
  echo "$(timestamp) $*"
}

log "Migrate database started"

tries=0
until php /var/www/html/artisan migrate --force; do
  tries=$((tries + 1))
  if [ "$tries" -ge 10 ]; then
    log "Database not reachable, giving up"
    exit 1
  fi
  log "Database not ready, retrying ($tries/10)"
  sleep 3
done

log "Migrate database finished"
