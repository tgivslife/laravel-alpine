# 7.4 (7.4.33)

## What's Included

Default packages

- PHP-FPM `7.4.33`
- Nginx `1.22.1`
- Supervisor `4.2.4`
- CRON `1.35.0`

Build packages

- Composer - `2.8.8`
- NodeJs - `16.20.2`
- Npm - `8.10.0`
- GIt - `2.36.6`

Php Modules

```
[PHP Modules]
bcmath
bz2
Core
ctype
curl
date
dom
exif
fileinfo
filter
ftp
gd
hash
iconv
imagick
intl
json
ldap
libxml
mbstring
mysqlnd
openssl
pcntl
pcre
PDO
pdo_pgsql
pdo_sqlite
pgsql
Phar
posix
readline
Reflection
session
SimpleXML
sockets
sodium
SPL
sqlite3
standard
tokenizer
xml
xmlreader
xmlwriter
Zend OPcache
zip
zlib

[Zend Modules]
Zend OPcache
```

# Build

When building images the following naming convention is required `[php version]`.`laravel-alpine[alpine version]`-`|build`

### Image used for building laravel application

```
docker build --no-cache -t php:7.4.33-laravel-alpine3.16-build --build-arg INCLUDE_BUILD_TOOLS=true -f 7.4/Dockerfile ./7.4
```

### Image used for running laravel application

```
docker build --no-cache -t php:7.4.33-laravel-alpine3.16 -f 7.4/Dockerfile ./7.4
```

The current arguments that can be set by `--build-args` (_docker build --build-arg VAR1=value1_):

- Alpine version: `--build-arg ALPINE_VERSION=3.16` , default is __3.16__
- Php version: `--build-arg PHP_VERSION=7.4.33` , default is __7.4.33__
- Docker registry: `--build-arg REGISTRY=repos.stsnet.ro` , default __docker.io__
- Include packages used for build: `--build-arg INCLUDE_BUILD_TOOLS=false` , default is __false__

# Publish to [hub.docker.com](https://hub.docker.com/)

Docker Hub repositories allow you share container images with your team, customers, or the Docker community at large.

Docker images are pushed to Docker Hub through the docker push command. A single Docker Hub repository can hold many Docker images (stored as tags).

1. Using `docker login --username=tgivslife` from the CLI, sign in

2. Re-tag an existing local image `docker tag <existing-image> <hub-user>/<repo-name>[:<tag>]`

    ```
    docker tag php:7.4.33-laravel-alpine3.16-build stsdockerhub/php:7.4.33-laravel-alpine3.16-build
    docker tag php:7.4.33-laravel-alpine3.16 stsdockerhub/php:7.4.33-laravel-alpine3.16
    ```
3. Push your newly tagged private images to your Docker namespace

   ```
   docker push stsdockerhub/php:7.4.33-laravel-alpine3.16-build
   docker push stsdockerhub/php:7.4.33-laravel-alpine3.16
   ```

# Run

The current environment variables that can be set by `--env` (_docker run --env VAR1=value1_):

#### OS related

- Timezone

        TZ="Europe/Bucharest"

#### LARAVEL related

- Laravel's command scheduler offers a fresh approach to managing scheduled tasks on your server. The scheduler allows you to fluently and expressively define your command schedule within your Laravel
  application itself. When using the scheduler, only a single cron entry is needed on your server.

        LARAVEL_SCHEDULER_ENABLE="1"

- Laravel Horizon provides a beautiful dashboard and code-driven configuration for your Laravel powered Redis queues. Horizon allows you to easily monitor key metrics of your queue system such as job
  throughput, runtime, and job failures.

        LARAVEL_HORIZON_ENABLE="0"

#### PHP related

- Maximum execution time of each script, in seconds

        PHP_MAX_EXECUTION_TIME="60"

- Maximum amount of memory a script may consume

        PHP_MEMORY_LIMIT="128M"

- Maximum allowed size for uploaded files

        PHP_UPLOAD_MAX_FILESIZE="50M"

- Maximum size of POST data that PHP will accept. Its value may be 0 to disable the limit

        PHP_POST_MAX_SIZE="50M"

#### PHP OPCACHE related

- Enables the opcode cache. When disabled, code is not optimised or cached

        PHP_OPCACHE_ENABLE="1"

- Enables the opcode cache for the CLI version of PHP

        PHP_OPCACHE_ENABLE="1"

- How often to check script timestamps for updates, in seconds. 0 will result in OPcache checking for updates on every request. This configuration directive is ignored if opcache.validate_timestamps
  is disabled.

        PHP_OPCACHE_REVALIDATE_FREQUENCY="0"

- If enabled, OPcache will check for updated scripts every opcache.revalidate_freq seconds. When this directive is disabled, you must reset OPcache manually via opcache_reset(), opcache_invalidate()
  or by restarting the Web server for changes to the filesystem to take effect.

        PHP_OPCACHE_VALIDATE_TIMESTAMPS="0"

- The maximum number of keys (and therefore scripts) in the OPcache hash table. The actual value used will be the first number in the set of prime numbers { 223, 463, 983, 1979, 3907, 7963, 16229,
  32531, 65407, 130987, 262237, 524521, 1048793 } that is greater than or equal to the configured value. The minimum value is 200. The maximum value is 1000000. Values outside of this range are
  clamped to the permissible range.

        PHP_OPCACHE_MAX_ACCELERATED_FILES="65407"

- The size of the shared memory storage used by OPcache, in megabytes. The minimum permissible value is "8", which is enforced if a smaller value is set.

        PHP_OPCACHE_MEMORY_CONSUMPTION="512"

- The maximum percentage of wasted memory that is allowed before a restart is scheduled, if there is insufficient free memory. The maximum permissible value is "50", which is enforced if a larger
  value is set.

        PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10"

- The amount of memory used to store interned strings, in megabytes.

        PHP_OPCACHE_INTERNED_STRINGS_BUFFER="16"

#### PHP-FPM related

- The number of child processes to be created when pm is set to static and the maximum number of child processes to be created when pm is set to dynamic.

        PHP_FPM_PM_MAX_CHILDREN="50"

- The number of child processes created on startup. Used only when pm is set to dynamic. Default Value: min_spare_servers + (max_spare_servers - min_spare_servers) / 2.

        PHP_FPM_PM_START_SERVERS="20"

- The desired minimum number of idle server processes. Used only when pm is set to dynamic. Also mandatory in this case.

        PHP_FPM_PM_MIN_SPARE_SERVER="10"

- The desired maximum number of idle server processes. Used only when pm is set to dynamic. Also mandatory in this case.

        PHP_FPM_PM_MAX_SPARE_SERVERS="30"

#### NGINX related

- Sets the maximum allowed size of the client request body. If the size in a request exceeds the configured value, the 413 (Request Entity Too Large) error is returned to the client.

        NGINX_CLIENT_MAX_BODY_SIZE="50m"

- Defines trusted addresses that are known to send correct replacement addresses. If the special value unix: is specified, all UNIX-domain sockets will be trusted. Trusted addresses may also be
  specified using a hostname

        NGINX_SET_REAL_IP_FROM="127.0.0.1"