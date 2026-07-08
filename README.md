# WARNING: THIS PROJECT IS IN BETA. I AM NOT RESPONSIBLE FOR DESTROYED DATA, LAPTOPS, OR PCS. TEST IN A VM FIRST.
# ⟐ ArchNesic


**Secure · Amnesic · RAM-only · Arch-based Linux**

A live Linux distribution that leaves zero trace. Like Tails, but built on Arch with an even smaller attack surface, full memory scrubbing, and a **Sway** desktop. Runs entirely in RAM.

## Login credentials

| User | Password |
|---|---|
| `root` | `arch` |

Auto-login on tty1 with full root access.

## Features

| Feature | ArchNesic |
|---|---|---|
| **Amnesic** | Everything runs in RAM (`toram`). Nothing survives reboot. |
| **Memory scrub** | All volatile memory is overwritten before shutdown/reboot. |
| **MAC + hostname randomisation** | Random MAC on every interface + random hostname each boot. |
| **Tor by default** | All traffic forced through Tor via transparent proxy. |
| **Stream isolation** | 5 separate SOCKS ports (9050–9090), each with different circuit isolation flags. |
| **Tor bridges** | `obfs4` + `Snowflake` pluggable transports pre-installed for censorship circumvention. |
| **Onion SSH** | Auto-generated `.onion` hidden service — SSH into the box via Tor. |
| **Kill switch** | `$mod+Escape` or `killswitch` command — instantly drops all network + stops Tor. |
| **Screen lock** | Auto-locks after 5 min idle. `$mod+Shift+L` to lock manually. |
| **USB armoring** | USB mass storage blocked after boot (HID/keyboard still works). |
| **Firewall** | Outgoing non-Tor traffic blocked by `iptables`. |
| **Kernel hardening** | `linux-hardened` + lockdown + KASLR + slab_nomerge + init_on_alloc/free + BPF disabled + more. |
| **No swap** | Swap disabled. No data ever written to disk. |
| **Lightweight** | ~500 MB ISO. Sway + Wayland, modern fast desktop. |
| **Stylish** | Tokyo Night theme, JetBrains Mono font, Sway/waybar/wofi. |
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
docker run --privileged -v "$PWD/archlive/out:/out" archnesic-builder

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

## Security notes

- This is **not** a Tails replacement. Tails has years of design, audit, and real-world testing.
- The kernel hardening, Tor firewall, memory scrubbing, and v2 stream isolation provide strong privacy, but **no system is perfect**.
- Always verify the ISO checksum.
- The `.onion` address changes on every boot — share it fresh each session.

## Credits

- [Arch Linux](https://archlinux.org) / [archiso](https://wiki.archlinux.org/title/archiso)
- [Tor Project](https://www.torproject.org)
- [Sway](https://swaywm.org) / [wlroots](https://gitlab.freedesktop.org/wlroots/wlroots)
- [Tokyo Night](https://github.com/enkia/tokyo-night-vscode-theme) colour palette
