#!/usr/bin/env bash

set -euo pipefail

start=${1:-1}

mapfile -d '' files < <(
    find . -maxdepth 1 -type f -name '[0-9][0-9][0-9]-*' -printf '%f\0' |
    sort -zr
)

count=${#files[@]}

# First pass: temporary names
for ((i=0; i<count; i++)); do
    mv -- "${files[i]}" ".tmp_reverse_$i"
done

# Second pass: assign new numbering
for ((i=0; i<count; i++)); do
    mv -- ".tmp_reverse_$i" \
        "$(printf '%03d' "$((start+i))")-${files[i]#*-}"
done
