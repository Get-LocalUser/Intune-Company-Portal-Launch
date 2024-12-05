# Path to the Users folder
$usersFolder = "C:\Users"

# Shortcut file name
$shortcutName = "CompanyPortal.lnk"

# Iterate through each user profile
$profiles = Get-ChildItem -Path $usersFolder -Directory -ErrorAction SilentlyContinue
foreach ($profile in $profiles) {
    # Construct the path to the Startup folder for the user
    $startupFolder = Join-Path -Path $profile.FullName -ChildPath "AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
    $shortcutPath = Join-Path -Path $startupFolder -ChildPath $shortcutName

    # Check if the shortcut exists
    if (Test-Path -Path $shortcutPath) {
        # Start the Company Portal if needed
        Write-Output "Found Company Portal shortcut at $shortcutPath"
        Start-Process -FilePath $shortcutPath

        # Wait for the app to launch
        Start-Sleep -Seconds 5

        # Delete the shortcut
        Write-Output "Deleting shortcut at $shortcutPath"
        Remove-Item -Path $shortcutPath -Force -Verbose

        # Create marker file for detetcion script
        $markerFilePath = "C:\ProgramData\MarkerFiles\CompanyPortalLaunchMarker.txt"
        New-Item -Path $markerFilePath -ItemType File -Force | Out-Null

    } else {
        Write-Output "No shortcut found for user profile: $($profile.Name)"
    }
}