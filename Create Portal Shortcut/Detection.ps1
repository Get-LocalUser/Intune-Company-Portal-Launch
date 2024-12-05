# Constants
$usersFolder = "C:\Users"
$shortcutName = "CompanyPortal.lnk"
$markerFilePath = "C:\ProgramData\MarkerFiles\CompanyPortalDetectionMarker.txt"

# Ensure the ProgramData\Company directory exists
$markerDirectory = Split-Path -Path $markerFilePath -Parent
if (-not (Test-Path -Path $markerDirectory)) {
    New-Item -Path $markerDirectory -ItemType Directory -Force | Out-Null
}

# Check if the marker file already exists
if (Test-Path -Path $markerFilePath) {
    Write-Output "Detection marker found. Reporting as detected."
    exit 0  # Detection already confirmed
}

# Initialize a flag to track if the shortcut is found
$shortcutFound = $false

# Scan through all user profiles
$profiles = Get-ChildItem -Path $usersFolder -Directory -ErrorAction SilentlyContinue
foreach ($profile in $profiles) {
    # Construct the Startup folder path for the user
    $startupFolder = Join-Path -Path $profile.FullName -ChildPath "AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

    # Construct the full shortcut path
    $shortcutPath = Join-Path -Path $startupFolder -ChildPath $shortcutName

    # Check if the shortcut exists
    if (Test-Path -Path $shortcutPath) {
        Write-Output "Shortcut found in $startupFolder"
        $shortcutFound = $true

        # Create the detection marker file
        New-Item -Path $markerFilePath -ItemType File -Force | Out-Null
        Add-Content -Path $markerFilePath -Value "Shortcut detected at $(Get-Date)"
        break  # Exit the loop once the shortcut is found
    }
}

# Final output and exit
if ($shortcutFound) {
    exit 0  # Detection successful
} else {
    Write-Output "Shortcut not detected in any profile"
    exit 1  # Detection failed
}