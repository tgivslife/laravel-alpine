# Example app

Minimal Laravel 12 + Vue (official [vue-starter-kit](https://github.com/laravel/vue-starter-kit)) application used to verify the `stsdockerhub/php` docker images are functional. It follows the `Example deploy app` section of the image READMEs: the `-build` image compiles the app (composer install, npm ci, npm run build) and the runtime image serves it.

What it exercises:

- **build image** — `composer install --no-dev`, `php artisan key:generate`, `npm ci`, `npm run build` (vite + vue)
- **nginx + php-fpm** — the starter kit welcome page on `/`
- **scheduler** — `Scheduler heartbeat` logged every minute, and a `TestJob` queued every minute (`routes/console.php`)
- **horizon** — processes the queued `TestJob` from redis; also dispatchable on demand via `/test-job`
- **postgres (pdo_pgsql)** — migrations run at container start (`docker/docker-entrypoint.d/7-laravel-migrate.sh`, which also tests extending the image's entrypoint), sessions and cache use the `database` drivers, and `/test-db` reports connectivity

## Build

```
docker build -t stsdockerhub/example-app -f example-app/Dockerfile ./example-app
```

The base image/version can be changed with `--build-arg REGISTRY=...` and `--build-arg LARAVEL_TRIXIE_VERSION=...`.

## Run and verify

```
cd example-app
docker compose up --build
```

Then:

- `curl -s localhost:8080/` — welcome page served by nginx (HTTP 200, Inertia/Vue markup)
- `curl -s localhost:8080/test-db` — postgres connectivity: driver, database name and row counts via `pdo_pgsql`
- `curl -s localhost:8080/test-job` — dispatches a `TestJob` to the redis queue
- `http://localhost:8080/horizon` — horizon dashboard (accessible because `APP_ENV=local`)
- container logs — within a minute both processes show up:

```
app-1  | ... local.INFO: Scheduler heartbeat
app-1  | ... local.INFO: TestJob processed by horizon (source: scheduler)
app-1  | ... local.INFO: TestJob processed by horizon (source: http)
```

The scheduler and horizon are enabled through the image's `LARAVEL_SCHEDULER_ENABLE` / `LARAVEL_HORIZON_ENABLE` environment variables (see `compose.yaml`). Logs go to `stderr` (`LOG_CHANNEL=stderr`) so everything is visible with `docker compose logs`.

The database is postgres (`db` service): migrations run automatically at container start and sessions/cache use the `database` drivers, so regular page loads exercise `pdo_pgsql` at runtime. The queue stays on redis for horizon.
