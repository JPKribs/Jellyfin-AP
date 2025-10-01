# Jellyfin-AP

Debian SBC as a WireGuard VPN Access Point with automatic updates.

## Quick Start

### 1. SSH onto your NanoPi
```bash
ssh root@<nanopi-ip>
```

### 2. Clone this repo
```bash
cd ~
git clone https://github.com/JPKribs/Jellyfin-AP.git
cd Jellyfin-AP
```

### 3. Run the setup script
```bash
sudo bash setup.sh
```

This will:
- Force standard Debian repositories
- Update/upgrade all packages
- Install Ansible and dependencies

### 4. Edit your configuration
```bash
nano group_vars/all.yml
```

Update these values:
- `system_hostname` - System name (persists across reboots)
- `ap_ssid` - Your WiFi name
- `ap_password` - Your WiFi password
- `service_ip` - IP to route through VPN (like `10.192.1.254`)
- `wireguard_config_file` - Path to your WireGuard config (like `/root/wg0.conf`)

Save and exit (Ctrl+X, Y, Enter)

### 5. Run the playbook
```bash
ansible-playbook playbook.yml
```

Wait 10-15 minutes for completion.

### 6. Done
Connect to your new WiFi AP. Traffic to your service IP goes through VPN, everything else goes direct.

## Features

- **Automatic security updates** - Daily checks, auto-installs security patches
- **Hostname persistence** - System name never resets
- **Split-tunnel VPN** - Only specific traffic through WireGuard
- **Auto-detected interfaces** - No manual network config needed
- **mDNS discovery** - Access as `hostname.local`

## Troubleshooting

Check services:
```bash
systemctl status wg-quick@wg0
systemctl status hostapd
systemctl status dnsmasq
systemctl status unattended-upgrades
```

View logs:
```bash
journalctl -u hostapd -f
journalctl -u wg-quick@wg0 -f
```

Verify hostname:
```bash
hostname
hostnamectl
```

Check auto-updates:
```bash
cat /var/log/unattended-upgrades/unattended-upgrades.log
```