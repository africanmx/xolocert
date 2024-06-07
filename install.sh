#!/bin/bash

# Set installation directory
INSTALL_DIR="/usr/local/xolocert"

# Install function
install() {
    # Check if user is root
    if [ "$(id -u)" -eq 0 ]; then
        echo "Error: Please run the installation script without sudo."
        exit 1
    fi

    # Copy executable
    sudo cp "./xolocert.sh" "/usr/local/bin/xolocert"

    # Set correct ownership and permissions
    sudo chown "$(whoami)" "/usr/local/bin/xolocert"
    sudo chmod +x "/usr/local/bin/xolocert"

    echo "Xolocert installation complete."
}

# Uninstall function
uninstall() {
    # Remove executable
    sudo rm -f "/usr/local/bin/xolocert"

    echo "Xolocert uninstallation complete."
}

# Display installation help information
show_help() {
    echo "Usage: ./install.sh [--uninstall]"
    echo "Options:"
    echo "  --uninstall   Uninstall xolocert"
}

# Check command-line arguments
case "$1" in
    --uninstall)
        uninstall
        ;;
    *)
        install
        ;;
esac
