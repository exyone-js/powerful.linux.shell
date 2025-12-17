#!/bin/bash

# Linux Optimization Tools (optools.sh)
# Version: 1.1.0
# Last Updated: 2025-12-17
# Description: Main script to manage and run Linux optimization scripts

# -----------------------------------------------------------------------------
# Changelog
# -----------------------------------------------------------------------------
# 1.1.0 (2025-12-17):
#   - Added interactive menu system
#   - Enhanced user interface with colors and progress
#   - Added script execution confirmation
#   - Improved script discovery and organization
#   - Added comprehensive error handling
#   - Added script documentation support
#
# 1.0.0 (2025-12-01):
#   - Initial version
#
# -----------------------------------------------------------------------------

# Source the common function library if it exists
COMMON_LIB="common/common-lib.sh"

if [ -f "$COMMON_LIB" ]; then
    source "$COMMON_LIB"
fi

# Script-specific variables
SCRIPT_VERSION="1.1.0"
SCRIPT_NAME="$(basename "$0")"

# -----------------------------------------------------------------------------
# UI Configuration
# -----------------------------------------------------------------------------

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Menu options
MENU_ITEMS=()
SCRIPT_PATHS=()

# -----------------------------------------------------------------------------
# Function Definitions
# -----------------------------------------------------------------------------

# Show script header
show_header() {
    echo -e "${CYAN}"
    echo "=================================================="
    echo "                Linux Optimization Tools"
    echo "                    Version: $SCRIPT_VERSION"
    echo "=================================================="
    echo -e "${NC}"
    echo "A collection of scripts to optimize Linux environments for both desktop and server use."
    echo ""
}

# Show script footer
show_footer() {
    echo -e "\n${CYAN}"
    echo "=================================================="
    echo "                  Operation Complete"
    echo "=================================================="
    echo -e "${NC}"
}

# Show error message
error_msg() {
    echo -e "${RED}Error: $1${NC}"
}

# Show warning message
warning_msg() {
    echo -e "${YELLOW}Warning: $1${NC}"
}

# Show success message
success_msg() {
    echo -e "${GREEN}Success: $1${NC}"
}

# Show info message
info_msg() {
    echo -e "${BLUE}Info: $1${NC}"
}

# Discover all optimization scripts
discover_scripts() {
    info_msg "Discovering optimization scripts..."
    
    # Reset arrays
    MENU_ITEMS=()
    SCRIPT_PATHS=()
    
    # Find all .sh files in subdirectories, excluding this script
    local script_count=0
    
    # Add common scripts first
    if [ -d "common" ]; then
        local common_scripts=$(find "common" -name "*.sh" | sort)
        for script in $common_scripts; do
            if [ "$script" != "common/common-lib.sh" ]; then
                MENU_ITEMS+=("$((++script_count)). Common - $(basename "$script" .sh)")
                SCRIPT_PATHS+=("$script")
            fi
        done
    fi
    
    # Add distribution-specific scripts
    for distro_dir in */; do
        if [ -d "$distro_dir" ] && [ "$distro_dir" != "common/" ]; then
            local distro=$(basename "$distro_dir")
            
            # Add common scripts for this distro
            if [ -d "$distro_dir/common" ]; then
                local distro_common_scripts=$(find "$distro_dir/common" -name "*.sh" | sort)
                for script in $distro_common_scripts; do
                    MENU_ITEMS+=("$((++script_count)). $distro - Common - $(basename "$script" .sh)")
                    SCRIPT_PATHS+=("$script")
                done
            fi
            
            # Add version-specific scripts
            for version_dir in "$distro_dir"*/; do
                if [ -d "$version_dir" ] && [ "$version_dir" != "$distro_dir/common/" ]; then
                    local version=$(basename "$version_dir")
                    local version_scripts=$(find "$version_dir" -name "*.sh" | sort)
                    for script in $version_scripts; do
                        MENU_ITEMS+=("$((++script_count)). $distro - $version - $(basename "$script" .sh)")
                        SCRIPT_PATHS+=("$script")
                    done
                fi
            done
        fi
    done
    
    # Add exit option
    MENU_ITEMS+=("$((++script_count)). Exit")
    SCRIPT_PATHS+=("exit")
    
    success_msg "Found ${#SCRIPT_PATHS[@]} scripts"
    echo ""
}

# Show main menu
show_menu() {
    echo -e "${PURPLE}"
    echo "=================================================="
    echo "                      Main Menu"
    echo "=================================================="
    echo -e "${NC}"
    
    for item in "${MENU_ITEMS[@]}"; do
        echo "$item"
    done
    echo ""
}

