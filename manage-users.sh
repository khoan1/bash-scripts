#!/bin/bash
# manage-users.sh

# This script creates or deletes users from a specified .txt file

# Example Usage:
# ./manage-users.sh create users.txt
# ./manage-users.sh delete users.txt

# ACTION will be "create" or "delete"
ACTION=$1
FILE=$2

# Check if ACTION or FILE is empty
if [[ -z "$ACTION" || -z "$FILE" ]]; then
  echo "Usage: $0 {create|delete} user-list-file"   # $0 is the script name
  exit 1
fi

# Check if FILE exists
if [[ ! -f "$FILE" ]]; then
  echo "File $FILE not found!"
  exit 1
fi

# Use -n to make sure loop processes last line, assuming last line is non-empty
while IFS= read -r username || [[ -n "$username" ]]; do
  # Skip empty lines or lines starting with #
  [[ -z "$username" || "$username" =~ ^# ]] && continue

  if [[ "$ACTION" == "create" ]]; then
    if id "$username" &>/dev/null; then
      echo "User $username already exists. Skipping..."
    else
      echo "Creating user $username..."
      useradd -m "$username" && echo "User $username created."
    fi
  elif [[ "$ACTION" == "delete" ]]; then
    if id "$username" &>/dev/null; then
      echo "Deleting user $username..."
      userdel -r "$username" && echo "User $username deleted."
    else
      echo "User $username does not exist. Skipping..."
    fi
  else
    echo "Invalid action: $ACTION. Use 'create' or 'delete'."
    exit 1
  fi
done < "$FILE"
