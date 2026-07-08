#!/bin/bash
# customize_rootfs.sh (v3) — runs inside the chroot during ISO build
set -euo pipefail

echo "[customize] Applying ArchNesic v3 customizations…"

# ── 1. Enable amnesic services ────────────────────────
systemctl enable archnesic-init.service
systemctl enable wipe-memory.service
systemctl enable disable-swap.service
systemctl enable tor.service
systemctl enable tor-watchdog.timer

# ── 2. Mask unnecessary services (reduce attack surface) ─
for svc in \
  systemd-timesyncd.service \
  systemd-journald-audit.socket \
  systemd-coredump.socket \
  bluetooth.service bluetooth.target \
  cups.service cups.socket cups.path \
  avahi-daemon.service avahi-daemon.socket \
  pkgfile-update.timer \
  systemd-fsck-root.service \
  systemd-fsck@.service; do
  systemctl mask "$svc" 2>/dev/null || true
done

# ── 3. Configure sudo (no password for wheel) ─────────
sed -i 's/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' \
  /etc/sudoers

# ── 4. Set root password ──────────────────────────────
echo "root:arch" | chpasswd

# ── 5. Set hostname ────────────────────────────────────
echo "archnesic" > /etc/hostname

# ── 6. Remove machine-id (regenerated on each boot) ──
rm -f /etc/machine-id /var/lib/dbus/machine-id

# ── 7. Copy skel to root home ─────────────────────────
cp -r /etc/skel/. /root/
chown -R root:root /root || true

# ── 8. Prepare Tor hidden service directory ──────────
mkdir -p /var/lib/tor/ssh_hidden_service
chown -R tor:tor /var/lib/tor/ssh_hidden_service
chmod 700 /var/lib/tor/ssh_hidden_service

# ── 10. Enable Plymouth boot splash ──────────────────
systemctl enable plymouth-start.service 2>/dev/null || true
systemctl enable plymouth-quit.service 2>/dev/null || true
systemctl enable plymouth-read-write.service 2>/dev/null || true

# ── 11. Clean package cache ────────────────────────────
pacman -Scc --noconfirm || true

echo "[customize] v3 customizations complete."
