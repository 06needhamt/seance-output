#!/usr/bin/env bash

set -u

ROOT="${1:-.}"
mkdir -p supported unsupported

find "$ROOT" -type f -iname '*.avi' -print0 |
while IFS= read -r -d '' file; do
    echo "Testing: $file"

    # Decode the entire file without producing output.
    if ffmpeg -nostdin -v error -xerror \
        -i "$file" \
        -map 0:v? -map 0:a? \
        -f null - \
        >/dev/null 2>&1
    then
        printf '%s\n' "$file" >> supported.txt
	mv $file supported
    else
        printf '%s\n' "$file" >> unsupported.txt
        echo "  FAILED: $file"
	mv $file unsupported
    fi
done
