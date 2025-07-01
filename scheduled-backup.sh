#!/bin/bash
# scheduled-backup.sh

# This script backs up /etc and /home folders
# Script allows optional remote upload to specified Cloud folder

# Backup Configuration
DATE=$(date +%F)
BACKUP_DIR="/backup/$DATE"
LOG_FILE="/var/log/backup-$DATE.log"
ETC_DIR="/etc"
HOME_DIR="/home"
REMOTE_USER="user"          # enter your user
REMOTE_HOST="192.168.1.100" # enter your Cloud server IP
REMOTE_DIR="/remote/backup" # enter your backup folder path

# Log Function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Start Backup
log "=== Starting backup ==="

# Create the backup directory
mkdir -p "$BACKUP_DIR"
log "Created backup directory: $BACKUP_DIR"


# Backup /etc folder
log "Backing up /etc..."
if tar -czf "$BACKUP_DIR/etc-backup.tar.gz" "$ETC_DIR"; then
    log "/etc backup successful."
else
    log "ERROR: Failed to back up /etc"
fi

# Backup /home folder
log "Backing up /home..."
if tar -czf "$BACKUP_DIR/home-backup.tar.gz" "$HOME_DIR"; then
    log "/home backup successful."
else
    log "ERROR: Failed to back up /home"
fi

# Optional: Remote Upload to Cloud server
read -rp "Do you want to upload the backup to a remote server? (y/n): " UPLOAD

if [[ "$UPLOAD" =~ ^[Yy]$ ]]; then
    log "Uploading backup to $REMOTE_HOST..."
    if scp -r "$BACKUP_DIR" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"; then
        log "Upload successful."
    else
        log "ERROR: Failed to upload backup to remote server."
    fi
else
    log "Upload skipped."
fi

log "=== Backup complete ==="
