#!/bin/bash

# openSUSE Tumbleweed Specific Optimization Script

set -e

echo "Starting openSUSE Tumbleweed specific optimization..."

# 1. Show Tumbleweed version
echo "1. openSUSE Tumbleweed version:"
 cat /etc/os-release
 echo ""

# 2. Update system to latest packages
echo "2. Updating system to latest packages..."
sudo zypper dup -y  # Use dup for rolling release updates
echo ""

# 3. Enable essential repositories
echo "3. Enabling essential repositories..."

# Ensure Packman is enabled
if ! zypper lr | grep -q "Packman"; then
    echo "Adding Packman repository..."
    sudo zypper addrepo --refresh https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ Packman
fi

# Ensure Update repository is enabled
echo "Ensuring Update repository is enabled..."
sudo zypper modifyrepo --enable repo-update

# Ensure Non-OSS repository is enabled
echo "Ensuring Non-OSS repository is enabled..."
sudo zypper modifyrepo --enable repo-non-oss

# Ensure Codecs repository is enabled
if ! zypper lr | grep -q "Codecs"; then
    echo "Adding Codecs repository..."
    sudo zypper addrepo --refresh https://download.opensuse.org/repositories/multimedia:/codecs/openSUSE_Tumbleweed/ Codecs
fi

# Ensure NVIDIA repository is enabled (if needed)
if lspci | grep -q "NVIDIA" && ! zypper lr | grep -q "NVIDIA"; then
    echo "Adding NVIDIA repository..."
    sudo zypper addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed/ NVIDIA
fi

echo "Refreshing repositories..."
sudo zypper --gpg-auto-import-keys refresh
echo "Repositories enabled."
echo ""

# 4. Install Tumbleweed specific packages
echo "4. Installing Tumbleweed specific packages..."
sudo zypper install -y --type pattern devel_basis
sudo zypper install -y --type pattern enhanced_base
sudo zypper install -y --type pattern fonts
sudo zypper install -y --type pattern multimedia
sudo zypper install -y --type pattern server_apps
echo "Tumbleweed specific packages installed."
echo ""

# 5. Optimize for desktop usage
echo "5. Optimizing for desktop usage..."

# Check if this is a desktop
desktop=false
if command -v gnome-session &> /dev/null || command -v startkde &> /dev/null || command -v startxfce4 &> /dev/null; then
    desktop=true
fi

if $desktop; then
    echo "Desktop environment detected. Installing desktop optimizations..."
    
    # Install desktop specific packages
    sudo zypper install -y --type pattern gnome
sudo zypper install -y --type pattern kde
sudo zypper install -y --type pattern xfce
    
    # Install multimedia codecs (critical for Tumbleweed)
    echo "Installing multimedia codecs..."
    sudo zypper install -y --from Packman --allow-vendor-change ffmpeg libavcodec-full gstreamer-plugins-bad gstreamer-plugins-ugly gstreamer-plugins-vaapi
    
    # Enable desktop services
    sudo systemctl enable --now NetworkManager
sudo systemctl enable --now avahi-daemon
sudo systemctl enable --now blueman-mechanism
    
    echo "Desktop optimizations installed."
else
    echo "Server environment detected. Skipping desktop optimizations."
fi
echo ""

# 6. Enable and configure power management
echo "6. Configuring power management..."

# For laptops
if grep -q "^DMI:.*[Ll]aptop" /sys/class/dmi/id/chassis_type 2>/dev/null || grep -q "^Chassis\s*Type:\s*10" /proc/cpuinfo 2>/dev/null; then
    echo "Laptop detected. Installing power management packages..."
    sudo zypper install -y tlp powertop thermald acpid
    
    # Enable TLP
    sudo systemctl enable --now tlp tlp-rdw
    
    # Run powertop auto-tune
    sudo powertop --auto-tune
    
    # Enable thermald
    sudo systemctl enable --now thermald acpid
    
    echo "Laptop power management configured."
else
    echo "Desktop detected. Skipping laptop power management."
fi
echo ""

# 7. Enable Btrfs snapshots with snapper
echo "7. Enabling Btrfs snapshots with snapper..."

