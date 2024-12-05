# Constants
$markerFilePath = "C:\ProgramData\MarkerFiles\CompanyPortalLaunchMarker.txt"

# Ensure the ProgramData\MarkerFiles directory exists
$markerDirectory = Split-Path -Path $markerFilePath -Parent
if (-not (Test-Path -Path $markerDirectory)) {
    New-Item -Path $markerDirectory -ItemType Directory -Force | Out-Null
}

# Check if the marker file already exists
if (Test-Path -Path $markerFilePath) {
    Write-Output "Launch marker found. Reporting as already launched."
    exit 0  # Detection confirmed
}

# Check if the shortcut exists
if (-not(Test-Path -Path $markerFilePath)) {
    Write-Output "Marker file not detected at $markerFilePath"
    exit 1  # Detection failed
}
