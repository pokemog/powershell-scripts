# Gets subfolders and unzips all the files within the folder
# Assumes 7z is available in the path
Get-Location | Push-Location
$Folders = Get-ChildItem -Directory

foreach ($folder in $Folders) {
    Set-Location $folder.FullName
    7z x -y *.zip
    if ($LASTEXITCODE -eq 0) {
        Remove-Item *.zip
    }
    7z x -y *.rar
    if ($LASTEXITCODE -eq 0) {
        Remove-Item *.r??
    }
}

Pop-Location