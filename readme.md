# PHP-FPM 7.4
OS - CentOS version 8
```dockerfile
version: '3.6'

services:
  php:
    build:
      context: ./
    volumes:
      - .:/var/www/html
    restart: always
```


