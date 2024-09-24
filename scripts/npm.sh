#!/bin/bash

if [ -n "$1" ]; then
    min_required_version="$1"
else
    echo "Usage: $0 <minimum_required_npm_version>"
    exit 1
fi

nvm_dir="$HOME/.nvm/versions/node"
highest_version=""

if [ -d "$nvm_dir" ]; then
    for dir in "$nvm_dir"/*/bin/npm; do
        if [ -x "$dir" ]; then
            current_version="$("$dir" -v 2>/dev/null)"
            if [[ "$current_version" == ${min_required_version%%.*}.* ]]; then
                if [ -z "$highest_version" ] || dpkg --compare-versions "$current_version" gt "$highest_version"; then
                    highest_version="$current_version"
                    npx_exec="${dir%/npm}/npx"
                fi
            fi
        fi
    done
else
    echo "No NVM installations found. Please ensure NVM is installed."
    exit 1
fi

if [ -n "$highest_version" ]; then
    echo "Highest installed NPM version of major version ${min_required_version%%.*}: $highest_version"

    if dpkg --compare-versions "$highest_version" eq "$min_required_version"; then
        echo "NPM version $highest_version is equal to the minimum required version $min_required_version."
    elif dpkg --compare-versions "$highest_version" gt "$min_required_version"; then
        echo "NPM version $highest_version is higher than the minimum required version $min_required_version."
    else
        echo "NPM version $highest_version is lower than the minimum required version $min_required_version. Please update NPM."
        exit 1
    fi
else
    echo "No NPM versions matching the required major version found. Exiting."
    exit 1
fi

export npm="$npx_exec"
