#!/bin/bash
# log-rotation-archive.sh

# This script checks if log file exceeds max size
# If max size is exceeded, log file will be archived
# If max archive is exceeded, oldest archive will be deleted

# Configurable variables
LOG_FILE="/var/log/system-update.log"   # can change the name of log file
ARCHIVE_DIR="/var/log/archive"
MAX_SIZE=1048576  # 1MB in bytes
MAX_ARCHIVES=5

# Make sure archive directory exists
mkdir -p "$ARCHIVE_DIR"

# Check if log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Log file does not exist: $LOG_FILE"
    exit 1
fi

# Get the current log file size in bytes
LOG_SIZE=$(stat -c%s "$LOG_FILE")

# Rotate if size exceeds MAX_SIZE
if [ "$LOG_SIZE" -ge "$MAX_SIZE" ]; then
    TIMESTAMP=$(date +'%Y%m%d-%H%M%S')
    ARCHIVE_FILE="$ARCHIVE_DIR/$(basename $LOG_FILE).$TIMESTAMP"

    # Move (archive) current log file
    mv "$LOG_FILE" "$ARCHIVE_FILE"

    # Create a new empty log file
    touch "$LOG_FILE"
    
    echo "Rotated log file to $ARCHIVE_FILE"

    # Compress archived log to save space (optional)
    gzip "$ARCHIVE_FILE"
    
    echo "Compressed $ARCHIVE_FILE to $ARCHIVE_FILE.gz"

    # Count number of archives using find
    NUM_ARCHIVES=$(find "$ARCHIVE_DIR" -maxdepth 1 -type f -name "$(basename "$LOG_FILE").*.gz" | wc -l)

    if [ "$NUM_ARCHIVES" -gt "$MAX_ARCHIVES" ]; then
        TO_DELETE=$((NUM_ARCHIVES - MAX_ARCHIVES))
        # Find, sort by modification time, get files to delete, and remove them safely
        find "$ARCHIVE_DIR" -maxdepth 1 -type f -name "$(basename "$LOG_FILE").*.gz" -printf '%T@ %p\n' | \
            sort -n | head -n "$TO_DELETE" | awk '{print $2}' | xargs -r rm -f
        echo "Deleted $TO_DELETE old archives"
    fi
else
    echo "Log file size ($LOG_SIZE bytes) under limit ($MAX_SIZE bytes), no rotation needed."
fi
