#!/bin/bash
# fail2ban-monitor.sh

# This script monitors the fail2ban.log and logs all bans recorded in fail2ban.log
# Script will record all ban records and also send alerts if the number of bans crosses the set threshold

# Config
LOG_FILE="/var/log/fail2ban.log"
MONITOR_LOG="/var/log/fail2ban-monitor.log"
LAST_CHECK="/tmp/fail2ban-last-check"
THRESHOLD=5  # Number of bans to flag as possible brute-force

# Get the last timestamp checked
if [ ! -f "$LAST_CHECK" ]; then
    echo "1970-01-01 00:00:00" > "$LAST_CHECK"
fi

LAST_TIMESTAMP=$(cat "$LAST_CHECK")

# Extract new bans since last check
NEW_BANS=$(awk -v last="$LAST_TIMESTAMP" '$0 > last && /Ban/' "$LOG_FILE")

# Count and log
BAN_COUNT=$(echo "$NEW_BANS" | wc -l)

if [ "$BAN_COUNT" -gt 0 ]; then
    echo "[$(date)] Detected $BAN_COUNT new ban(s) since last check" >> "$MONITOR_LOG"
    echo "$NEW_BANS" >> "$MONITOR_LOG"
    
    # Optional: Trigger alert if too many bans
    if [ "$BAN_COUNT" -ge "$THRESHOLD" ]; then
        echo "[$(date)] ALERT: $BAN_COUNT bans detected. Possible brute-force attack." >> "$MONITOR_LOG"
    fi
fi

# Update last check timestamp
date '+%Y-%m-%d %H:%M:%S' > "$LAST_CHECK"
