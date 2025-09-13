# WinRecon.ps1
# OSCP-style Windows Recon Script
# Searches folder names, file names, and file contents for sensitive keywords
# Includes hidden/system folders (e.g., StickyNotes)
# Outputs results as <Path> | Keyword: <keyword> | Type: <Folder/FileName/FileContent>
# Results saved to recon_results.txt in current directory

$CurrentDir = Get-Location
$ScriptName = "WinRecon.ps1"          # Script itself to ignore
$OutputFile = Join-Path $CurrentDir "recon_results.txt"

$keywords = @(
    "Passwords","Passphrases","Keys","Username","User account",
    "Creds","Users","Passkeys","configuration","dbcredential",
    "dbpassword","pwd","Login","Credentials","Notes"
)

$includeExtensions = @("*.txt","*.ini","*.cfg","*.config","*.xml","*.git","*.ps1","*.yml")
$excludeDirs = @("C:\Windows","C:\Program Files","C:\Program Files (x86)","C:\$Recycle.Bin","C:\System Volume Information")

# Likely folders to search
$PathsToSearch = @("C:\Users","C:\ProgramData","C:\Temp")

# Remove previous output if exists
if (Test-Path $OutputFile) { Remove-Item $OutputFile }

foreach ($path in $PathsToSearch) {

    Write-Host "[*] Searching in $path ..." -ForegroundColor Cyan

    # 1️⃣ Folder names (including hidden/system)
    Get-ChildItem -Path $path -Recurse -Directory -Force -ErrorAction SilentlyContinue | Where-Object {
        ($excludeDirs -notcontains $_.FullName)
    } | ForEach-Object {
        foreach ($kw in $keywords) {
            if ($_.Name -like "*$kw*") {
                "$($_.FullName) | Keyword: $kw | Type: Folder" | Out-File -FilePath $OutputFile -Append
            }
        }
    }

    # 2️⃣ File names and file content (including hidden/system)
    Get-ChildItem -Path $path -Recurse -Include $includeExtensions -File -Force -ErrorAction SilentlyContinue | Where-Object {
        $_.Name -ne $ScriptName
    } | ForEach-Object {
        $file = $_.FullName
        foreach ($kw in $keywords) {
            if ($_.Name -like "*$kw*") {
                "$file | Keyword: $kw | Type: FileName" | Out-File -FilePath $OutputFile -Append
            } elseif (Select-String -Path $file -Pattern $kw -Quiet) {
                "$file | Keyword: $kw | Type: FileContent" | Out-File -FilePath $OutputFile -Append
            }
        }
    }
}

Write-Host "`n[*] Scan complete. Results saved to $OutputFile" -ForegroundColor Green
