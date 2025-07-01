#!/bin/bash
# disk-usage-alert.sh

# Configurable variables
THRESHOLD=80           # Percentage usage threshold (e.g., 80%)
PARTITION="/"          # Partition to check
EMAIL="your.email@example.com"  # Recipient email 

# Get disk usage percentage of the partition (no % sign)
USAGE=$(df -h "$PARTITION" | awk 'NR==2 {print $5}' | sed 's/%//')

# Get hostname for email body
HOSTNAME=$(hostname)

if [ "$USAGE" -ge "$THRESHOLD" ]; then
    SUBJECT="Disk Usage Alert on $HOSTNAME: $USAGE% used"
    BODY="Warning: The disk usage on partition $PARTITION has reached $USAGE% which is above the threshold of $THRESHOLD%.\n\nPlease take action to free up space."

    echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"
    echo "$(date): Alert sent. Disk usage is at $USAGE%." 
else
    echo "$(date): Disk usage is at $USAGE%, below threshold $THRESHOLD%."
fi
