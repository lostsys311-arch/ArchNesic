#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "========================================"
echo "  ArchNesic — build script"
echo "========================================"

if command -v docker &>/dev/null; then
    echo "[1/2] Building Docker image..."
    docker build -t archnesic-builder "$ROOT"

    echo "[2/2] Building ISO..."
    mkdir -p "$ROOT/archlive/out"
    docker run --privileged \
        -v "$ROOT/archlive:/build" \
        -v "$ROOT/archlive/out:/out" \
        archnesic-builder

    echo ""
    ISO=$(ls "$ROOT/archlive/out/"*.iso 2>/dev/null | head -1)
    if [ -n "$ISO" ]; then
        du -h "$ISO"
        echo "ISO: $ISO"
    fi
    echo "Done."
else
    echo "Docker not found. Build directly on Arch Linux:"
    echo ""
    echo "  sudo pacman -S archiso"
    echo "  cd \"$ROOT/archlive\""
    echo "  sudo mkarchiso -v ."
    echo ""
    echo "Output: $ROOT/archlive/out/archnesic-*.iso"
fi