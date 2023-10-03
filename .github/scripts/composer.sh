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

composer="$(find_composer)"

if [ -n "$composer" ]; then
    echo "Composer found at: $composer"
else
    echo "Composer not found. Please install Composer. Exiting."
    exit 1
fi
