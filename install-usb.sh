#!/bin/bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${RED}╔══════════════════════════════════════╗${NC}"
echo -e "${RED}║     ArchNesic — USB Installer        ║${NC}"
echo -e "${RED}╚══════════════════════════════════════╝${NC}"
echo ""

# Find ISO
ISO=$(ls -1t archnesic-*.iso 2>/dev/null | head -1)
if [[ -z "$ISO" ]]; then
  echo -e "${RED}ERROR: No archnesic-*.iso found in current directory.${NC}"
  echo "Download it first from GitHub Actions."
  exit 1
fi
echo -e "ISO: ${GREEN}$ISO${NC} ($(du -h "$ISO" | cut -f1))"

# List block devices
echo ""
echo -e "${YELLOW}Available block devices:${NC}"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,MODEL | grep -E "disk|part"
echo ""

read -rp "Enter target device (e.g. sdb, sdc) — ALL DATA WILL BE DESTROYED: " DEVICE
DEVICE="/dev/$DEVICE"

if [[ ! -b "$DEVICE" ]]; then
  echo -e "${RED}ERROR: $DEVICE is not a block device.${NC}"
  exit 1
fi

echo ""
echo -e "${RED}⚠  WARNING: $DEVICE will be completely overwritten!${NC}"
read -rp "Type 'YES' to continue: " CONFIRM
if [[ "$CONFIRM" != "YES" ]]; then
  echo "Aborted."
  exit 1
fi

echo ""
echo -e "${YELLOW}Writing ISO to $DEVICE...${NC}"
sudo dd if="$ISO" of="$DEVICE" bs=4M status=progress conv=fsync
sync

echo ""
echo -e "${GREEN}✓ Done!${NC}"
echo -e "Boot from $DEVICE and choose ${YELLOW}ArchNesic${NC} in the menu."
echo ""
echo -e "WARNING: This system leaves ${RED}NO TRACE${NC} after shutdown."
echo -e "         All data is lost when you power off."
