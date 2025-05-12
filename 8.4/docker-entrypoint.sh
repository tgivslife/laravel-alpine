#!/bin/sh

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

if /usr/bin/find "/docker-entrypoint.d/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
    echo "$(timestamp) /docker-entrypoint.d/ is not empty, will attempt to perform configuration"

    echo "$(timestamp) Looking for shell scripts in /docker-entrypoint.d/"
    find "/docker-entrypoint.d/" -follow -type f -print | sort -V | while read -r f; do
        case "$f" in
            *.sh)
                if [ -x "$f" ]; then
                    echo "$(timestamp) Launching $f";
                    "$f"
                else
                    # warn on shell scripts without exec bit
                    echo "$(timestamp) Ignoring $f, not executable";
                fi
                ;;
            *) echo "$(timestamp) Ignoring $f";;
        esac
    done

    echo "$(timestamp) Configuration complete; ready for start up"
else
    echo "$(timestamp) No files found in /docker-entrypoint.d/, skipping configuration"
fi

echo "$(timestamp) Running CMD: $@"
exec "$@"