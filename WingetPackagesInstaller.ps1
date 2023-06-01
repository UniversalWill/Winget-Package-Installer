# Copyright (c) 2023 Gennadiy Ivashchenko

param (
    [Parameter(Mandatory=$false)]
    [string]$JsonFilePath = ".\packages.json"
)

# Display welcome message
Write-Host "===============================================" -ForegroundColor Green
Write-Host "    Welcome to the Winget Package Installer    " -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green
Write-Host

Write-Host "This script will install packages based on the"
Write-Host "package IDs specified in the '$JsonFilePath' file."
Write-Host "On default .\package.json"

Write-Host "Make sure the '$JsonFilePath' file contains an array of package IDs."
Write-Host "Example:"
Write-Host @"
[
    "Ookla.Speedtest.CLI",
    "Telegram.TelegramDesktop",
    "Google.Chrome"
]
"@
Write-Host

# Function to check if Winget is installed
function IsWingetInstalled() {
    $wingetPath = (Get-Command winget -ErrorAction SilentlyContinue).Source

    if ($wingetPath) {
        return $true
    } else {
        return $false
    }
}

# Check if Winget is installed
if (isWingetInstalled) {
    Write-Host "Winget is already installed." -ForegroundColor Green
} else {
    Write-Host "Winget is not installed. " -ForegroundColor Red -NoNewLine
    $installChoice = Read-Host "Do you want to install it? (Y/N)"

    if ($installChoice -eq "Y" -or $installChoice -eq "y") {
        Write-Host "Installing Winget..."

        # Download the latest version of Winget MSIXBundle from GitHub
        $latestWingetMsixBundleUri = $(Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest).assets.browser_download_url | Where-Object {$_.EndsWith(".msixbundle")}
        $tempLatestWingetMsixBundle = "$env:TEMP\" + $latestWingetMsixBundleUri.Split("/")[-1]
        Invoke-WebRequest -Uri $latestWingetMsixBundleUri -OutFile $tempLatestWingetMsixBundle

        # Install the MSIXBundle package using Add-AppxPackage
        Add-AppxPackage -Path $tempLatestWingetMsixBundle

        Write-Host "Winget has been installed." -ForegroundColor Green

        # Clear the temporary files
        Remove-Item $tempLatestWingetMsixBundle -Force
    } else {
        Write-Host "Winget installation canceled." -ForegroundColor Red
        Exit
    }
}

# Check if the JSON file exists
if (-not (Test-Path $JsonFilePath)) {
    Write-Host "Could not find '$JsonFilePath' file" -ForegroundColor Red
    Exit
}

try {
    $packages = Get-Content -Raw -Path $JsonFilePath | ConvertFrom-JSON -ErrorAction Stop
}
catch {
    Write-Host "An error occurred while reading '$JsonFilePath':" -ForegroundColor Red
    Write-Host "$_" -ForegroundColor Red
    Exit
}

if ($packages -isnot [System.Array]) {
    Write-Host "Invalid '$JsonFilePath' format. The file should contain an array of package IDs." -ForegroundColor Red
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
Write-Host
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
        winget install --id $package --silent -l "$installFolder\$packageName"

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
