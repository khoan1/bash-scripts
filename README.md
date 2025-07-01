# Bash Scripts

This repository contains a collection of Bash scripts for common Linux system administration tasks.

- **cron-status-checker.sh** - Checks for any errored or failed cron jobs in syslog
- **disk-usage-alert.sh** - Checks current disk usage and emails alert if usage passed threshold
- **fail2ban-monitor.sh** - Monitors the fail2ban.log and logs all bans recorded by fail2ban
- **firewall-setup.sh** - Configures UFW or iptables with default rules for a typical server
- **log-rotation-archive.sh** - Checks if log file exceeds max size and archives log if max size exceeded
- **manage-users.sh** - Creates or deletes users from a specified .txt file
- **password-expiry-reminder.sh** - Checks if user password is under set threshold expiry date
- **scheduled-backup.sh** - Backs up /etc and /home folders, then uploads backup to remote server
- **ssh-login-tracker.sh** - Uses Pluggable Authentication Modules (PAM) to track ssh login from any shell
- **system-audit-report.sh** - Generates a report on current users, open ports, sudoers, and installed packages
- **system-info.sh** - Displays basic system info: uptime, CPU, RAM, disk, and IP address
- **system-update.sh** - Updates system packages and performs old package cleanup
