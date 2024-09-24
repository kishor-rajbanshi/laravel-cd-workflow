#!/bin/bash

set -e

echo "Starting deployment..."

if [ -n "$1" ]; then
    if [[ "$(basename "$1")" == "Dockerfile" ]]; then
       docker build --no-cache -f "$1" .
    else [[ "$(basename "$1")" == "docker-compose.yml" ]]; then
        docker compose -f "$1" build --no-cache
        docker compose -f "$1" down
        docker compose -f "$1" up -d
    fi
else
    ($php artisan down) || true
    git pull
    if [ -n "$npm" ]; then
        $npm run prod
    fi
    $php $composer install --optimize-autoloader --no-dev --no-interaction --prefer-dist
    $php artisan optimize:clear
    $php artisan optimize
    $php artisan migrate --force
    $php artisan up
fi

echo "Deployment finished."
