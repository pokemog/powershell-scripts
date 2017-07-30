$LogPath = 'C:\temp' # replace this with your root path...
Get-ChildItem -LiteralPath $LogPath -Force -Recurse | Where-Object {
    $_.PSIsContainer -and `
    @(Get-ChildItem -LiteralPath $_.Fullname -Force -Recurse | Where { -not $_.PSIsContainer }).Count -eq 0 } |
    Remove-Item -Recurse -WhatIf