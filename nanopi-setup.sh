#!/bin/bash

set -e

echo "=========================================="
echo "Jellyfin-AP Setup Script"
echo "=========================================="
echo ""

if [ "$EUID" -ne 0 ]; then 
    echo "Run with sudo: sudo bash setup.sh"
    exit 1
fi

echo "Backing up sources.list..."

cp /etc/apt/sources.list /etc/apt/sources.list.backup 2>/dev/null || true

echo "Setting standard Debian repositories..."

cat > /etc/apt/sources.list << 'EOF'
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
EOF

echo "Removing FriendlyARM repos..."

rm -f /etc/apt/sources.list.d/friendlyelec.list
rm -f /etc/apt/sources.list.d/armbian.list
rm -f /etc/apt/sources.list.d/local-packages.list

echo "Updating packages..."

apt update

echo "Configuring locales..."

export DEBIAN_FRONTEND=noninteractive

sed -i 's/^# en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen

locale-gen

update-locale LANG=en_US.UTF-8

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo "Upgrading system..."

apt upgrade -y

echo "Installing Ansible and dependencies..."

apt install -y ansible python3 python3-apt git sudo

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Edit config:    nano group_vars/all.yml"
echo "2. Run playbook:   ansible-playbook playbook.yml"
echo ""
