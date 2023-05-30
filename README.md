# Winget-Package-Installer
PowerShell script to install programs using winget in the directory you specify. Each program is installed in a subfolder named winget package from the package ID.
# Usage
Automatic installation of winget packages using the JSON file named "packages.json" containing winget package IDs. For example:
```json
[
    "Ookla.Speedtest.CLI",
    "Telegram.TelegramDesktop",
    "Google.Chrome"
]
```
