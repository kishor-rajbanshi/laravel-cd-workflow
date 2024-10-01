#!/bin/bash

set -e

echo "Starting deployment..."

if [ -n "$1" ]; then

    if [[ "$(basename "$1")" == "Dockerfile" ]]; then

        volumes=$(echo "$3" | sed 's/,/ -v /g')
        ports=$(echo "$4" | sed 's/,/ -p /g')

        (docker stop "$2-container") || true
        (docker rm "$2-container") || true

        git pull

        docker build -f "$1" -t "$2" --no-cache "${1%/*}"
        docker run -d --restart "unless-stopped" --name "$2-container" -v "$volumes" -p "$ports" "$2"

    elif [[ "$(basename "$1")" == "docker-compose.yml" ]]; then

        docker compose -f "$1" down
        git pull
        docker compose -f "$1" up --build -d

    fi

else

    ($php artisan down) || true

    git pull

    if [ -n "$npm" ]; then
        $npm run build
    fi

    $php $composer install --optimize-autoloader --no-dev --no-interaction --prefer-dist
    $php artisan optimize:clear
    $php artisan optimize
    $php artisan migrate --force
    $php artisan up

fi

echo "Deployment finished."
