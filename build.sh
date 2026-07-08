#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "========================================"
echo "  ArchNesic — build script"
echo "========================================"
echo ""
echo "This ISO is built using archiso."
echo "Run the following to build locally:"
echo ""
echo "  sudo pacman -S archiso"
echo "  cd \"$ROOT/archlive\""
echo "  sudo mkarchiso -v ."
echo ""
echo "Or push to GitHub — the Actions workflow"
echo "at .github/workflows/build.yml will build"
echo "it for free and attach the .iso as a"
echo "downloadable artifact."
echo ""
echo "Output: $ROOT/archlive/out/archnesic-*.iso"
echo "========================================"
