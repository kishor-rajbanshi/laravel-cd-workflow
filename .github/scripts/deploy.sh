#!/bin/bash
set -e

echo "Run Script"

($php artisan down) || true

git pull origin main

find ./ -type f -user $(whoami) -exec chmod 775 {} \;

$php $composer install --optimize-autoloader --no-dev --no-interaction --prefer-dist

$php artisan optimize:clear

$php artisan optimize

$php artisan migrate --force

$php artisan up

echo "Deployment finished!"