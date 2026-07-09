#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "========================================"
echo "  ArchNesic — build script"
echo "========================================"

ARCHLIVE="$ROOT/archlive"

if command -v docker &>/dev/null; then
    echo "[1/2] Building Docker image..."
    docker build -t archnesic-builder "$ROOT"

    echo "[2/2] Building ISO..."
    mkdir -p "$ARCHLIVE/out"
    docker run --privileged \
        --volume "$ARCHLIVE:/build:ro" \
        --volume "$ARCHLIVE/out:/out" \
        archnesic-builder

    echo ""
    ISO=$(ls "$ARCHLIVE/out/"*.iso 2>/dev/null | head -1)
    if [ -n "$ISO" ]; then
        du -h "$ISO"
        echo "ISO: $ISO"
    fi
    echo "Done."
else
    echo "Docker not found. Build directly on Arch Linux:"
    echo ""
    echo "  sudo pacman -S archiso"
    echo "  cd \"$ARCHLIVE\""
    echo "  sudo mkarchiso -v ."
    echo ""
    echo "Output: $ARCHLIVE/out/archnesic-*.iso"
fi