# Show script details
show_script_details() {
    local script_path="$1"
    
    echo -e "${CYAN}"
    echo "=================================================="
    echo "                  Script Details"
    echo "=================================================="
    echo -e "${NC}"
    
    echo "Script Path: $script_path"
    echo ""
    
    # Extract script information from comments
    if [ -f "$script_path" ]; then
        local version=$(grep -m1 "Version:" "$script_path" | cut -d: -f2- | xargs || echo "Unknown")
        local description=$(grep -A3 "Description:" "$script_path" | grep -v "Description:" | xargs || echo "No description available")
        
        echo "Version: $version"
        echo "Description: $description"
        echo ""
        
        # Show first few lines of the script (excluding comments)
        echo "Script Preview:"
        echo "----------------"
        head -20 "$script_path" | grep -v '^#' | grep -v '^$' | head -10 || echo "No preview available"
        echo "----------------"
    fi
    echo ""
}

# Execute script with confirmation
execute_script() {
    local script_path="$1"
    
    # Show script details
    show_script_details "$script_path"
    
    # Ask for confirmation
    read -p "Do you want to run this script? (y/N): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        info_msg "Running script: $script_path"
        echo "--------------------------------------------------"
        
        # Make sure the script is executable
        chmod +x "$script_path" || warning_msg "Failed to make script executable, attempting to run anyway"
        
        # Execute the script
        "./$script_path"
        
        local exit_code=$?
        
        echo "--------------------------------------------------"
        if [ $exit_code -eq 0 ]; then
            success_msg "Script completed successfully!"
        else
            error_msg "Script failed with exit code $exit_code"
        fi
        
        echo ""
        read -p "Press Enter to continue..." -r
    else
        info_msg "Script execution cancelled"
    fi
}

# Show help information
show_help() {
    echo -e "${CYAN}"
    echo "=================================================="
    echo "                     Help Information"
    echo "=================================================="
    echo -e "${NC}"
    
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help      Show this help message"
    echo "  -v, --version   Show script version"
    echo "  -l, --list      List all available scripts"
    echo ""
    echo "Interactive Menu:"
    echo "  Simply run the script without arguments to enter the interactive menu."
    echo "  Select a script by entering its number, and follow the prompts."
    echo ""
    echo "Script Categories:"
    echo "  - Common: Scripts that work on all Linux distributions"
    echo "  - Distribution-specific: Scripts tailored for specific Linux distributions"
    echo "  - Version-specific: Scripts tailored for specific versions of distributions"
    echo ""
    echo "Safety Features:"
    echo "  - All scripts include backup mechanisms for critical files"
    echo "  - Most scripts include user confirmation prompts"
    echo "  - Detailed logging is available for troubleshooting"
    echo ""
    echo "Recommended Usage:"
    echo "  1. Run the script without arguments to see all available options"
    echo "  2. Select a script to see its details"
    echo "  3. Confirm before running any script"
    echo "  4. Review the output after execution"
    echo ""
}

# Show version information
show_version() {
    echo "$SCRIPT_NAME version $SCRIPT_VERSION"
}

# Show available scripts list
show_script_list() {
    discover_scripts
    
    echo -e "${CYAN}"
    echo "=================================================="
    echo "                   Available Scripts"
    echo "=================================================="
    echo -e "${NC}"
    
    for ((i=0; i<${#MENU_ITEMS[@]}; i++)); do
        echo "${MENU_ITEMS[$i]}"
    done
    echo ""
}

# Main menu loop
main_menu() {
    while true; do
        # Discover scripts each time menu is shown (to handle dynamic changes)
        discover_scripts
        
        # Show main menu
        show_menu
        
        # Get user input
        read -p "Enter your choice (1-${#MENU_ITEMS[@]}): " choice
        echo ""
        
        # Validate input
        if ! [[ $choice =~ ^[0-9]+$ ]]; then
            error_msg "Invalid input. Please enter a number."
            continue
        fi
        
        if [ $choice -lt 1 ] || [ $choice -gt ${#MENU_ITEMS[@]} ]; then
            error_msg "Invalid choice. Please enter a number between 1 and ${#MENU_ITEMS[@]}."
            continue
        fi
        
        # Get selected script path
        local selected_index=$((choice - 1))
        local selected_script=${SCRIPT_PATHS[$selected_index]}
        
        # Handle exit option
        if [ "$selected_script" = "exit" ]; then
            success_msg "Exiting Linux Optimization Tools. Goodbye!"
            break
        fi
        
        # Execute selected script
        execute_script "$selected_script"
    done
}

# -----------------------------------------------------------------------------
# Main Script Execution
# -----------------------------------------------------------------------------

# Check for command line arguments
case "$1" in
    -h|--help)
        show_help
        exit 0
        ;;
    -v|--version)
        show_version
        exit 0
        ;;
    -l|--list)
        show_script_list
        exit 0
        ;;
    *)
        # Show header
        show_header
        
        # Start main menu loop
        main_menu
        
        # Show footer
        show_footer
        ;;
esac
