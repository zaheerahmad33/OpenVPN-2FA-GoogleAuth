# OpenVPN with 2FA using Google Authenticator [Ubuntu 24.04]

This repository contains scripts and a template file to set up and manage **OpenVPN** with **two-factor authentication (2FA)** using **Google Authenticator**. The project includes various shell scripts to install OpenVPN, manage users, and create ZIP files with necessary credentials.

## Table of Contents

- [Scripts](#scripts)
  - [openvpn-install.sh](#openvpn-installsh)
  - [manage.sh](#managesh)
  - [create-zip.sh](#create-zipsh)
- [Template File](#template-file)
- [Usage](#usage)
- [Connecting with OpenVPN Client](#connecting-with-openvpn-client)

## Scripts

### openvpn-install.sh

The `openvpn-install.sh` script is used to install or remove OpenVPN on the server. It provides an easy way to set up OpenVPN on your server or remove it if necessary.

### manage.sh

The `manage.sh` script is a helper script that allows you to manage OpenVPN users. It provides options to create, revoke, or check the status of users.

### create-zip.sh

The `create-zip.sh` script creates a ZIP file containing the client credentials and information, including the user's password, private key password, and a QR code for 2FA.

## Template File

### openvpn.pam.template

The `openvpn.pam.template` file is a template for configuring PAM (Pluggable Authentication Module) for OpenVPN. It can be customized according to your OpenVPN setup requirements.

## Usage

1. **Clone the Repository**: Start by cloning this repository to your local machine:

    ```bash
    git clone https://github.com/zaheerahmad33/OpenVPN-2FA-GoogleAuth.git
    ```

2. **Navigate to the Repository Directory**: Change directory to the cloned repository:

    ```bash
    cd OpenVPN-2FA-GoogleAuth
    ```

3. **Make Scripts Executable**: Make all shell scripts executable:

    ```bash
    chmod +x *.sh
    ```

4. **Run Scripts as `sudo`**: The scripts need to be run with root access or sudo privileges. Make sure your user account has the necessary permissions. You can run the scripts as `sudo`:

    - **Installing OpenVPN**: To install or remove OpenVPN on the server, run:

        ```bash
        sudo ./openvpn-install.sh
        ```

5. **Configure PAM**: After installing OpenVPN, you need to configure PAM using the provided template file.

    - **Find the Path of `pam_google_authenticator.so`**: Depending on your system architecture (x86_64 or amd64), the path may vary. Use the following `find` command to locate the file:

        ```bash
        find / -name pam_google_authenticator.so 2>/dev/null
        ```

        Make note of the path returned by the command.

    - **Edit the PAM Template**: Open the `openvpn.pam.template` file in a text editor:

        ```bash
        nano openvpn.pam.template
        ```

        Replace the placeholder path in the template file with the path you found for the `pam_google_authenticator.so` file.

    - **Copy the Template to the PAM Configuration Directory**: After editing the `openvpn.pam.template` file, copy it to `/etc/pam.d/openvpn`:

        ```bash
        sudo cp openvpn.pam.template /etc/pam.d/openvpn
        ```

6. **Managing Users**: Utilize `manage.sh` to create, revoke, or check the status of OpenVPN users.

    - **Create Users**: 

        ```bash
        sudo ./manage.sh create
        ```

    - **Revoke Users**:

        ```bash
        sudo ./manage.sh revoke username
        ```

    - **Check User Status**:

        ```bash
        sudo ./manage.sh status
        ```

7. **Creating ZIP Files**: To generate a ZIP file containing client credentials and information, execute `create-zip.sh`:

    ```bash
    sudo ./create-zip.sh
    ```

    The script will prompt you for user input, such as the username of the client for whom you want to create the ZIP file. Follow the prompts to specify the user.

    The ZIP file will be created in the following location:

    ```plaintext
    /opt/openvpn/clients/clientname
    ```

    Here, `clientname` is the username of the client you provided during the script execution. This ZIP file contains the client's password, private key password, and a QR code for 2FA.


## Connecting with OpenVPN Client

1. **Unzip the Folder**: Navigate to the location where the ZIP file was created:

    ```plaintext
    /opt/openvpn/clients/clientname
    ```

    Unzip the folder to access its contents.

2. **Scan the QR Code**: Inside the unzipped folder, you will find a QR code image file (e.g., `qrcode.png`). Use a 2FA (two-factor authentication) app like **2FAS** or **Authy** to scan the QR code.

3. **Import the .ovpn File**: Import the `.ovpn` file found in the unzipped folder into your OpenVPN client. This file contains the configuration settings necessary to connect to the OpenVPN server.

4. **Provide Credentials**: When prompted by the OpenVPN client, provide the following credentials:

    - **Username**: Enter the username you created or specified.
    - **Password**: Enter the password associated with the username.
    - **Private Key Password**: If prompted, enter the private key password included in the ZIP file.
    - **2FA Code**: Enter the two-factor authentication code generated by your 2FA app after scanning the QR code.

5. **Connect**: Once all credentials are provided and the `.ovpn` file is imported, proceed to connect to the OpenVPN server using the OpenVPN client.

6. **Follow Further Instructions**: Follow any additional instructions provided by the OpenVPN client to establish a secure connection.

## Credits

This repository is based on modifications of scripts from the following repositories:

- [perfecto25/openvpn_2fa](https://github.com/perfecto25/openvpn_2fa)
- [angristan/openvpn-install](https://github.com/angristan/openvpn-install)

