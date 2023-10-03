#!/bin/bash

export composer=""

find_composer() {
    local path
    for dir in /usr/local/bin/composer /usr/bin/composer; do
        if [ -x "$dir" ]; then
            path="$dir"
            break
        fi
    done
    echo "$path"
}

if [ -n "$1" ]; then
    custom_composer="$1"
    if [ -x "$custom_composer" ]; then
        composer="$custom_composer"
    else
        echo "Custom Composer directory provided, but Composer not found at: $custom_composer. Exiting."
        exit 1
    fi
else
    composer="$(find_composer)"
fi

if [ -n "$composer" ]; then
    echo "Composer found at: $composer"
else
    echo "Composer not found. Please install Composer or specify a custom Composer directory. Exiting."
    exit 1
fi
