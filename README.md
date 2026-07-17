# Laravel-Alpine

> These Docker images provide a lightweight PHP-FPM environment on Alpine Linux — with a Debian (`trixie`) variant also available — optimized for running Laravel and other PHP applications with Nginx.
> They include common PHP extensions, Redis, PostgreSQL, MySQL, GD, OPCache, and an optional build toolchain for development workflows.

## What's Included

### Default packages

- [PHP-FPM](https://www.php.net/manual/en/install.fpm.php)
- [Nginx](https://www.nginx.com/)
- [Supervisor](http://supervisord.org)
- [CRON](https://en.wikipedia.org/wiki/Cron)

### Build packages

- [Composer](https://getcomposer.org/)
- [NodeJs](https://nodejs.org/en/)
- [Npm](https://www.npmjs.com/)
- [Git](https://git-scm.com/)

### Available tags

Tags published on [Docker Hub](https://hub.docker.com/r/stsdockerhub/php/tags), grouped by major PHP version. Each runtime tag (`[php version]-laravel-alpine[alpine version]`, or `[php version]-laravel-[debian codename]` for the [Debian variant](./debian/8.5/README.md)) has a matching `-build` variant that includes the build toolchain (Composer, NodeJs, Npm, Git).
A working sample application (Laravel + Vue starter kit, scheduler + horizon test jobs) lives in [example-app](./example-app/README.md).

#### PHP 8.5

- `8.5.8-laravel-trixie` / `8.5.8-laravel-trixie-build`
- `8.5.8-laravel-alpine3.24-build` / `8.5.8-laravel-alpine3.24`

#### PHP 8.4

- `8.4.23-laravel-alpine3.24` / `8.4.23-laravel-alpine3.24-build`
- `8.4.12-laravel-alpine3.22` / `8.4.12-laravel-alpine3.22-build`
- `8.4.10-laravel-alpine3.22` / `8.4.10-laravel-alpine3.22-build`
- `8.4.7-laravel-alpine3.21` / `8.4.7-laravel-alpine3.21-build`

#### PHP 8.3

- `8.3.32-laravel-alpine3.24` / `8.3.32-laravel-alpine3.24-build`
- `8.3.21-laravel-alpine3.21` / `8.3.21-laravel-alpine3.21-build`
- `8.3.20-laravel-alpine3.21` / `8.3.20-laravel-alpine3.21-build`
- `8.3.11-laravel-alpine3.20` / `8.3.11-laravel-alpine3.20-build`
- `8.3.10-laravel-alpine3.20` / `8.3.10-laravel-alpine3.20-build`
- `8.3.2-laravel-alpine3.19` / `8.3.2-laravel-alpine3.19-build`
- `8.3.1-laravel-alpine3.19` / `8.3.1-laravel-alpine3.19-build`

#### PHP 8.2

- `8.2.15-laravel-alpine3.18` / `8.2.15-laravel-alpine3.18-build`
- `8.2.14-laravel-alpine3.18` / `8.2.14-laravel-alpine3.18-build`
- `8.2.12-laravel-alpine3.18` / `8.2.12-laravel-alpine3.18-build`
- `8.2.10-laravel-alpine3.18` / `8.2.10-laravel-alpine3.18-build`
- `8.2.9-laravel-alpine3.17` / `8.2.9-laravel-alpine3.17-build`
- `8.2.6-laravel-alpine3.17` / `8.2.6-laravel-alpine3.17-build`
- `8.2.5-laravel-alpine3.17` / `8.2.5-laravel-alpine3.17-build`
- `8.2.1-laravel-alpine3.17` / `8.2.1-laravel-alpine3.17-build`

#### PHP 7.4

- `7.4.33-laravel-alpine3.16` / `7.4.33-laravel-alpine3.16-build`
