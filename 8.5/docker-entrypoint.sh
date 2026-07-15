#!/bin/sh

# Fail fast: if any configuration script fails, abort startup instead of
# launching services with incomplete configuration.
set -e

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

log() {
  echo "$(timestamp) $*"
}

if /usr/bin/find "/docker-entrypoint.d/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
    log "/docker-entrypoint.d/ is not empty, will attempt to perform configuration"

    log "Looking for shell scripts in /docker-entrypoint.d/"
    find "/docker-entrypoint.d/" -follow -type f -print | sort -V | while read -r f; do
        case "$f" in
            *.sh)
                if [ -x "$f" ]; then
                    log "Launching $f";
                    "$f"
                else
                    # warn on shell scripts without exec bit
                    log "Ignoring $f, not executable";
                fi
                ;;
            *)
                log "Ignoring $f"
                ;;
        esac
    done

    log "Configuration complete; ready for start up"
else
    log "No files found in /docker-entrypoint.d/, skipping configuration"
fi

log "Running CMD: $@"
exec "$@"