#!/bin/sh
set -e

trap 'echo "Caught signal, stopping NordVPN..."; nordvpn disconnect; exit 0' HUP TERM

/etc/init.d/nordvpn start
while [ ! -S /run/nordvpn/nordvpnd.sock ]; do sleep 1; done
echo "[INFO] NordVPN daemon started. Logging in..."
nordvpn login --token "$NORDVPN_TOKEN"
echo "[INFO] Connecting to NordVPN..."
nordvpn connect
if [ -n "$NORDVPN_MESHNET" ]; then
  echo "[INFO] Enabling Meshnet..."
  nordvpn set meshnet on
fi

# Tail the daemon log
LOGFILE="/var/log/nordvpn/daemon.log"
touch "$LOGFILE"
tail -F "$LOGFILE" &
TAIL_PID=$!

# Status check loop
(
  sleep 10
  while true; do
    STATUS_LINE=$(nordvpn status 2>/dev/null | head -n1)
    if [ "$STATUS_LINE" = "Status: Connected" ]; then
      sleep 2
    else
      echo "[ERROR] VPN is not connected (status: $STATUS_LINE). Exiting."
      kill $TAIL_PID
      exit 1
    fi
  done
) &

wait