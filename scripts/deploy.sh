#!/bin/bash

set -e

echo "Deploying..."

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

echo "Deployment successful"