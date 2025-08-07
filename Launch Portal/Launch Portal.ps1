$usersFolder = "C:\Users"

$shortcutName = "CompanyPortal.lnk"

$profiles = Get-ChildItem -Path $usersFolder -Directory -ErrorAction SilentlyContinue
foreach ($profile in $profiles) {

    $startupFolder = Join-Path -Path $profile.FullName -ChildPath "AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
    $shortcutPath = Join-Path -Path $startupFolder -ChildPath $shortcutName

    if (Test-Path -Path $shortcutPath) {

        Write-Output "Found Company Portal shortcut at $shortcutPath"
        Start-Process -FilePath $shortcutPath

        Start-Sleep -Seconds 5

        Write-Output "Deleting shortcut at $shortcutPath"
        Remove-Item -Path $shortcutPath -Force -Verbose

        $markerFilePath = "C:\ProgramData\MarkerFiles\CompanyPortalLaunchMarker.txt"
        New-Item -Path $markerFilePath -ItemType File -Force | Out-Null

    } else {
        Write-Output "No shortcut found for user profile: $($profile.Name)"
    }
}