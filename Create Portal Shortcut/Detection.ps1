$usersFolder = "C:\Users"
$shortcutName = "CompanyPortal.lnk"
$markerFilePath = "C:\ProgramData\MarkerFiles\CompanyPortalDetectionMarker.txt"

$markerDirectory = Split-Path -Path $markerFilePath -Parent
if (-not (Test-Path -Path $markerDirectory)) {
    New-Item -Path $markerDirectory -ItemType Directory -Force | Out-Null
}

if (Test-Path -Path $markerFilePath) {
    Write-Output "Detection marker found. Reporting as detected."
    exit 0
}

$shortcutFound = $false

$profiles = Get-ChildItem -Path $usersFolder -Directory -ErrorAction SilentlyContinue
foreach ($profile in $profiles) {
    $startupFolder = Join-Path -Path $profile.FullName -ChildPath "AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

    $shortcutPath = Join-Path -Path $startupFolder -ChildPath $shortcutName

    if (Test-Path -Path $shortcutPath) {
        Write-Output "Shortcut found in $startupFolder"
        $shortcutFound = $true

        New-Item -Path $markerFilePath -ItemType File -Force | Out-Null
        Add-Content -Path $markerFilePath -Value "Shortcut detected at $(Get-Date)"
        break
    }
}

if ($shortcutFound) {
    exit 0
} else {
    Write-Output "Shortcut not detected in any profile"
    exit 1 
}