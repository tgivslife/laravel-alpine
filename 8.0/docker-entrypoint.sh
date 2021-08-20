#!/bin/sh

if /usr/bin/find "/docker-entrypoint.d/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
    echo "/docker-entrypoint.d/ is not empty, will attempt to perform configuration"

    echo "Looking for shell scripts in /docker-entrypoint.d/"
    find "/docker-entrypoint.d/" -follow -type f -print | sort -V | while read -r f; do
        case "$f" in
            *.sh)
                if [ -x "$f" ]; then
                    echo "Launching $f";
                    "$f"
                else
                    # warn on shell scripts without exec bit
                    echo "Ignoring $f, not executable";
                fi
                ;;
            *) echo "Ignoring $f";;
        esac
    done

    echo "Configuration complete; ready for start up"
else
    echo "No files found in /docker-entrypoint.d/, skipping configuration"
fi

echo "Running CMD: $@"
exec "$@"