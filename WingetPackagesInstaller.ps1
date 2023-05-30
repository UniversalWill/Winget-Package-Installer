# Display welcome message
Write-Host "===============================================" -ForegroundColor Green
Write-Host "    Welcome to the Winget Package Installer    " -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green
Write-Host

Write-Host "This script will install packages based on the"
Write-Host "package IDs specified in the 'packages.json' file."
Write-Host

Write-Host "Make sure the 'packages.json' file contains an array of package IDs."
Write-Host "Example:"
Write-Host @"
[
    "Ookla.Speedtest.CLI",
    "Telegram.TelegramDesktop",
    "Google.Chrome"
]
"@
Write-Host

$packagesFilePath = ".\packages.json"

# Check if the 'packages.json' file exists
if (-not (Test-Path $packagesFilePath)) {
    Write-Host "Could not find 'packages.json' file" -ForegroundColor Red
    Exit
}

try {
    $packages = Get-Content -Raw -Path $packagesFilePath | ConvertFrom-JSON -ErrorAction Stop
}
catch {
    Write-Host "An error occurred while reading 'packages.json':" -ForegroundColor Red
    Write-Host "$_" -ForegroundColor Red
    Exit
}

if ($packages -isnot [System.Array]) {
    Write-Host "Invalid 'packages.json' format. The file should contain an array of package IDs." -ForegroundColor Red
    Exit
}

# Check JSON content
$pattern = '.*\..*'
$isValid = $true

foreach ($package in $packages) {
    if ($package -notmatch $pattern) {
        Write-Host "'$package' does not ID package." -ForegroundColor Red
        $isValid = $false
    }
}

if ($isValid -eq $false) {
    Write-Host "Skipping installation." -ForegroundColor Red
    Exit
}

# Request the folder for package installation
$installFolder = Read-Host "Enter the folder for package installation"
$installFolder = $installFolder.Replace('"', '')

# Create the installation folder if it doesn't exist
New-Item -ItemType Directory -Force -Path $installFolder | Out-Null

# Function to install packages using winget
function Install-Packages {
    param (
        [System.Collections.Generic.List[String]] $Packages,
        [string] $InstallFolder
    )

    foreach ($package in $Packages) {
        $packageName = $package.Substring($package.IndexOf('.') + 1)
        Write-Host "Installing package: $packageName" -ForegroundColor Yellow
        #winget install --id $package --silent -l "$installFolder\$packageName"

        if ($LASTEXITCODE -eq 0) {
            Write-Host "$package installed successfully." -ForegroundColor Green
        }
        Write-Host
    }
}

# Install packages
Write-Host "Installing packages..." -ForegroundColor Cyan
Install-Packages -Packages $packages -InstallFolder $installFolder

# Summary
$installedPackages = @()
$skippedPackages = @()

foreach ($package in $packages) {
    $packageName = $package.Substring($package.IndexOf('.') + 1)
    
    if ($LASTEXITCODE -eq 0) {
        $installedPackages += $packageName
    } else {
        $skippedPackages += $packageName
    }
}

Write-Host "Summary:"
Write-Host "Installed packages:" -ForegroundColor Green
Write-Host ($installedPackages -join ", ")
Write-Host
Write-Host "Skipped packages:" -ForegroundColor Red
Write-Host ($skippedPackages -join ", ")
