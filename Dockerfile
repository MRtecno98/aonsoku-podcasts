FROM composer:2.8.4 AS builder

WORKDIR /app

COPY composer.json composer.lock ./
RUN composer install \
    --no-dev \
    --no-scripts \
    --no-progress \
    --no-interaction \
    --optimize-autoloader \
    --ignore-platform-reqs

FROM serversideup/php:8.4-fpm-nginx-alpine AS base

USER root

RUN install-php-extensions intl

USER www-data

WORKDIR /var/www/html

COPY --chmod=755 .docker/entrypoint.d/ /etc/entrypoint.d/

EXPOSE 8080

FROM base AS development

USER root

ARG USER_ID
ARG GROUP_ID

RUN docker-php-serversideup-set-id www-data $USER_ID:$GROUP_ID && \
    docker-php-serversideup-set-file-permissions --owner $USER_ID:$GROUP_ID

USER www-data

FROM base AS production

COPY --chown=www-data:www-data . /var/www/html
COPY --from=builder --chown=www-data:www-data /app/vendor /var/www/html/vendor
COPY --chmod=755 ./aonsoku.sh /var/www/html/aonsoku.sh

RUN mkdir -p storage/framework/views \
    && mkdir -p storage/framework/cache \
    && mkdir -p storage/framework/sessions \
    && mkdir -p storage/logs \
    && chown -R www-data:www-data storage
