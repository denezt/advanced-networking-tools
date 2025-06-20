#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" >&2
    exit 1
fi

printf "Setup iptables...\n"
update-alternatives --set iptables /usr/sbin/iptables-legacy
iptables -I INPUT -s 192.168.3.0/24 -j ACCEPT
iptables -A FORWARD -o eth0 -i wlan0 -s 192.168.2.0/24 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -F POSTROUTING
iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
printf "Done\n"
