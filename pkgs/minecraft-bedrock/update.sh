#!/usr/bin/env bash

ROOT_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"
FILE="$ROOT_DIR/default.nix"
REPO="minecraft-linux/appimage-builder"
arch="x86_64"

tag="$(curl -s "https:/api.github.com/repos/$REPO/releases?per_page=1" | jq -r '.[0].tag_name')"

file="Minecraft_Bedrock_Launcher-$arch-${tag/-/.}.AppImage"
new_url="https://github.com/$REPO/releases/download/$tag/$file"
sri_hash="$(nix-prefetch -q fetchurl --url "$new_url")"

sed -i -e "s|version = \".*\"|version=\"$tag\"|g" "$FILE"
sed -i -e "s|url = \"https:\/\/.*\"|url = \"$new_url\"|g" "$FILE"
sed -i -e "s|hash = \".*\"|hash = \"$sri_hash\"|g" "$FILE"