# Check if using Btrfs
if mount | grep -q "btrfs" && command -v snapper &> /dev/null; then
    echo "Btrfs detected. Configuring snapper..."
    
    # Check if snapper is already configured for root
    if ! snapper list-configs | grep -q "root"; then
        echo "Creating snapper configuration for root..."
        sudo snapper create-config /
    fi
    
    # Enable snapper services
    sudo systemctl enable --now snapper-timeline.timer snapper-cleanup.timer
    
    # Configure snapper cleanup policies (more aggressive for rolling release)
    echo "Configuring snapper cleanup policies..."
    sudo snapper set-config "TIMELINE_LIMIT_HOURLY=6"
    sudo snapper set-config "TIMELINE_LIMIT_DAILY=7"
    sudo snapper set-config "TIMELINE_LIMIT_WEEKLY=4"
    sudo snapper set-config "TIMELINE_LIMIT_MONTHLY=2"
    sudo snapper set-config "TIMELINE_LIMIT_YEARLY=0"
    
    echo "snapper configured."
else
    echo "Btrfs or snapper not detected. Skipping snapper configuration."
fi
echo ""

# 8. Enable firewalld
echo "8. Enabling firewalld..."
sudo systemctl enable --now firewalld

# Open common ports
echo "Opening common ports..."
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload

echo "firewalld enabled and configured."
echo ""

# 9. Security hardening
echo "9. Security hardening..."

# Install additional security packages
sudo zypper install -y openscap-scanner scap-security-guide fail2ban apparmor apparmor-utils

# Enable fail2ban
sudo systemctl enable --now fail2ban

# Enable AppArmor
sudo systemctl enable --now apparmor

# Configure AppArmor to enforce mode
sudo aa-enforce /etc/apparmor.d/*

echo "Security hardening completed."
echo ""

# 10. Configure ZRAM for better performance
echo "10. Configuring ZRAM..."

if ! command -v zramctl &> /dev/null; then
    echo "Installing zram-generator..."
    sudo zypper install -y zram-generator
fi

# Create zram configuration
echo "Creating zram configuration..."
sudo tee /etc/systemd/zram-generator.conf <<EOF
[zram0]
zram-size = min(ram / 2, 8192)
compression-algorithm = zstd
swap-priority = 100
fs-type = swap
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now /dev/zram0.swap

echo "ZRAM configured."
echo ""

# 11. Install and configure Flatpak
echo "11. Installing Flatpak..."

sudo zypper install -y flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "Flatpak installed and configured."
echo ""

# 12. Cleanup unnecessary packages
echo "12. Cleaning up unnecessary packages..."
sudo zypper remove --clean-deps -y $(zypper packages --unneeded -i | awk 'NR>2 {print $3}') 2>/dev/null || true
sudo zypper clean -a

echo "Cleanup completed."
echo ""

# 13. Configure automatic updates
echo "13. Configuring automatic updates..."

# Install and enable packagekit
sudo zypper install -y packagekit packagekit-tools
sudo systemctl enable --now packagekit

echo "Automatic updates configured. Use YaST or pkcon to manage."
echo ""

# 14. Show final optimization summary
echo "14. openSUSE Tumbleweed optimization completed!"
echo "=================================================="
echo "Key optimizations applied:"
echo "- System updated to latest packages using zypper dup"
echo "- Essential repositories enabled (Packman, Codecs, NVIDIA if needed)"
echo "- Tumbleweed specific packages installed"
echo "- Desktop optimizations applied (if desktop detected)"
echo "- Multimedia codecs installed from Packman"
echo "- Power management configured (for laptops)"
echo "- Btrfs snapshots enabled with snapper (if using Btrfs)"
echo "- firewalld enabled and configured"
echo "- Security hardening with AppArmor and fail2ban"
echo "- ZRAM configured for better performance"
echo "- Flatpak installed and configured"
echo "- Automatic updates configured"
echo "- System cleaned up"
echo ""
echo "Recommended next steps:"
echo "- Reboot your system to apply all changes"
echo "- Run 'sudo snapper list' to see Btrfs snapshots"
echo "- Use 'zypper dup' regularly for rolling release updates"
echo "- Check 'YaST Control Center' for additional system configuration"
echo "- Configure Timeshift or similar for additional backups"
echo "- Monitor system stability after updates"
echo "- Consider using Btrfs balance regularly for filesystem maintenance"