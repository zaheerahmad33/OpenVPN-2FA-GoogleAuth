#!/bin/bash

# Function to create the zip file for the specified username
create_zip_file() {
    local username="$1"
    local openvpn_base="/opt/openvpn/clients/$username"
    local google_auth_base="/opt/openvpn/google-auth/$username.png"
    local zip_file="/opt/openvpn/clients/${username}.zip"

    # Create a zip file with the contents of the client directory and the Google Authenticator image
    zip -r "$zip_file" -j "$google_auth_base" "$openvpn_base"/*

    # Check if the zip file was created successfully
    if [ $? -eq 0 ]; then
        echo "Successfully created zip file: $zip_file"
    else
        echo "Failed to create zip file: $zip_file"
        exit 1
    fi
}

# Function to install the zip utility if it does not exist
install_zip_utility() {
    # Check if the zip command exists
    if ! command -v zip &>/dev/null; then
        echo "zip utility not found. Installing zip..."

        # Detect the package manager and install zip accordingly
        if command -v apt-get &>/dev/null; then
            # Debian-based systems (e.g., Ubuntu)
            sudo apt-get update
            sudo apt-get install -y zip
        elif command -v yum &>/dev/null; then
            # Red Hat-based systems (e.g., CentOS)
            sudo yum install -y zip
        elif command -v dnf &>/dev/null; then
            # Newer Fedora systems
            sudo dnf install -y zip
        else:
            echo "Unable to determine package manager or unsupported system. Please install zip manually."
            exit 1
        fi

        # Verify that zip was installed successfully
        if ! command -v zip &>/dev/null; then
            echo "Failed to install zip utility. Please install zip manually."
            exit 1
        else
            echo "zip utility installed successfully."
        fi
    fi
}

# Main script starts here

# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root."
    exit 1
fi

# Install the zip utility if it does not exist
install_zip_utility

while true; do
    # Prompt the user to enter a username
    echo -n "Please enter the username: "
    read username

    # Check if the username is empty
    if [ -z "$username" ]; then
        echo "Username cannot be empty. Please try again."
        continue
    fi

    # Check if the specified username exists as a system user
    if ! id "$username" &>/dev/null; then
        echo "User '$username' does not exist. Please try again."
        continue
    fi

    # Define the base directories
    openvpn_base="/opt/openvpn/clients/$username"
    google_auth_base="/opt/openvpn/google-auth/$username.png"

    # Check if the specified client directory exists
    if [ ! -d "$openvpn_base" ]; then
        echo "Client directory for '$username' does not exist: $openvpn_base"
        continue
    fi

    # Check if the Google Authenticator image file exists
    if [ ! -f "$google_auth_base" ]; then
        echo "Google Authenticator image for '$username' does not exist: $google_auth_base"
        continue
    fi

    # If all checks pass, call the function to create the zip file
    create_zip_file "$username"
    break
done
