$markerFilePath = "C:\ProgramData\MarkerFiles\CompanyPortalLaunchMarker.txt"

$markerDirectory = Split-Path -Path $markerFilePath -Parent
if (-not (Test-Path -Path $markerDirectory)) {
    New-Item -Path $markerDirectory -ItemType Directory -Force | Out-Null
}

if (Test-Path -Path $markerFilePath) {
    Write-Output "Launch marker found. Reporting as already launched."
    exit 0 
}

if (-not(Test-Path -Path $markerFilePath)) {
    Write-Output "Marker file not detected at $markerFilePath"
    exit 1  # Detection failed
}
