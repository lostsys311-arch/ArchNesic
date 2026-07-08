#!/bin/bash
# tor-watchdog.sh — monitors Tor health, blocks traffic if Tor dies
# Called by tor-watchdog.service every 30 seconds

set -euo pipefail

TOR_SOCKS="127.0.0.1:9050"
WATCHDOG_FILE="/run/tor-watchdog/status"

mkdir -p /run/tor-watchdog

# Check if Tor SOCKS port is responding
if timeout 3 bash -c "echo > /dev/tcp/127.0.0.1/9050" 2>/dev/null; then
  # Tor is alive — ensure network is up
  echo "alive" > "$WATCHDOG_FILE"
  exit 0
fi

# Tor is down — try to restart it
systemctl is-active tor &>/dev/null && NEED_RESTART=1 || NEED_RESTART=0

if [ "$NEED_RESTART" = "1" ]; then
  # Tor process exists but port is gone — restart
  systemctl restart tor 2>/dev/null || true
  sleep 5
  if timeout 3 bash -c "echo > /dev/tcp/127.0.0.1/9050" 2>/dev/null; then
    echo "restored" > "$WATCHDOG_FILE"
    exit 0
  fi
fi

# Tor is dead — trigger killswitch
echo "dead" > "$WATCHDOG_FILE"
notify-send -u critical "⛔ TOR WATCHDOG" "Tor is down. Blocking all traffic." -t 5000

# Run the killswitch
/usr/local/bin/killswitch 2>/dev/null || true
