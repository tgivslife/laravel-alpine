# 8.4 (8.4.23)

Alpine image based on the official `php:8.4-fpm-alpine` image. Published [manually](../README.md#manually-other-images).

How to build, configure (environment variables), publish and deploy is documented in the [main README](../README.md).

### What's included

Default packages

- PHP-FPM - `8.4.23`
- Nginx - `1.30.3`
- Supervisor - `4.3.0`

Build packages

- Composer - `2.10.2`
- NodeJs - `24.17.0`
- Npm - `11.12.1`
- Git - `2.54.0`

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

Plus the [common build arguments](../README.md#build-image) (`INCLUDE_BUILD_TOOLS`, `REGISTRY`).
