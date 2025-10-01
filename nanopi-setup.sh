#!/bin/bash

set -e

echo "=========================================="
echo "NanoPi Zero2 Pre-Ansible Setup Script"
echo "=========================================="
echo ""

if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (sudo bash nanopi-setup.sh)"
    exit 1
fi

echo "Step 1: Backing up original sources.list..."
cp /etc/apt/sources.list /etc/apt/sources.list.original

echo "Step 2: Replacing with standard Debian repositories..."
cat > /etc/apt/sources.list << 'EOF'
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
EOF

echo "Step 3: Removing FriendlyARM repositories..."
rm -f /etc/apt/sources.list.d/friendlyelec.list
rm -f /etc/apt/sources.list.d/armbian.list
rm -f /etc/apt/sources.list.d/local-packages.list

echo "Step 4: Updating package lists..."
apt update

echo "Step 5: Upgrading existing packages..."
apt upgrade -y

echo "Step 6: Installing Python for Ansible..."
apt install -y python3 python3-apt sudo

echo "Step 7: Creating ansible user..."
if id "ansible" &>/dev/null; then
    echo "User 'ansible' already exists"
else
    adduser --disabled-password --gecos "" ansible
    echo "Please set password for ansible user:"
    passwd ansible
fi

echo "Step 8: Adding ansible user to sudo group..."
usermod -aG sudo ansible

echo "Step 9: Setting up SSH for ansible user..."
mkdir -p /home/ansible/.ssh
chmod 700 /home/ansible/.ssh
touch /home/ansible/.ssh/authorized_keys
chmod 600 /home/ansible/.ssh/authorized_keys
chown -R ansible:ansible /home/ansible/.ssh

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Copy your SSH public key to /home/ansible/.ssh/authorized_keys"
echo "   On your local machine run:"
echo "   ssh-copy-id ansible@<nanopi-ip>"
echo ""
echo "2. Note the NanoPi IP address:"
ip -4 addr show | grep inet | grep -v 127.0.0.1
echo ""
echo "3. Verify kernel version (should be 6.1.x):"
uname -r
echo ""
echo "4. Test SSH from your control machine:"
echo "   ssh ansible@<nanopi-ip>"
echo ""
echo "5. Run the Ansible playbook from your control machine"
echo ""