#!/bin/bash

if [ -n "$1" ]; then
    min_required_version="$1"
else
    echo "Usage: $0 <minimum_required_php_version>"
    exit 1
fi

highest_version=""
export php=""

for dir in /usr/bin/php*; do
    if [ -x "$dir" ]; then
        current_version="$("$dir" -r 'echo PHP_VERSION;' 2>/dev/null)"
        if [[ "$current_version" == ${min_required_version%%.*}.* ]]; then
            if [ -z "$highest_version" ] || dpkg --compare-versions "$current_version" gt "$highest_version"; then
                highest_version="$current_version"
                php="php${current_version%.*}"
            fi
        fi
    fi
done

if [ -n "$highest_version" ]; then
    echo "Highest installed PHP version of major version ${min_required_version%%.*}: $highest_version"

    if dpkg --compare-versions "$highest_version" eq "$min_required_version"; then
        echo "PHP version $highest_version is equal to the minimum required version $min_required_version."
    elif dpkg --compare-versions "$highest_version" gt "$min_required_version"; then
        echo "PHP version $highest_version is higher than the minimum required version $min_required_version."
    else
        echo "PHP version $highest_version is lower than the minimum required version $min_required_version. Please update PHP."
        exit 1
    fi
else
    echo "No PHP versions matching the required major version found. Exiting."
    exit 1
fi
