# 8.4

Alpine image based on the official `php:8.4-fpm-alpine` image. Released by [GitHub Actions](../README.md#by-github-actions).

How to build, configure (environment variables), publish and deploy is documented in the [main README](../README.md).

### What's included

The version being built is set by the `ARG`s at the top of the [Dockerfile](./Dockerfile). The exact package versions of each
published tag (PHP-FPM, Alpine, Nginx, Supervisor and, in the `-build` image, Composer, NodeJs, Npm, Git) are listed in its
[GitHub release](https://github.com/tgivslife/laravel-alpine/releases), read from the published image.

_Php Modules_

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
gd
hash
iconv
intl
json
libxml
mbstring
mysqli
mysqlnd
openssl
pcntl
pcre
PDO
pdo_mysql
pdo_pgsql
pdo_sqlite
pgsql
Phar
posix
random
readline
redis
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

### Build arguments

Version arguments, with their defaults set at the top of the [Dockerfile](./Dockerfile):

- `ALPINE_VERSION` - Alpine version of the base image
- `PHP_VERSION` - PHP version of the base image
- `COMPOSER_VERSION` - Composer version installed in the `-build` image

Plus the [common build arguments](../README.md#build-image) (`INCLUDE_BUILD_TOOLS`, `REGISTRY`).
