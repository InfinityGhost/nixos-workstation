#!/usr/bin/env bash

ROOT_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"
FILE="$ROOT_DIR/default.nix"

new_version="$(curl -s "https://api.github.com/repos/ppy/osu/releases?per_page=1" | jq -r '.[0].name')"
new_url="https://github.com/ppy/osu/releases/download/${new_version}/osu.AppImage"

SRI_HASH="$(nix-prefetch -q fetchurl --url "$new_url")"

sed -i -e "s|version = \"[0-9]*\.[0-9]*\.[0-9]*\"|version = \"$new_version\"|g" "$FILE"
sed -i -e "s|hash = \".*\"|hash = \"$SRI_HASH\"|g" "$FILE"
