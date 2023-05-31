# Winget Package Installer
This script is designed to install packages using the Windows Package Manager (winget) based on the package IDs specified in the packages.json file.

# Usage
1. Make sure you have PowerShell installed on your system.
2. Download or clone this repository to your local machine.
3. Open a PowerShell session and navigate to the directory where you saved the script.

# Display Welcome Message
The script will display a welcome message when executed:
```powershell
===============================================
    Welcome to the Winget Package Installer    
===============================================

This script will install packages based on the
package IDs specified in the 'packages.json' file.

Make sure the 'packages.json' file contains an array of package IDs.
Example:

[
    "Ookla.Speedtest.CLI",
    "Telegram.TelegramDesktop",
    "Google.Chrome"
]
```

# Check if Winget is Installed
The script will check if Winget is already installed on your system. If it is installed, it will display a message indicating so. Otherwise, it will prompt you to install Winget.

# Install Winget (if not installed)
If Winget is not installed on your system, the script will prompt you to install it. If you choose to install Winget, the script will download the latest version of the Winget MSIXBundle from GitHub and install it using Add-AppxPackage.

# Specify Package IDs
The script expects a packages.json file in the same directory, which should contain an array of package IDs. Make sure to specify the package IDs in the following format:
```json
[
    "Ookla.Speedtest.CLI",
    "Telegram.TelegramDesktop",
    "Google.Chrome"
]
```
# Specify Package Installation Folder
The script will prompt you to enter the folder where the packages should be installed. Provide the desired folder path, and the script will create the installation folder if it doesn't exist.

# Install Packages
The script will install the packages using Winget. It will display the progress and status of each package installation.

# Summary
Once the installation is complete, the script will provide a summary of the installed packages and any skipped packages.
