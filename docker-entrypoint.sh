#!/bin/sh
set -e

# If no arguments provided, default to executing radmc3d
if [ $# -eq 0 ]; then
    exec radmc3d
fi

# If the first argument is an existing command in PATH, execute directly
if command -v "$1" >/dev/null 2>&1; then
    exec "$@"
fi

# Otherwise, pass arguments directly to radmc3d
exec radmc3d "$@"
