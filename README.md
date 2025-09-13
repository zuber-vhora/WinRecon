# WinRecon - Windows Recon Script (OSCP Style)

**Script:** `WinRecon.ps1`

## Description
`WinRecon` is a Windows PowerShell script designed for OSCP-style recon. It searches for potential sensitive data on a Windows machine by scanning:

- Folder names (including hidden/system folders)
- File names
- File contents  

The script targets likely locations where credentials, notes, or configuration files may reside (e.g., `C:\Users`, `C:\ProgramData`, `C:\Temp`) and includes hidden/system directories like `StickyNotes`.

## Features
- Recursive search through user and system directories
- Looks for keywords such as:
  `Passwords, Passphrases, Keys, Username, Creds, Configuration, dbpassword, Notes, Login, Admin, etc.`
- Checks folder names, file names, and file contents
- Supports common file extensions (`.txt, .ini, .cfg, .xml, .git, .ps1, .yml`)
- Excludes system folders like `C:\Windows` and `C:\Program Files`
- Outputs results in `recon_results.txt` in the current directory

## Usage
1. Open PowerShell.
2. Navigate to the directory containing the script.
3. Run the script:
   ```powershell
   .\WinRecon.ps1
4. Results will be saved in recon_results.txt

## Output Format

<Path> | Keyword: <keyword> | Type: <Folder/FileName/FileContent>

Example:

```Output
C:\Users\Alice\Documents\Passwords.txt | Keyword: Passwords | Type: FileName
C:\Users\Alice\AppData\Local\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe\LocalState\plum.sqlite | Keyword: Notes | Type: FileContent
