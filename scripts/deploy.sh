#!/bin/bash

set -e

echo "Starting deployment..."

file="store.txt"

generate_random_string() {
    tr -dc 'a-z0-9-' < /dev/urandom | head -c 32
}

if [ -n "$1" ]; then
    if [[ "$(basename "$1")" == "Dockerfile" ]]; then

        if [[ ! -f "$file" ]]; then
            echo "image_name:$(generate_random_string)" > "$file"
            echo "container_name:$(generate_random_string)" >> "$file"
        else
            while IFS=":" read -r key value; do
                declare "$key=$value"
            done < "$file"
        fi

        docker stop "$container_name"
        docker rm "$container_name"
        git pull
        docker build -f "$1" -t "$image_name" --no-cache  .
        docker run -d --name "$container_name" -P "$2" "$image_name"

    elif [[ "$(basename "$1")" == "docker-compose.yml" ]]; then
        docker compose -f "$1" down
        git pull
        docker compose -f "$1" up --build -d
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
