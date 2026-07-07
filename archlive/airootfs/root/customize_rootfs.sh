#!/bin/bash
# customize_rootfs.sh — runs inside the chroot during ISO build
set -euo pipefail

echo "[customize] Applying amnesic-wipe customizations…"

# ── 1. Enable amnesic services ────────────────────────
systemctl enable amnesic-wipe-init.service
systemctl enable wipe-memory.service
systemctl enable disable-swap.service
systemctl enable tor.service

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

# ── 4. Create user 'user' (for desktop use) ──────────
useradd -m -G wheel -s /bin/bash olafkow 2>/dev/null || true
echo "olafkow:2015" | chpasswd

# Lock root password — no interactive root login
passwd -l root 2>/dev/null || true

# ── 5. Set hostname ────────────────────────────────────
echo "awipe" > /etc/hostname

# ── 6. Remove machine-id (regenerated on each boot) ──
rm -f /etc/machine-id /var/lib/dbus/machine-id

# ── 7. Copy skel to user home ─────────────────────────
cp -r /etc/skel/. /home/olafkow/
chown -R olafkow:olafkow /home/olafkow || true

# ── 8. Clean package cache ────────────────────────────
pacman -Scc --noconfirm || true

echo "[customize] Done."
