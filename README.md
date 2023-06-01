
# Winget Package Installer
This PowerShell script installs packages using the Windows Package Manager (winget) based on the package IDs specified in a JSON file.

## Usage
1. Clone or download the script file.

2. Open a PowerShell terminal and navigate to the directory where the script is located.

3. Run the script using the following command:
```powershell
.\WingetPackagesInstaller.ps1
```

4. Follow the on-screen instructions.

## Configuration
The script supports the following configuration options:

+ `JsonFilePath` (optional): The path to the JSON file containing the package IDs. By default, it uses .\packages.json as the file path. Make sure the JSON file contains an array of package IDs.

Example JSON file:
```json
[
    "Ookla.Speedtest.CLI",
    "Telegram.TelegramDesktop",
    "Google.Chrome"
]
```
+ `InstallFolder`: The folder where the packages will be installed. The script will prompt you to enter the folder during execution.

## Prerequisites
-   PowerShell 5.1 or later.
-   Windows 10 or later with Winget installed. If Winget is not installed, the script will prompt you to install it.

## License

This script is licensed under the [MIT License](LICENSE).
