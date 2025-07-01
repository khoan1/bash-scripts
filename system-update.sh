#!/bin/bash
# system-update.sh

# This script updates system packages and performs old package cleanup

LOGFILE="/var/log/system-update.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "[$TIMESTAMP] Please run this script as root or with sudo." | tee -a "$LOGFILE"
  exit 1
fi

echo "[$TIMESTAMP] Starting system update..." | tee -a "$LOGFILE"

# Update package list
apt update >> "$LOGFILE" 2>&1  # 2>&1 means send both stderr and stdout to stdout location
echo "[$TIMESTAMP] Package list updated." | tee -a "$LOGFILE"

# Upgrade installed packages
apt upgrade -y >> "$LOGFILE" 2>&1
echo "[$TIMESTAMP] Packages upgraded." | tee -a "$LOGFILE"

# Autoremove unnecessary packages
apt autoremove -y >> "$LOGFILE" 2>&1
echo "[$TIMESTAMP] Unused packages removed." | tee -a "$LOGFILE"

# Clean up cached package files
apt clean >> "$LOGFILE" 2>&1
echo "[$TIMESTAMP] Package cache cleaned." | tee -a "$LOGFILE"

echo "[$TIMESTAMP] System update completed." | tee -a "$LOGFILE"
