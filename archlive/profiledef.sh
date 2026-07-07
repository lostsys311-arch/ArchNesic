#!/bin/bash
# vim: set ft=sh:

iso_name="amnesic-wipe"
iso_label="AWIPE_$(date +%Y%m)"
iso_publisher="Amnesic Wipe Project"
iso_application="Amnesic Wipe — secure, amnesic, RAM-only Linux"
iso_version="$(date +%Y.%m.%d)"
install_dir="awipe"
buildmodes=('iso')
bootmodes=(
  'bios.syslinux.mbr'
  'bios.syslinux.eltorito'
  'uefi-x64.systemd-boot.esp'
  'uefi-x64.systemd-boot.eltorito'
)
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '22')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/root"]="0:0:700"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/usr/local/bin/amnesic-init.sh"]="0:0:755"
  ["/etc/iptables/tor.rules"]="0:0:600"
  ["/usr/local/bin/wipe-memory"]="0:0:755"
)
