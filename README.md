# linux.optools
A collection of shell scripts to optimize Linux environments for both desktop and server use.

## Overview
linux.optools is a comprehensive set of optimization scripts designed to improve the performance, security, and usability of various Linux distributions. The scripts are organized by distribution and functionality, making it easy to find and use the appropriate optimizations for your system.

## Features

### Common Optimizations
- **Filesystem Optimization**: Improve filesystem performance and reliability
- **Memory Management**: Optimize memory usage and swap behavior
- **Network Optimization**: Enhance network performance and security
- **Process Priority**: Adjust process priorities for better resource allocation
- **Security Hardening**: Strengthen system security with best practices
- **System Services**: Manage and optimize system services

### Distribution-Specific Optimizations

#### Debian-like (Debian, Ubuntu, Linux Mint)
- Package management optimization
- Mirror selection and update
- Snap package management and optimization

#### Red Hat-like (Fedora, CentOS, Rocky Linux)
- DNF package manager optimization
- SELinux configuration and security hardening
- Firewalld configuration
- Service optimization with tuned profiles

#### Arch-like (Arch Linux, Manjaro)
- Pacman package manager optimization
- AUR support and optimization
- Earlyoom for better OOM management
- Btrfs filesystem optimization

#### openSUSE (Leap, Tumbleweed)
- Zypper package manager optimization
- Btrfs snapshots with snapper
- Repository management (Packman, Codecs)
- Power management for laptops

## Getting Started

### Prerequisites
- A Linux distribution from the supported list
- Bash shell (most Linux systems come with this by default)
- Root or sudo access for most scripts

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/linux-optools.git
   cd linux-optools
   ```

2. Make the main script executable:
   ```bash
   chmod +x optools.sh
   ```

3. Run the main script:
   ```bash
   ./optools.sh
   ```

### Usage

#### Interactive Mode
The main script provides an interactive menu interface that makes it easy to browse and run optimization scripts:

```bash
./optools.sh
```

The menu will display all available scripts, organized by category. Simply enter the number of the script you want to run and follow the prompts.

#### Command Line Options
```bash
./optools.sh [options]

Options:
  -h, --help      Show this help message
  -v, --version   Show script version
  -l, --list      List all available scripts
```

#### Direct Script Execution
You can also run scripts directly if you know the path:

```bash
chmod +x path/to/script.sh
./path/to/script.sh
```

## Script Categories

### Common Scripts
These scripts work on all Linux distributions:

- `filesystem-optimization.sh`: Optimizes filesystem mount options and performance
- `journald-optimization.sh`: Configures systemd journald for better performance
- `memory-management.sh`: Optimizes memory usage and cache behavior
- `network-optimization.sh`: Enhances network performance and security
- `process-priority.sh`: Adjusts process priorities for better resource allocation
- `security-hardening.sh`: Strengthens system security with best practices
- `swappiness.sh`: Configures swap usage behavior

### Distribution-Specific Scripts

#### Debian-like
- **Common**: `autoremove.sh`, `clean-packages.sh`, `update-mirrors.sh`
- **Ubuntu**: `delete-snap.sh`, `snap-channel-manager.sh`, `snap-manager.sh`, `snap-optimization.sh`, `snap-to-deb.sh`

#### Red Hat-like
- **Common**: `dnf-optimization.sh`, `firewalld-optimization.sh`, `selinux-optimization.sh`, `service-optimization.sh`, `swap-optimization.sh`
- **Fedora**: `fedora-optimization.sh`
- **CentOS**: `centos-optimization.sh`
- **Rocky**: `rocky-optimization.sh`

#### Arch-like
- **Common**: `btrfs-optimization.sh`, `pacman-optimization.sh`, `service-optimization.sh`
- **Arch**: `arch-desktop-optimization.sh`, `arch-server-optimization.sh`
- **Manjaro**: `manjaro-optimization.sh`

#### openSUSE
- **Common**: `system-optimization.sh`, `zypper-optimization.sh`
- **Leap**: `leap-optimization.sh`
- **Tumbleweed**: `tumbleweed-optimization.sh`

## Safety Features

- **Automatic Backups**: All scripts create backups of critical files before making changes
- **User Confirmation**: Most scripts ask for confirmation before executing major changes
- **Detailed Logging**: Comprehensive logging of all actions and changes
- **Error Handling**: Robust error detection and recovery mechanisms
- **Rollback Support**: Ability to revert changes if something goes wrong

## Version Control
All scripts include version information and changelogs, making it easy to track changes and updates:

```bash
# Script Version: 1.1.0
# Last Updated: 2025-12-17
# Description: Brief description of what the script does

# Changelog
# 1.1.0 (2025-12-17):
#   - Change 1
#   - Change 2
#
# 1.0.0 (2025-12-01):
#   - Initial version
```

## Contributing
Contributions are welcome! If you have any optimization scripts or improvements to existing scripts, please follow these guidelines:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

Please ensure your scripts follow the project's coding style and include appropriate documentation and safety features.

## Troubleshooting

### Common Issues

#### Scripts won't run
- Ensure the scripts have executable permissions: `chmod +x script.sh`
- Check that you have the necessary dependencies installed
- Verify you're running the script with appropriate permissions (sudo if needed)

#### Script execution fails
- Check the error message for clues
- Review the script logs in `/var/log/optools.log`
- Use the backup files to restore if necessary
- Try running the script with debug logging enabled

#### Optimization didn't have the expected effect
- Some optimizations require a reboot to take effect
- The effectiveness may vary depending on your system configuration
- Check that you're using the appropriate script for your distribution

## Support

For questions, issues, or support, please:
1. Check the documentation and FAQs
2. Search the issue tracker
3. Create a new issue if needed

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by various Linux optimization guides and scripts
- Built with best practices from the Linux community
- Tested on multiple distributions and configurations

## Disclaimer

These scripts are provided as-is, without any warranty. While every effort has been made to ensure their safety and effectiveness, it's always a good idea to:

1. Backup your system before running any optimization scripts
2. Understand what each script does before running it
3. Test scripts in a non-production environment first
4. Monitor your system after applying optimizations

By using these scripts, you agree to take full responsibility for any changes made to your system.

## Getting Help

If you need help with any aspect of linux.optools, please refer to the following resources:

- **Documentation**: This README and script comments
- **Command Line Help**: Run `./optools.sh --help` for usage information
- **Script Details**: Each script provides detailed information when run interactively
- **Community**: Join the discussion on GitHub Issues

---

**linux.optools** - Optimize your Linux experience, one script at a time.
