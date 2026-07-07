# ⟐ Amnesic Wipe

**Secure · Amnesic · RAM-only · Arch-based Linux**

A live Linux distribution that leaves zero trace. Like Tails, but built on Arch with an even smaller attack surface, full memory scrubbing, and a **Sway** desktop. Runs entirely in RAM.

## Features

| Feature | Amnesic Wipe |
|---|---|
| **Amnesic** | Everything runs in RAM (`toram`). Nothing survives reboot. |
| **Memory scrub** | All volatile memory is overwritten before shutdown/reboot. |
| **MAC randomisation** | Every network interface gets a random MAC on boot. |
| **Tor by default** | All traffic is forced through Tor via transparent proxy. |
| **Firewall** | Outgoing non-Tor traffic is blocked by `iptables`. |
| **Kernel hardening** | `linux-hardened` + lockdown + KASLR + slab_nomerge + init_on_alloc/free + BPF disabled + more. |
| **No swap** | Swap is disabled. No data ever written to disk. |
| **Lightweight** | ~500 MB ISO. Sway + Wayland for a modern, fast desktop. |
| **Stylish** | Tokyo Night theme, JetBrains Mono font, Sway/waybar/wofi. |
| **Free builds** | GitHub Actions builds the ISO for you at no cost. |

## How to get the ISO

### Option A — Download from GitHub Actions (FREE)

1. Fork this repo on GitHub
2. Go to **Actions** → **Build amnesic-wipe ISO** → **Run workflow**
3. Wait ~5–10 minutes
4. Download the `amnesic-wipe-iso` artifact
5. Write to USB: `dd if=amnesic-wipe-*.iso of=/dev/sdX bs=4M status=progress && sync`

### Option B — Build locally

```bash
# On Arch Linux (or any distro with Docker)
git clone https://github.com/yourname/amnesic-wipe
cd amnesic-wipe

# Using Docker
docker build -t amnesic-builder .
docker run --privileged -v "$PWD/archlive/out:/out" amnesic-builder

# Or directly (Arch only)
sudo pacman -S archiso
cd archlive
sudo mkarchiso -v .
```

### Option C — Use raw initramfs (experimental)

```bash
sudo ./build-bare.sh   # creates amnesic-wipe.img
```

## Boot options

| Option | Description |
|---|---|
| `toram` | (Default) Copy whole system to RAM, eject media |
| `quiet` | Reduced boot spam |
| `loglevel=3` | Even quieter |
| `mitigations=auto` | CPU vulnerability mitigations |
| `lockdown=confidentiality` | Kernel lockdown mode |
| `slab_nomerge` | Prevent slab merging |

## Security notes

- This is **not** a Tails replacement. Tails has years of design, audit, and real-world testing.
- The kernel hardening, Tor firewall, and memory scrubbing provide strong privacy, but **no system is perfect**.
- Always verify the ISO checksum.

## Credits

- [Arch Linux](https://archlinux.org) / [archiso](https://wiki.archlinux.org/title/archiso)
- [Tor Project](https://www.torproject.org)
- [Sway](https://swaywm.org) / [wlroots](https://gitlab.freedesktop.org/wlroots/wlroots)
- [Tokyo Night](https://github.com/enkia/tokyo-night-vscode-theme) colour palette
