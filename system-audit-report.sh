#!/bin/bash
# system-audit-report.sh

# This script generates a report on current users, open ports, sudoers, and installed packages

REPORT_FILE="/var/log/system-audit-report-$(date +%F-%H%M%S).log"

echo "=== System Audit Report - $(date) ===" > "$REPORT_FILE"

# 1. Current logged-in users
echo -e "\n--- Current Logged-in Users ---" >> "$REPORT_FILE"
who >> "$REPORT_FILE"

# 2. Open TCP ports and listening services
echo -e "\n--- Open TCP Ports and Listening Services ---" >> "$REPORT_FILE"
sudo ss -tuln | grep LISTEN >> "$REPORT_FILE"

# 3. Sudoers list
echo -e "\n--- Users with Sudo Privileges ---" >> "$REPORT_FILE"
# List users in sudo group
getent group sudo | awk -F: '{print $4}' | tr ',' '\n' >> "$REPORT_FILE"
# List users in /etc/sudoers.d files (if any)
if [ -d /etc/sudoers.d ]; then
    echo -e "\nAdditional sudoers from /etc/sudoers.d:" >> "$REPORT_FILE"
    sudo cat /etc/sudoers.d/* 2>/dev/null | grep -v '^#' | grep -v '^$' >> "$REPORT_FILE"
fi

# 4. Installed packages
echo -e "\n--- Installed Packages ---" >> "$REPORT_FILE"
dpkg-query -W -f='${Package} ${Version}\n' >> "$REPORT_FILE"

echo -e "\n=== End of Report ===" >> "$REPORT_FILE"

echo "System Audit report saved to $REPORT_FILE"
