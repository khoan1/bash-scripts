#!/bin/bash
# password-expiry-reminder.sh

# This script checks if user password is under set threshold expiry date
# If true, script will send email to user to remind and log info

# Configuration
THRESHOLD_DAYS=7
EMAIL_DOMAIN="yourdomain.com"   # insert your domain
LOG_FILE="/var/log/password-expiry-reminder.log"

# Ensure log file exists
touch "$LOG_FILE"

# Get today's date in epoch time
TODAY=$(date +%s)

# Read user list line-by-line
cut -f1 -d: /etc/passwd | while IFS= read -r user; do
    # Skip if user_id does not exist
    if ! user_id=$(id -u "$user" 2>/dev/null); then
        continue
    fi

    # Skip system users which usually have ID less than 1000
    if [ "$user_id" -lt 1000 ]; then
        continue
    fi

    # Get password expiration date
    EXPIRY_DATE=$(chage -l "$user" | grep "Password expires" | cut -d: -f2 | xargs)

    # Check if password never expires or is empty
    if [[ "$EXPIRY_DATE" == "never" || -z "$EXPIRY_DATE" ]]; then
        continue
    fi

    # Convert expiry date to epoch time
    if ! EXPIRY_EPOCH=$(date -d "$EXPIRY_DATE" +%s 2>/dev/null); then
        echo "$(date) - Could not parse expiry date for user $user" >> "$LOG_FILE"
        continue
    fi

    # Calculate days left
    DAYS_LEFT=$(( (EXPIRY_EPOCH - TODAY) / 86400 ))

    if [ "$DAYS_LEFT" -le "$THRESHOLD_DAYS" ] && [ "$DAYS_LEFT" -ge 0 ]; then
        EMAIL="$user@$EMAIL_DOMAIN"
        echo "Hello $user, your password will expire in $DAYS_LEFT day(s). Please change it soon." | \
            mail -s "Password Expiry Reminder" "$EMAIL"

        echo "$(date) - Reminder sent to $user ($EMAIL), expires in $DAYS_LEFT day(s)" >> "$LOG_FILE"
    fi
done

