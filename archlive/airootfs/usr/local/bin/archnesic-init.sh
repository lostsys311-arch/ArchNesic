#!/bin/bash
# archnesic-init.sh — first-boot initialization
set -euo pipefail

log() { echo "[archnesic] $*"; }

# ------------------------------------------------------------------
# 1.  Wipe any stray data from previous boots (tmpfs is fresh, but
#     check for leftover block-device artifacts)
# ------------------------------------------------------------------
log "Sanitizing volatile directories…"
for d in /tmp /var/tmp /run /var/log; do
  if mountpoint -q "$d" 2>/dev/null; then
    rm -rf "$d"/* "$d"/.[!.]* 2>/dev/null || true
  fi
done

# ------------------------------------------------------------------
# 2.  Randomise MAC addresses on all ethernet / Wi-Fi interfaces
# ------------------------------------------------------------------
log "Randomising MAC addresses…"
for iface in /sys/class/net/*/; do
  iface="$(basename "$iface")"
  [[ "$iface" = "lo" ]] && continue
  if command -v macchanger &>/dev/null; then
    ip link set "$iface" down 2>/dev/null || true
    macchanger -r "$iface" 2>/dev/null && log "  $iface → randomised"
    ip link set "$iface" up 2>/dev/null || true
  elif command -v ip &>/dev/null; then
    # fallback: generate random MAC in kernel
    ip link set "$iface" down 2>/dev/null || true
    ip link set "$iface" address 02:$(openssl rand -hex 5 | sed 's/\(..\)/\1:/g;s/.$//') 2>/dev/null || true
    ip link set "$iface" up 2>/dev/null || true
  fi
done

# ------------------------------------------------------------------
# 3.  Load iptables / nftables firewall rules
# ------------------------------------------------------------------
log "Loading firewall rules…"
if command -v iptables-restore &>/dev/null; then
  iptables-restore < /etc/iptables/tor.rules 2>/dev/null || true
fi
# Block all non-Tor traffic at kernel level
sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w net.ipv4.conf.all.log_martians=1

# ------------------------------------------------------------------
# 4.  Enforce kernel-hardening sysctls (duplicates /etc/sysctl.d/)
# ------------------------------------------------------------------
log "Applying kernel hardening…"
sysctl -w kernel.kptr_restrict=2
sysctl -w kernel.dmesg_restrict=1
sysctl -w kernel.printk=3 3 3 3
sysctl -w kernel.unprivileged_bpf_disabled=1
sysctl -w net.core.bpf_jit_enable=0
sysctl -w net.ipv4.tcp_syncookies=1
sysctl -w net.ipv4.conf.all.forwarding=0
sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.all.secure_redirects=0
sysctl -w net.ipv6.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w kernel.randomize_va_space=2
sysctl -w fs.protected_hardlinks=1
sysctl -w fs.protected_symlinks=1
sysctl -w fs.protected_fifos=2
sysctl -w fs.protected_regular=2
sysctl -w kernel.unprivileged_userns_clone=0

# ------------------------------------------------------------------
# 5.  Restart dhcpcd on randomised MACs
# ------------------------------------------------------------------
if command -v dhcpcd &>/dev/null; then
  log "Restarting dhcpcd…"
  systemctl restart dhcpcd 2>/dev/null || dhcpcd -q 2>/dev/null || true
fi

# ------------------------------------------------------------------
# 6.  Start Tor transparent proxy
# ------------------------------------------------------------------
if command -v tor &>/dev/null; then
  log "Starting Tor…"
  systemctl enable --now tor 2>/dev/null || true
fi

# ------------------------------------------------------------------
# 7.  Ensure /home is a tmpfs so nothing persists
# ------------------------------------------------------------------
if ! mountpoint -q /home 2>/dev/null; then
  mount -t tmpfs -o mode=0700,noexec,nosuid,nodev tmpfs /home
fi

# ------------------------------------------------------------------
# 8.  Set random hostname (amnesic — no identity)
# ------------------------------------------------------------------
RANDOM_HOSTNAME="arnesic-$(openssl rand -hex 4)"
hostname "$RANDOM_HOSTNAME"
echo "$RANDOM_HOSTNAME" > /proc/sys/kernel/hostname
log "Hostname set to $RANDOM_HOSTNAME"

# ------------------------------------------------------------------
# 9.  Unload USB storage drivers (we're in RAM, no need)
# ------------------------------------------------------------------
rmmod usb-storage 2>/dev/null || true
rmmod uas 2>/dev/null || true
log "USB storage drivers unloaded."

log "ArchNesic initialised. All data is volatile."
