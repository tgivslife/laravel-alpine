# 8.1

## What's Included

Default packages

- PHP-FPM `8.1.10`
- Nginx `1.22.0`
- Supervisor `4.2.4`
- CRON `1.35.0`

Build packages

- Composer - `2.4.1`
- NodeJs - `16.16.0`
- Npm - `8.10.0`
- Git - `2.36.2`

# Build

When building images the following naming convention is required `[php version]`.`laravel-alpine[alpine version]`-`|build`

### Image used for building laravel application

```
docker build --no-cache -t 8.1.10-laravel-ubuntu22.10-build --build-arg INCLUDE_BUILD_TOOLS=true -f ubuntu/8.1/Dockerfile ./ubuntu/8.1
```

### Image used for running laravel application

```
docker build --no-cache -t 8.1.10-laravel-ubuntu22.10 -f ubuntu/8.1/Dockerfile ./ubuntu/8.1
```
