#!/bin/bash
# firewall-setup.sh

# Simple firewall setup script
# Configures UFW or iptables with default rules for a typical server

set -e  # Exit on any error

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root or with sudo"
  exit 1
fi

# Choose firewall tool to use: ufw or iptables
FIREWALL_TOOL="ufw"   # Change to "iptables" if preferred

echo "Configuring firewall with $FIREWALL_TOOL..."

if [ "$FIREWALL_TOOL" == "ufw" ]; then
    # Install ufw if not installed
    if ! command -v ufw &> /dev/null; then
        echo "ufw not found, installing..."
        apt-get update && apt-get install -y ufw
    fi

    # Reset UFW to default (optional)
    ufw --force reset

    # Set default policies
    ufw default deny incoming
    ufw default allow outgoing

    # Allow SSH (adjust port if you use a different one)
    ufw allow ssh

    # Allow HTTP and HTTPS (for web servers)
    ufw allow http
    ufw allow https

    # Enable UFW
    ufw --force enable

    echo "UFW configured and enabled."

elif [ "$FIREWALL_TOOL" == "iptables" ]; then
    # Flush all existing rules
    iptables -F     # flush all rules
    iptables -X     # delete any existing chains

    # Set default policies
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT

    # Allow established and related packets
    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

    # Allow loopback traffic for internal processes
    iptables -A INPUT -i lo -j ACCEPT

    # Allow SSH (port 22)
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT

    # Allow HTTP and HTTPS
    iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    iptables -A INPUT -p tcp --dport 443 -j ACCEPT

    # Save iptables rules (Ubuntu)
    iptables-save > /etc/iptables/rules.v4

    echo "iptables rules configured and saved."

else
    echo "Unsupported firewall tool: $FIREWALL_TOOL"
    exit 1
fi

echo "Firewall setup completed."
