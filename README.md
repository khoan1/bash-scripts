# Bash Scripts

This repository contains Bash scripts for common Linux system administration tasks.

- **cron-status-checker.sh** – Checks for errored or failed cron jobs in syslog.
- **disk-usage-alert.sh** – Sends an alert if disk usage exceeds a defined threshold.
- **fail2ban-monitor.sh** – Logs all bans recorded by Fail2Ban.
- **firewall-setup.sh** – Configures UFW or iptables with basic default rules.
- **log-rotation-archive.sh** – Rotates and compresses log files if they exceed a max size.
- **manage-users.sh** – Creates or deletes users based on a provided `.txt` file.
- **password-expiry-reminder.sh** – Notifies users if their password is nearing expiration.
- **scheduled-backup.sh** – Backs up `/etc` and `/home`, then uploads to a remote server.
- **ssh-login-tracker.sh** – Uses PAM to log SSH login activity from any shell.
- **system-audit-report.sh** – Reports active users, open ports, sudoers, and installed packages.
- **system-info.sh** – Displays system info including uptime, CPU, RAM, disk, and IP.
- **system-update.sh** – Updates all packages and removes unnecessary ones.
