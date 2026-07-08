#!/bin/bash
# panic-overlay.sh — show fullscreen killswitch alert for 3 seconds
set -euo pipefail

notify-send -u critical -t 3000 \
  "⛔ KILLSWITCH ACTIVATED" \
  "All network interfaces dropped. Tor stopped."

# Also show a sway floating window as belt-and-suspenders
if command -v swaymsg &>/dev/null && command -v foot &>/dev/null; then
  foot --title panic-overlay -e sh -c '
    printf "\n\n\n\n"
    printf "    ╔══════════════════════════════════╗\n"
    printf "    ║                                  ║\n"
    printf "    ║   ⛔  KILLSWITCH ACTIVATED  ⛔   ║\n"
    printf "    ║                                  ║\n"
    printf "    ║   All network interfaces DOWN    ║\n"
    printf "    ║   Tor STOPPED                    ║\n"
    printf "    ║                                  ║\n"
    printf "    ║   Press any key to dismiss       ║\n"
    printf "    ║   Reboot to restore networking   ║\n"
    printf "    ║                                  ║\n"
    printf "    ╚══════════════════════════════════╝\n"
    read -r _
  ' &
  PANIC_PID=$!
  sleep 0.5
  swaymsg floating enable 2>/dev/null || true
  swaymsg sticky enable 2>/dev/null || true
  swaymsg move position center 2>/dev/null || true
  sleep 3
  kill "$PANIC_PID" 2>/dev/null || true
fi
