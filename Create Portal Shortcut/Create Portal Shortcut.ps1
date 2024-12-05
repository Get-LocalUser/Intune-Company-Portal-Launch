# Define the path to the Company Portal executable
$companyPortalPath = Get-ChildItem -ErrorAction SilentlyContinue -Path "C:\Program Files\WindowsApps\" | Where-Object {
    $_.FullName -like "*Microsoft.CompanyPortal_*" -and
    $_.FullName -notlike "*neutral_*"
} | Select-Object -ExpandProperty FullName -First 1

# Find the executable
$companyPortalExe = Get-ChildItem -Path $companyPortalPath -Recurse | Where-Object { $_.Name -eq "CompanyPortal.exe" } | Select-Object -ExpandProperty FullName -First 1

# Verify the executable was found
if (-not $companyPortalExe) {
    Write-Output "CompanyPortal.exe not found. Exiting."
    Exit
}

# Define the Startup folder for all users
$users = Get-ChildItem -Path "C:\Users" -Directory
$startupFolderRelPath = "AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

foreach ($user in $users) {
    # Construct the user's Startup folder path
    $startupPath = Join-Path -Path $user.FullName -ChildPath $startupFolderRelPath

    # Check if the Startup folder exists
    if (-not (Test-Path -Path $startupPath)) {
        Write-Output "Startup folder not found for user $($user.Name). Skipping..."
        Continue
    }

    # Define the shortcut path
    $shortcutPath = Join-Path -Path $startupPath -ChildPath "CompanyPortal.lnk"

    # Check if the shortcut already exists
    if (Test-Path -Path $shortcutPath) {
        Write-Output "Shortcut already exists for user $($user.Name). Skipping..."
        Continue
    }

    # Create the shortcut
    $wshShell = New-Object -ComObject WScript.Shell
    $shortcut = $wshShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $companyPortalExe
    $shortcut.WorkingDirectory = Split-Path -Path $companyPortalExe
    $shortcut.Save()

    Write-Output "Shortcut for Company Portal created in $startupPath."
}

Write-Output "Shortcut creation process completed."
