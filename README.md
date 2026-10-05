# Laravel-Alpine

> These Docker images provide a lightweight PHP-FPM environment on Alpine Linux — with a Debian (`trixie`) variant also available — optimized for running Laravel and other PHP applications with Nginx.
> They include common PHP extensions, Redis, PostgreSQL, MySQL, GD, OPCache, and an optional build toolchain for development workflows.

- [Images](#images)
- [What's included](#whats-included)
- [Available tags](#available-tags)
- [Build image](#build-image)
- [Environment variables](#environment-variables)
- [Publish to hub.docker.com](#publish-to-hubdockercom)
- [Example deploy app](#example-deploy-app)

## Images

Each folder builds one image. Its README lists the PHP modules, build arguments and, for manually published images, the package versions; everything shared is documented here.

### Alpine

Based on the official `php:*-fpm-alpine` images. Tags: `[php version]-laravel-alpine[alpine version]`.

| Folder                                         | Base                 | Published by   |
|------------------------------------------------|----------------------|----------------|
| [8.5](./8.5/README.md)                         | `php:8.5-fpm-alpine` | GitHub Actions |
| [8.4](./8.4/README.md)                         | `php:8.4-fpm-alpine` | GitHub Actions |
| [8.3](./8.3/README.md)                         | `php:8.3-fpm-alpine` | manually       |
| [8.2](./8.2/README.md), [7.4](./7.4/README.md) | `php:*-fpm-alpine`   | legacy, no longer updated (self-contained READMEs) |

### Debian

PHP is compiled from source on `debian:*-slim` (based on the official docker-library/php template). Tags: `[php version]-laravel-[debian codename]`.

| Folder                               | Base                 | Published by   |
|--------------------------------------|----------------------|----------------|
| [debian/8.5](./debian/8.5/README.md) | `debian:trixie-slim` | GitHub Actions |

A working sample application (Laravel + Vue starter kit, scheduler + horizon test jobs) lives in [example-app](./example-app/README.md).

## What's included

### Default packages

- [PHP-FPM](https://www.php.net/manual/en/install.fpm.php)
- [Nginx](https://www.nginx.com/)
- [Supervisor](http://supervisord.org)

The processes (php-fpm, nginx, scheduler, horizon) are started and managed by supervisor.

### Build packages

Only in the `-build` images:

- [Composer](https://getcomposer.org/)
- [NodeJs](https://nodejs.org/en/)
- [Npm](https://www.npmjs.com/)
- [Git](https://git-scm.com/)

## Available tags

All published tags are listed on [Docker Hub](https://hub.docker.com/r/stsdockerhub/php/tags); the git tag of the same name marks the commit each was built from.
Images released by GitHub Actions also have a [GitHub release](https://github.com/tgivslife/laravel-alpine/releases) listing their changes, exact package versions and PHP modules.

Tag naming: `[php version]-laravel-alpine[alpine version]` (Alpine) or `[php version]-laravel-[debian codename]` (Debian), e.g. `8.5.11-laravel-alpine3.24`.
Each runtime tag has a matching `-build` variant that includes the build toolchain (Composer, NodeJs, Npm, Git).
Recent tags are multi-arch (`linux/amd64`, `linux/arm64`).

## Build image

Build from the repository root, passing the image folder (`8.5`, `debian/8.5`, ...) as the build context.
The versions that get built are the `ARG` defaults at the top of that folder's `Dockerfile`.

__Image used for running laravel application__

```
docker build -t local/php:8.5 ./8.5
```

__Image used for building laravel application__

```
docker build -t local/php:8.5-build --build-arg INCLUDE_BUILD_TOOLS=true ./8.5
```

Build arguments available in every image (_docker build --build-arg VAR1=value1_):

- `INCLUDE_BUILD_TOOLS` - include Composer, NodeJs, Npm and Git, default is __false__
- `REGISTRY` - Docker registry to pull the base image from (e.g. `repos.stsnet.ro`), default is __docker.io__

Version arguments (`PHP_VERSION`, `ALPINE_VERSION`, ...) are listed in each image README.

## Environment variables

Set at runtime with `--env` (_docker run --env VAR1=value1_). The defaults below apply to all maintained images (8.3, 8.4, 8.5, debian/8.5).

#### OS

| Variable | Default            | Description |
|----------|--------------------|-------------|
| `TZ`     | `Europe/Bucharest` | Timezone    |

#### Laravel

| Variable                   | Default | Description |
|----------------------------|---------|-------------|
| `LARAVEL_SCHEDULER_ENABLE` | `1`     | Run Laravel's [command scheduler](https://laravel.com/docs/scheduling) as a supervisor-managed `php artisan schedule:work` process, so its output is visible in the container logs. |
| `LARAVEL_HORIZON_ENABLE`   | `0`     | Run [Laravel Horizon](https://laravel.com/docs/horizon), the dashboard and code-driven configuration for Redis queues. |

#### PHP

| Variable                  | Default | Description |
|---------------------------|---------|-------------|
| `PHP_MAX_EXECUTION_TIME`  | `60`    | Maximum execution time of each script, in seconds. |
| `PHP_MEMORY_LIMIT`        | `128M`  | Maximum amount of memory a script may consume. On PHP 8.5 only `memory_limit` is set; `max_memory_limit` stays `-1`, so `ini_set('memory_limit', ...)` can still raise the limit at runtime. |
| `PHP_UPLOAD_MAX_FILESIZE` | `50M`   | Maximum allowed size for uploaded files. |
| `PHP_POST_MAX_SIZE`       | `50M`   | Maximum size of POST data that PHP will accept. `0` disables the limit. |

#### PHP OPcache

| Variable                              | Default | Description |
|---------------------------------------|---------|-------------|
| `PHP_OPCACHE_ENABLE`                  | `1`     | Enables the opcode cache. When disabled, code is not optimised or cached. |
| `PHP_OPCACHE_ENABLE_CLI`              | `1`     | Enables the opcode cache for the CLI version of PHP. |
| `PHP_OPCACHE_MEMORY_CONSUMPTION`      | `512`   | Size of the shared memory storage used by OPcache, in megabytes. Minimum `8`. |
| `PHP_OPCACHE_INTERNED_STRINGS_BUFFER` | `128`   | Memory used to store interned strings, in megabytes. |
| `PHP_OPCACHE_MAX_ACCELERATED_FILES`   | `65406` | Maximum number of keys (scripts) in the OPcache hash table, between `200` and `1000000`. The actual value used is the next prime number from { 223, 463, 983, 1979, 3907, 7963, 16229, 32531, 65407, 130987, 262237, 524521, 1048793 }. |
| `PHP_OPCACHE_MAX_WASTED_PERCENTAGE`   | `15`    | Maximum percentage of wasted memory allowed before a restart is scheduled. Maximum `50`. |
| `PHP_OPCACHE_VALIDATE_TIMESTAMPS`     | `0`     | When enabled, OPcache checks for updated scripts. When disabled, OPcache must be reset manually (`opcache_reset()`, `opcache_invalidate()` or a container restart) for code changes to take effect. |
| `PHP_OPCACHE_SAVE_COMMENTS`           | `1`     | When disabled, doc comments are discarded from the opcode cache. Disabling it breaks code that relies on annotations (Doctrine, PHPUnit, ...). |

#### PHP-FPM

| Variable                       | Default | Description |
|--------------------------------|---------|-------------|
| `PHP_FPM_PM_MAX_CHILDREN`      | `50`    | Maximum number of child processes. |
| `PHP_FPM_PM_START_SERVERS`     | `20`    | Number of child processes created on startup. |
| `PHP_FPM_PM_MIN_SPARE_SERVER`  | `10`    | Desired minimum number of idle server processes. |
| `PHP_FPM_PM_MAX_SPARE_SERVERS` | `30`    | Desired maximum number of idle server processes. |

#### Nginx

| Variable                     | Default     | Description |
|------------------------------|-------------|-------------|
| `NGINX_FASTCGI_READ_TIMEOUT` | `60s`       | Timeout between two successive reads from php-fpm (not for the whole response). If php-fpm sends nothing within this time, the connection is closed. |
| `NGINX_CLIENT_MAX_BODY_SIZE` | `50m`       | Maximum allowed size of the client request body. Larger requests get `413 Request Entity Too Large`. |
| `NGINX_SET_REAL_IP_FROM`     | `127.0.0.1` | Trusted addresses that are known to send correct replacement addresses. `unix:` trusts all UNIX-domain sockets; hostnames are allowed. |
| `NGINX_WORKER_RLIMIT_NOFILE` | `65535`     | Per-worker open file descriptor limit. Kept above `worker_connections`, since each connection can use more than one fd (client + fastcgi upstream). |
| `NGINX_WORKER_CONNECTIONS`   | `4096`      | Maximum number of simultaneous connections per worker process. |

## Publish to [hub.docker.com](https://hub.docker.com/)

A release is a single commit, titled `build(release): <tag>` and tagged `<tag>`. Any other change (config, Dockerfile steps)
goes in an earlier commit, so CI has built it before the release. The release commit's body lists the changes, one per line.

Commit messages follow `type(scope): <what is true after the commit>`, e.g. `ci(docker): ...`, `docs(readme): ...`, `fix(nginx): ...`,
with a body that says why, then one `- <file>: <change>` line per file.

### By GitHub Actions

Each image has its own workflow, which reads the versions from that image's `Dockerfile` only:

| Image      | Dockerfile                                       | Workflow                                               | Tag pattern                  |
|------------|--------------------------------------------------|--------------------------------------------------------|------------------------------|
| 8.5        | [8.5/Dockerfile](./8.5/Dockerfile)               | [8.5-alpine.yml](./.github/workflows/8.5-alpine.yml)   | `8.5.*-laravel-alpine*`      |
| debian/8.5 | [debian/8.5/Dockerfile](./debian/8.5/Dockerfile) | [8.5-debian.yml](./.github/workflows/8.5-debian.yml)   | `8.5.*-laravel-trixie`       |
| 8.4        | [8.4/Dockerfile](./8.4/Dockerfile)               | [8.4-alpine.yml](./.github/workflows/8.4-alpine.yml)   | `8.4.*-laravel-alpine*`      |

The release commit changes only the version `ARG` lines at the top of the image `Dockerfile`: for a PHP update, just `PHP_VERSION`
(plus `PHP_SHA256` for `debian/8.5`, which compiles PHP from source). For example:

```
git commit -am "build(release): 8.5.12-laravel-alpine3.24" -m "- PHP 8.5.12"
git tag -a 8.5.12-laravel-alpine3.24 -m "8.5.12-laravel-alpine3.24"
git push origin-github master 8.5.12-laravel-alpine3.24
```

The workflow builds and smoke-tests both images for `linux/amd64` and `linux/arm64`
on every push to `master` and pull request that touches the image, without publishing.

Pushing a release tag publishes: the tag's run builds and smoke-tests both images, pushes `stsdockerhub/php:<tag>` and `stsdockerhub/php:<tag>-build`,
then creates the GitHub release with the commit body, the exact package versions and the PHP modules, read from the published image.
It refuses a tag that does not match the `Dockerfile`, is not on a release commit, or whose release commit changes more than the version `ARG`s.
The `master` run skips the release commit itself, since its tag's run builds it.

To republish a released version (this also refreshes the versions in its GitHub release):

- re-run the tag's workflow run from the Actions tab, e.g. to pick up base image security patches
- or run the workflow manually on `master`, which publishes `master` under the current tag, e.g. after a config fix

The `debian/8.5` tag holds only the PHP version and the Debian codename, so a newer Debian snapshot, nginx, NodeJs or Npm without a
PHP update keeps the current tag: commit the `ARG` change to `master`, then run the workflow manually to republish.

Each image is labelled with its tag, git commit, commit date and source repository: `docker inspect -f '{{json .Config.Labels}}' stsdockerhub/php:<tag>`.

The workflows need the repository secrets `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` (an access token with write access to `stsdockerhub/php`).

### Manually (other images)

The release commit bumps the version `ARG`s in the image `Dockerfile` and the package versions in the image README.

1. Sign in with `docker login --username=tgivslife`
2. Build and push both variants for both architectures, e.g. for `8.3`:

   ```
   docker buildx build --platform linux/amd64,linux/arm64 --push -t stsdockerhub/php:<tag> ./8.3
   docker buildx build --platform linux/amd64,linux/arm64 --push -t stsdockerhub/php:<tag>-build --build-arg INCLUDE_BUILD_TOOLS=true ./8.3
   ```

3. Tag the release commit with `<tag>` and push the tag to remote

## Example deploy app

The container image serves the laravel application from `/var/www/html` through nginx. The application is afterwards accessible on port `80`.

Example of dockerfile for deploying laravel application using docker containers.
Build it with `docker build --build-arg IMAGE_TAG=<tag> .`, using any runtime tag from [Available tags](#available-tags).

```dockerfile
ARG REGISTRY=docker.io/stsdockerhub
ARG IMAGE_TAG

FROM ${REGISTRY}/php:${IMAGE_TAG}-build as build-container

WORKDIR /var/www/html

# copy app source code
COPY . .
COPY .env.example .env

# build source code
RUN composer install --no-dev \
    && npm install \
    && npm run build \
    && tar --owner=www-data --group=www-data --exclude=.git --exclude=docker --exclude=node_modules -czf /tmp/app.tar.gz .

###################################################################################################

FROM ${REGISTRY}/php:${IMAGE_TAG}

WORKDIR /var/www/html

COPY --from=build-container /tmp/app.tar.gz .

RUN tar -xf app.tar.gz \
    && rm -rf app.tar.gz

# Configure entrypoint
COPY docker/docker-entrypoint.d /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/*
```
