# WARNING: THIS PROJECT IS IN BETA. I AM NOT RESPONSIBLE FOR DESTROYED DATA, LAPTOPS, OR PCS. TEST IN A OLD LAPTOP FIRST BEFORE REAL HARDWARE.
# ⟐ ArchNesic v3

**Secure · Amnesic · RAM-only · Arch-based Linux**

A live Linux distribution that leaves zero trace. Like Tails, but built on Arch with an even smaller attack surface, full memory scrubbing, and a **Sway** desktop. Runs entirely in RAM.

## Login credentials

| User | Password |
|---|---|
| `root` | `arch` |

Auto-login on tty1 with full root access.

## Features (v3)

| Feature | ArchNesic v3 |
|---|---|
| **Amnesic** | Everything runs in RAM (`toram`). Nothing survives reboot. |
| **Memory scrub** | All volatile memory is overwritten before shutdown/reboot. |
| **MAC + hostname randomisation** | Random MAC on every interface + random hostname each boot. |
| **Tor transparent proxy** | All TCP traffic auto-redirected through Tor via iptables NAT. No app config needed. |
| **DNS over Tor** | All DNS queries forced through Tor's DNSPort (5353). No leaks. |
| **Tor status in waybar** | Live indicator shows connected/bootstrapping/off — click for exit IP. |
| **Tor watchdog** | Auto-monitors Tor health every 30s; triggers killswitch if Tor dies. |
| **Stream isolation** | 5 separate SOCKS ports (9050–9090), each with different circuit isolation flags. |
| **Unsafe browser** | Firefox with direct networking (no Tor) — runs as UID 1000, clearly warned. `$mod+Shift+B` |
| **Onion SSH** | Auto-generated `.onion` hidden service — SSH into the box via Tor. |
| **Kill switch** | `$mod+Escape` — drops all interfaces + stops Tor + fullscreen panic overlay. |
| **Rofi launcher** | Replaces wofi — Tokyo Night themed, better search. `$mod+D` |
| **Dunst notifications** | Desktop notifications with Tokyo Night styling. |
| **Virtual keyboard** | `wvkbd` — `$mod+Shift+V` to toggle. Bypasses HW keyloggers. |
| **Screen lock** | Auto-locks after 5 min idle. `$mod+Shift+L` to lock. Swaylock with Tokyo Night. |
| **USB armoring** | USB mass storage blocked after boot (HID/keyboard still works). |
| **Firewall** | iptables + nftables. Non-Tor traffic blocked. UID 1000 (unsafe) exempted. |
| **Plymouth boot splash** | Animated boot splash hides kernel messages. |
| **Kernel hardening** | `linux-hardened` + lockdown + KASLR + slab_nomerge + init_on_alloc/free + BPF disabled + more. |
| **No swap** | Swap disabled. No data ever written to disk. |
| **Lightweight** | ~550 MB ISO. Sway + Wayland, modern fast desktop. |
| **Stylish** | Tokyo Night theme, JetBrains Mono Nerd Font, Rofi/Waybar/Dunst all themed. |
| **Free builds** | GitHub Actions builds the ISO for you at no cost. |

## How to get the ISO

### Option A — Download from GitHub Actions (FREE)

1. Fork this repo on GitHub
2. Go to **Actions** → **Build ArchNesic ISO** → **Run workflow**
3. Wait ~5–10 minutes
4. Download the `archnesic-iso` artifact
5. Write to USB:
   ```bash
   # Manual
   dd if=archnesic-*.iso of=/dev/sdX bs=4M status=progress && sync

   # Or use the installer script (lists devices, asks confirmation)
   ./install-usb.sh
   ```

### Option B — Build locally

```bash
# On Arch Linux (or any distro with Docker)
git clone https://github.com/lostsys311-arch/ArchNesic
cd ArchNesic

# Using Docker
docker build -t archnesic-builder .
docker run --privileged \
  -v "$PWD/archlive:/build" \
  -v "$PWD/archlive/out:/out" \
  archnesic-builder

# Or directly (Arch only)
sudo pacman -S archiso
cd archlive
sudo mkarchiso -v .
```

## Boot options

| Option | Description |
|---|---|
| `toram` | (Default) Copy system to RAM, eject media |
| `quiet` | Reduced boot spam |
| `loglevel=3` | Even quieter |
| `mitigations=auto` | CPU vulnerability mitigations |
| `lockdown=confidentiality` | Kernel lockdown mode |
| `slab_nomerge` | Prevent slab merging |

### Console helpers

| Command | What it does |
|---|---|
| `onion-address` | Print the SSH `.onion` address for this session |
| `killswitch` | Drop all network interfaces + stop Tor |
| `lock` | Lock the screen immediately |
| `unsafe` | Launch unsafe browser (no Tor) |
| `tor-test` | Test Tor connectivity and show exit IP |
| `watchdog-status` | Check Tor watchdog timer status |

### Keybindings

| Binding | Action |
|---|---|
| `$mod+Return` | Open terminal (foot) |
| `$mod+D` | App launcher (rofi) |
| `$mod+Shift+B` | Unsafe browser (no Tor) |
| `$mod+Escape` | Kill switch + panic overlay |
| `$mod+Shift+L` | Lock screen |
| `$mod+Shift+V` | Toggle virtual keyboard |
| `$mod+Q` | Kill focused window |
| `$mod+[1-5]` | Switch workspace |

## Stream isolation

Tor circuits are isolated per application via separate SOCKS ports. Point your app at one of these:

| Port | Isolation | Use case |
|---|---|---|
| `9050` | (none — default) | General / TorBirdy |
| `9060` | SOCKS auth user | Browser isolation |
| `9070` | Client address | Chat / IRC |
| `9080` | Destination port | File transfers |
| `9090` | Destination address | OnionShare / other |

Each port forces Tor to build a **separate circuit** for traffic matching that isolation group.

## Unsafe browser

The unsafe browser (Firefox) runs as UID 1000 with **direct networking** — no Tor. Use it for:
- Local router/admin panel access
- Printer configuration
- Captive portal login

It launches with a prominent warning and is visually distinct. Access via `$mod+Shift+B` or `unsafe` in terminal.

## Tor watchdog

The watchdog timer checks Tor health every 30 seconds. If Tor's SOCKS port stops responding:
1. It attempts to restart Tor automatically
2. If that fails, it triggers the killswitch (drops all interfaces)
3. A critical desktop notification is shown

## Security notes

- This is **not** a Tails replacement. Tails has years of design, audit, and real-world testing.
- The kernel hardening, Tor firewall, memory scrubbing, and stream isolation provide strong privacy, but **no system is perfect**.
- Always verify the ISO checksum.
- The `.onion` address changes on every boot — share it fresh each session.

## Credits

- [Arch Linux](https://archlinux.org) / [archiso](https://wiki.archlinux.org/title/archiso)
- [Tor Project](https://www.torproject.org)
- [Sway](https://swaywm.org) / [wlroots](https://gitlab.freedesktop.org/wlroots/wlroots)
- [Tokyo Night](https://github.com/enkia/tokyo-night-vscode-theme) colour palette
