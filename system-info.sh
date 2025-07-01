#!/bin/bash
# system-info.sh

# This script displays basic system info: uptime, CPU, RAM, disk, and IP address

echo "=== System Information ==="
echo "Hostname: $(hostname)"
echo "Date: $(date)"

echo -e "\n--- Uptime ---"
uptime -p

echo -e "\n--- CPU Load ---"
top -bn1 | grep "load average" | awk '{printf "Load Average: %.2f, %.2f, %.2f\n", $(NF-2), $(NF-1), $NF}'

echo -e "\n--- Memory Usage ---"
free -h | awk '/Mem:/ {printf "Used: %s / Total: %s\n", $3, $2}'

echo -e "\n--- Disk Usage ---"
/bin/df -h --total | grep total | awk '{print "Used: " $3 " / Total: " $2 " (" $5 " used)"}'

echo -e "\n--- IP Address ---"
ip addr show | awk '/inet / && $2 !~ /^127/ {print $2}' | cut -d/ -f1

echo -e "\n=== End of Report ==="
