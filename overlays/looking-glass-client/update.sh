#!/usr/bin/env bash

ROOT_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"
FILE="$ROOT_DIR/default.nix"

PACKAGE="looking-glass-client"
FLAKE_TARGET=".#nixpkgsFor.$system.$PACKAGE.src"

function getattr {
  nix eval "$FLAKE_TARGET.${@:?No attribute provided}" ${@:2} 2> /dev/null | sed 's/"//g'
}

owner="$(getattr owner)"
repo="$(getattr repo)"
url="https://api.github.com/repos/$owner/$repo/commits?per_page=1"

new_rev="${1:-$(curl -s "$url" | jq -r '.[0].sha')}"
fake_hash='sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='

sed -i "s|rev = \".*\"|rev = \"$new_rev\"|g" "$FILE"
sed -i "s|hash = \".*\"|hash = \"$fake_hash\"|g" "$FILE"

sri_hash=$(nix build $FLAKE_TARGET 2>&1 | grep 'got:' | sed 's/ //g' | cut -d ':' -f 2)
sed -i "s|hash = \".*\"|hash = \"$sri_hash\"|g" "$FILE"
