#!/bin/bash
# cron-status-checker.sh

# This script checks for any errored or failed cron jobs in syslog
# Script also checks if cron server is running normally

# Config
LOG_FILE="/var/log/cron-status-check.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
CRON_LOG="/var/log/syslog"  # Use /var/log/cron on some distros (like CentOS)
KEYWORD="CRON"

echo "=== Cron Status Check - $TIMESTAMP ===" >> "$LOG_FILE"

# Check for any failed cron jobs in logs (grep for 'CRON' and 'error' or 'failed')
if grep -a -q -iE "cron.*(error|fail|failed|warning)" "$CRON_LOG" 2>/dev/null; then
    echo "Errors or failures found in cron jobs" >> "$LOG_FILE"
else
    echo "No cron errors detected" >> "$LOG_FILE"
fi

# List all user cron jobs and their last run time
echo "--- Last cron job activity ---" >> "$LOG_FILE"
grep "$KEYWORD" "$CRON_LOG" 2>/dev/null | tail -n 20 >> "$LOG_FILE"

# Check for cron service status
CRON_STATUS=$(systemctl is-active cron)
if [ "$CRON_STATUS" != "active" ]; then
    echo "WARNING: Cron service is not active!" >> "$LOG_FILE"
else
    echo "Cron service is running normally." >> "$LOG_FILE"
fi

echo "=== End of Check ===" >> "$LOG_FILE"
