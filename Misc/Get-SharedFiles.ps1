$binariesToSign = Get-ChildItem -Path \\172.18.11.27\GVE\bin -Include @("*.dll", "*.exe") -Recurse

foreach ($binary in $binariesToSign) {
    $tempBin= '\"' + $binary.FullName + '\"'
    Write-Host $tempBin
}