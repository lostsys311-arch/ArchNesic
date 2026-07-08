#!/bin/bash
# vim: set ft=sh:
iso_name="archnesic"
iso_label="ARNESIC_$(date +%Y%m)"
iso_publisher="ArchNesic"
iso_application="ArchNesic v3 — secure, amnesic, RAM-only Linux"
iso_version="$(date +%Y.%m.%d)"
install_dir="arnesic"
buildmodes=('iso')
bootmodes=(
  'bios.syslinux'
  'uefi.systemd-boot'
)
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '22')
file_permissions=(
  ["/root"]="0:0:700"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/usr/local/bin/archnesic-init.sh"]="0:0:755"
  ["/etc/iptables/tor.rules"]="0:0:600"
  ["/usr/local/bin/wipe-memory"]="0:0:755"
  ["/usr/local/bin/killswitch"]="0:0:755"
  ["/usr/local/bin/onion-ssh-address"]="0:0:755"
  ["/usr/local/bin/tor-status.sh"]="0:0:755"
  ["/usr/local/bin/panic-overlay.sh"]="0:0:755"
  ["/usr/local/bin/tor-watchdog.sh"]="0:0:755"
)
