#!/usr/bin/env bash

basePath=$(dirname $0)

csharpDir=$(readlink -f $HOME/.vscode/extensions/ms-dotnettools.csharp-*)
omnisharpDir=$(readlink -f $csharpDir/.omnisharp/*)

function nb() {
  nix-build --no-out-link '<nixpkgs>' -A "$@"
}

function patchelf {
  $(nb patchelf)/bin/patchelf "$@"
}

function monoPatch() {
  mono="$omnisharpDir/bin/mono"
  patchelf "$mono" --set-interpreter $(nb glibc)/lib/ld-linux-x86-64.so.2 --set-rpath $(nb zlib)/lib:$(nb gcc-unwrapped.lib)/lib
}

function vsdbgPatch() {
  vsdbg="$csharpDir/.debugger/vsdbg"
  vsdbg_ui="$vsdbg-ui"

  echo "Patching $vsdbg"
  patchelf --set-interpreter $(nb glibc)/lib/ld-linux-x86-64.so.2 --set-rpath $(nb gcc-unwrapped.lib)/lib "$vsdbg"

  echo "Patching $vsdbg_ui"
  patchelf --set-interpreter $(nb glibc)/lib/ld-linux-x86-64.so.2 --set-rpath $(nb gcc-unwrapped.lib)/lib "$vsdbg_ui"

  # Wrap vsdbg
  vsdbg_patched="$(dirname $vsdbg)/vsdbg_patched"
  echo "Wrapping $vsdbg -> $vsdbg_patched"

  mv "$vsdbg" "$vsdbg_patched"
  cat > $vsdbg <<EOF
#!/usr/bin/env bash
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
export LD_LIBRARY_PATH="$(dirname $vsdbg)"
$vsdbg_patched "\$@"
EOF
  chmod +x "$vsdbg"

  # Wrap vsdbg-ui
  vsdbg_ui_patched="$(dirname $vsdbg)/vsdbg-ui_patched"
  echo "Wrapping $vsdbg_ui -> $vsdbg_ui_patched"

  mv "$vsdbg_ui" "$vsdbg_ui_patched"
  cat > $vsdbg_ui <<EOF
#!/usr/bin/env bash
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
export LD_LIBRARY_PATH=$(dirname $vsdbg_ui):\$(nix-build --no-out-link '<nixpkgs>' -A icu.out)/lib:\$(nix-build --no-out-link '<nixpkgs>' -A openssl.out)/lib
$vsdbg_ui_patched "\$@"
EOF
  chmod +x "$vsdbg_ui"
}

function omnisharpPatch() {
  patch "$omnisharpDir/run" run.patch
}

if [ -d "$omnisharpDir" ]; then
  monoPatch
  vsdbgPatch
  omnisharpPatch
else
  echo "Invalid directory: '$omnisharpDir'"
fi
