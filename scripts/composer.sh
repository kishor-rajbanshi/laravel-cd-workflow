#!/bin/bash

export composer=""

composer() {
    for composer in /usr/local/bin/composer /usr/bin/composer; do
        if [ -x "$composer" ]; then
            echo $composer
            break
        fi
    done
}

if [ -n "$1" ]; then
    composer="$1"
    if [ ! -f "$composer" ] || [ ! -x "$composer" ]; then
        echo "Executable Composer not found at: $composer. Exiting."
        exit 1
    fi
else
    composer="$(composer)"
fi

if [ -n "$composer" ]; then
    echo "Composer found at: $composer"
else
    echo "Composer not found. Exiting."
    exit 1
fi
