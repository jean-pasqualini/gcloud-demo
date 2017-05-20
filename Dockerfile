FROM php:7.0
MAINTAINER jpasqualini75@gmail.com

COPY ./index.php /app/index.php
WORKDIR /app
EXPOSE 80
ENTRYPOINT php -S 0.0.0.0:80