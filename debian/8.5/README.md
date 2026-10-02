# 8.5 Debian (8.5.10)

Debian `trixie` variant of the [8.5 alpine image](../../8.5/README.md). PHP is compiled from source on `debian:trixie-slim`
(based on the official docker-library/php template) and only the runtime files are kept in the final image. Published [manually](../../README.md#manually-other-images).

How to build, configure (environment variables), publish and deploy is documented in the [main README](../../README.md).
Tags follow `[php version]-laravel-[debian codename]`.

### What's included

Default packages

- PHP-FPM - `8.5.10`
- Nginx - `1.30.5`
- Supervisor - `4.2.5`

Build packages

- Composer - `2.10.3`
- NodeJs - `24.21.0`
- Npm - `11.19.1`
- Git - `2.47.3`

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

Version arguments, with their defaults set in the [Dockerfile](./Dockerfile):

- `DEBIAN_VERSION` - tag of the `debian` base image (e.g. `trixie-20260918-slim`)
- `PHP_VERSION` - PHP version compiled from source
- `NODE_VERSION`, `NODE_SHA256_X64`, `NODE_SHA256_ARM64` - NodeJs version installed in the `-build` image and the checksums of its official binaries
- `NPM_VERSION`, `NPM_SHA256` - Npm version installed in the `-build` image and the checksum of its tarball

Plus the [common build arguments](../../README.md#build-image) (`INCLUDE_BUILD_TOOLS`, `REGISTRY`).
