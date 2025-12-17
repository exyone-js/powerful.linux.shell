# Frequently Asked Questions (FAQ)

## General Questions

### What is linux.optools?
linux.optools is a collection of shell scripts designed to optimize Linux environments for both desktop and server use. The scripts are organized by distribution and functionality, making it easy to find and use the appropriate optimizations for your system.

### Which Linux distributions are supported?
linux.optools supports the following Linux distributions:

- **Debian-like**: Debian, Ubuntu, Linux Mint
- **Red Hat-like**: Fedora, CentOS, Rocky Linux
- **Arch-like**: Arch Linux, Manjaro
- **openSUSE**: Leap, Tumbleweed

### Is linux.optools safe to use?
linux.optools is designed with safety in mind, featuring:
- Automatic backups of critical files
- User confirmation prompts for major changes
- Detailed logging of all actions
- Robust error handling
- Rollback support

However, as with any system modification tool, it's recommended to:
1. Backup your system before running any scripts
2. Understand what each script does before running it
3. Test scripts in a non-production environment first
4. Monitor your system after applying optimizations

### Do I need to be a Linux expert to use linux.optools?
No, linux.optools is designed to be user-friendly. The interactive menu makes it easy to browse and run scripts, and each script provides detailed information about its purpose and effects. However, basic Linux knowledge is recommended, especially for understanding the changes being made to your system.

## Installation and Usage

### How do I install linux.optools?
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

### Can I run individual scripts directly?
Yes, you can run scripts directly if you know the path:

```bash
chmod +x path/to/script.sh
./path/to/script.sh
```

### How often should I run the optimization scripts?
The frequency depends on your usage:

- **Initial setup**: Run all relevant scripts when setting up a new system
- **Regular maintenance**: Run package cleanup and update scripts weekly or monthly
- **After major changes**: Run relevant scripts after system upgrades or configuration changes
- **As needed**: Run specific scripts when you encounter performance issues

### Do I need root access to run the scripts?
Most scripts require root or sudo access to make system-level changes. The main menu will prompt you for sudo credentials when needed.

## Script-Specific Questions

### What does the autoremove.sh script do?
The autoremove.sh script for Debian-like systems:
- Removes unnecessary packages and dependencies
- Cleans package cache
- Removes old kernels while keeping the current and previous versions
- Cleans up package configuration files

### How does the btrfs-optimization.sh script work?
The btrfs-optimization.sh script for Arch-like systems:
- Installs and configures btrfs-progs, btrfsmaintenance, snapper, and grub-btrfs
- Enables btrfs maintenance services for scrub, balance, trim, and defrag
- Configures optimal mount options
- Sets up snapper for automatic snapshots
- Integrates with pacman for automatic snapshot creation
- Configures grub-btrfs for bootable snapshots

### What's the difference between distribution-specific scripts?
Each distribution has its own package manager, service management system, and configuration files. The distribution-specific scripts are tailored to work with these differences:

- **Debian-like**: Uses apt package manager, systemd services
- **Red Hat-like**: Uses dnf package manager, SELinux, firewalld
- **Arch-like**: Uses pacman package manager, AUR support
- **openSUSE**: Uses zypper package manager, snapper for Btrfs snapshots

## Troubleshooting

### Why won't a script run?
Check the following:
- Ensure the script has executable permissions: `chmod +x script.sh`
- Verify you have the necessary dependencies installed
- Check that you're running the script with appropriate permissions (sudo if needed)
- Review any error messages for clues

### What if a script execution fails?
1. Check the error message for specific information
2. Review the script logs in `/var/log/optools.log`
3. Use the backup files to restore if necessary
4. Try running the script with debug logging enabled
5. Report the issue on GitHub with details

### How do I restore from a backup?
Most scripts create backups in `/var/backup/optools/`. You can restore files manually using:

```bash
sudo cp /var/backup/optools/file.backup_timestamp /path/to/original/file
```

### Why didn't an optimization have the expected effect?
Possible reasons:
- Some optimizations require a reboot to take effect
- The optimization may not be applicable to your specific hardware or configuration
- You may need to adjust other settings for maximum benefit
- The improvement may be subtle and not immediately noticeable

## Advanced Topics

### Can I customize the scripts?
Yes, you can modify the scripts to suit your needs. However, be careful when modifying system-level scripts, as incorrect changes can cause system issues.

### How can I contribute to linux.optools?
Contributions are welcome!
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

Please follow the project's coding style and include appropriate documentation and safety features.

### How do I add a new script to linux.optools?
1. Create the script following the project's coding style
2. Include appropriate documentation, version control, and changelog
3. Place the script in the appropriate directory based on distribution and functionality
4. Test thoroughly on the target distribution
5. Submit a pull request

### What's the best way to test scripts?
1. Use a virtual machine or container for initial testing
2. Test on a non-production system
3. Create a full system backup before testing
4. Monitor system performance and logs after applying changes
5. Test on multiple hardware configurations if possible

## Security

### How does linux.optools handle security?
linux.optools includes several security features:
- Automatic backups before making changes
- User confirmation prompts for critical operations
- Detailed logging of all actions
- Security hardening scripts that implement best practices
- SELinux and firewalld configuration for Red Hat-like systems
- Secure SSH configuration

### Should I be concerned about privacy?
linux.optools does not collect or send any personal data. All operations are performed locally on your system, and logs are stored locally.

### How often are scripts updated for security vulnerabilities?
linux.optools is regularly updated to address security issues. It's recommended to keep your local copy updated by pulling the latest changes from GitHub.

## Performance

### Will linux.optools speed up my system?
linux.optools can improve system performance in several ways:
- Optimizing memory usage
- Improving filesystem performance
- Enhancing network throughput
- Reducing boot time by managing services
- Improving package manager performance
- Optimizing process priorities

The actual improvement will depend on your system configuration and usage patterns.

### Which scripts will give me the biggest performance boost?
The scripts that provide the biggest performance boost depend on your system and usage:
- For memory-constrained systems: memory-management.sh, swappiness.sh
- For storage-intensive systems: filesystem-optimization.sh
- For network servers: network-optimization.sh
- For desktop systems: service-optimization.sh, process-priority.sh

### Can linux.optools help with battery life on laptops?
Yes, several scripts can help improve battery life:
- Power management optimization scripts for specific distributions
- Service optimization to reduce background processes
- CPU frequency scaling optimizations
- Display brightness and power settings

## Miscellaneous

### What's the license for linux.optools?
linux.optools is licensed under the MIT License, which allows free use, modification, and distribution.

### Can I use linux.optools in a commercial environment?
Yes, the MIT License allows commercial use of linux.optools.

### Where can I get more help?
For additional help:
- Review the detailed documentation in the README and script comments
- Run `./optools.sh --help` for usage information
- Check the FAQ for common questions
- Report issues on GitHub
- Join the community discussion

### How can I stay updated with linux.optools?
- Star the GitHub repository to receive notifications
- Watch the repository for changes
- Follow the project on social media (if available)
- Check for updates regularly using `git pull`

---

If you have a question that isn't answered here, please feel free to create a new issue on GitHub.
