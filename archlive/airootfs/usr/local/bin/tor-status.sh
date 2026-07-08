#!/bin/bash
# tor-status.sh — output Tor status for Waybar
# Returns JSON: {"text": "▲", "class": "connected|bootstrapping|off", "tooltip": "..."}

set -euo pipefail

TOR_SOCKS="127.0.0.1:9050"
CHECK_URL="https://check.torproject.org/api/ip"

if ! command -v curl &>/dev/null; then
  echo '{"text":"?","class":"off","tooltip":"curl not found"}'
  exit 0
fi

# First check if Tor's SOCKS port is listening
if ! timeout 2 bash -c "echo > /dev/tcp/127.0.0.1/9050" 2>/dev/null; then
  echo '{"text":"⬤","class":"off","tooltip":"Tor not running"}'
  exit 0
fi

# Try to get Tor circuit info via the control port
CIRCUITS=""
if timeout 2 bash -c "echo > /dev/tcp/127.0.0.1/9151" 2>/dev/null; then
  CIRCUITS=$(echo -e "AUTHENTICATE\r\nGETINFO circuit-status\r\nQUIT\r\n" | timeout 2 nc 127.0.0.1 9151 2>/dev/null | grep -c "BUILT" || true)
fi

# Check if Tor can actually reach the outside world
if RESPONSE=$(timeout 5 curl --socks5 "$TOR_SOCKS" -s "$CHECK_URL" 2>/dev/null); then
  IP=$(echo "$RESPONSE" | grep -o '"IP":"[^"]*"' | cut -d'"' -f4)
  COUNTRY=$(echo "$RESPONSE" | grep -o '"Country":"[^"]*"' | cut -d'"' -f4)
  if [ -n "$IP" ]; then
    MSG="Tor ▲ ${IP}"
    [ -n "$COUNTRY" ] && MSG="${MSG} (${COUNTRY})"
    [ -n "$CIRCUITS" ] && MSG="${MSG} | ${CIRCUITS} circuits"
    echo "{\"text\":\"▲\",\"class\":\"connected\",\"tooltip\":\"${MSG}\"}"
    exit 0
  fi
fi

# Tor is running but not connected
MSG="Tor bootstrapping..."
[ -n "$CIRCUITS" ] && MSG="${MSG} (${CIRCUITS} circuits)"
echo "{\"text\":\"⬤\",\"class\":\"bootstrapping\",\"tooltip\":\"${MSG}\"}"
