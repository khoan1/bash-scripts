#!/bin/bash
# ssh-login-tracker.sh

# This script uses Pluggable Authentication Modules (PAM) to track ssh login from any shell
# Script is intended to run on servers, not client


# Usage:
# Copy executable script to folder /usr/local/bin on server
# Open SSH PAM config file: sudo nano /etc/pam.d/sshd
# At the bottom of config file, add line: session optional pam_exec.so /usr/local/bin/ssh-login-tracker.sh


# Log file location
LOG_FILE="/var/log/ssh-login.log"

# Extract username and remote IP
USER_NAME=$(whoami)
REMOTE_IP="$PAM_RHOST"

# Date and hostname
DATE=$(date '+%Y-%m-%d %H:%M:%S')
HOST=$(hostname)

# Log message
echo "$DATE - SSH login detected on $HOST - User: $USER_NAME - IP: $REMOTE_IP" >> "$LOG_FILE"
