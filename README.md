# README.md

```markdown
# Jellyfin-AP

NanoPi Zero2 as a WireGuard VPN Access Point

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
sudo bash nanopi-setup.sh
```

This will:
- Fix Debian repositories
- Update/upgrade packages
- Install Ansible and dependencies
- Set up local Ansible user

### 4. Edit your configuration
```bash
nano group_vars/all.yml
```

Update these values:
- `ap_ssid` - Your WiFi name
- `ap_password` - Your WiFi password
- `service_ip` - IP to route through VPN (like `10.192.1.254`)
- `wireguard_config_file` - Path to your WireGuard config (like `/root/wg0.conf`)

Save and exit (Ctrl+X, Y, Enter)

### 5. Run the playbook
```bash
ansible-playbook playbook.yml
```

### 6. Done
Connect to your new WiFi AP. Traffic to your service IP goes through VPN, everything else goes direct.

## Troubleshooting

Check services:
```bash
systemctl status wg-quick@wg0
systemctl status hostapd
systemctl status dnsmasq
```

View logs:
```bash
journalctl -u hostapd -f
journalctl -u wg-quick@wg0 -f
```