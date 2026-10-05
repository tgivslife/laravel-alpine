# 8.5 Debian

Debian `trixie` variant of the [8.5 alpine image](../../8.5/README.md). PHP is compiled from source on `debian:trixie-slim`
(based on the official docker-library/php template) and only the runtime files are kept in the final image. Released by [GitHub Actions](../../README.md#by-github-actions).

How to build, configure (environment variables), publish and deploy is documented in the [main README](../../README.md).
Tags follow `[php version]-laravel-[debian codename]`.

### What's included

The versions being built are set by the `ARG`s at the top of the [Dockerfile](./Dockerfile). The exact package versions of each
published tag (PHP-FPM, Debian, Nginx, Supervisor and, in the `-build` image, Composer, NodeJs, Npm, Git) are listed in its
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
lexbor
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
uri
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

- `DEBIAN_VERSION` - tag of the `debian` base image (e.g. `trixie-20260918-slim`)
- `PHP_VERSION`, `PHP_SHA256` - PHP version compiled from source and the checksum of its `.tar.xz` source tarball (listed on [php.net/downloads](https://www.php.net/downloads.php))
- `NGINX_VERSION` - version of the `nginx` package from the nginx.org stable repository (e.g. `1.30.5-1~trixie`)
- `COMPOSER_VERSION` - Composer version installed in the `-build` image
- `NODE_VERSION`, `NODE_SHA256_X64`, `NODE_SHA256_ARM64` - NodeJs version installed in the `-build` image and the checksums of its official binaries
- `NPM_VERSION`, `NPM_SHA256` - Npm version installed in the `-build` image and the checksum of its tarball

Plus the [common build arguments](../../README.md#build-image) (`INCLUDE_BUILD_TOOLS`, `REGISTRY`).
