# Launch Company Portal on First Login with Autopilot

### Premise
This ensures that the Company Portal automatically launches for the first user who logs into a device after Autopilot enrollment so the device category can be set and it syncs with Intune. 
The marker files and Detection scripts prevent it from running again or for other users after it has been deployed. 

### Considerations/other
- This works with the User ESP enabled or disabled.
- This could break if/when the Company portal version number changes but I believe the way MS has it structured and the logic in the ps script it will continue to work but this will be tested when a new version comes out.

---

## Steps to Implement

### 1. Package the `Create Portal Shortcut.ps1` as a Win32 App
- **Install command**: `powershell.exe -ExecutionPolicy Bypass -File "Create Portal Shortcut.ps1"`
- **Install behavior**: Device
- **Detection rule**: Use the `Detection.ps1` script located in the Company "Create Portal Shortcut" folder.
- **Assignment**: Assign to a **User group** or **All Users**.

### 2. Upload the `Launch Portal.ps1` as a Win32 App
- **Install command**: `powershell.exe -ExecutionPolicy Bypass -File "Launch Portal.ps1"`
- **Install behavior**: User
- **Detection rule**: Use the `Detection.ps1` script located in the "Launch Portal" folder.
- **Dependencies**: Create Portal Shortcut.ps1: Automatically Install
- **Assignment**: Assign to a **User group** or **All Users**.
