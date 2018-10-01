$Path = 'C:\Users\matra\source\repos\gve2\Build\configurations'
$File = 'Settings.config' #, 'GVE.license.config', 'connectionStrings.config'

function UpdateSettings {
    param (
        $PathToSettingsFile,
        $ServerIp,
        $DbServerIp,
        $DbName,
        $DbUsername,
        $DbPassword,
        $RegKey
    )

    [Xml] $Xml = Get-Content $PathToSettingsFile
    $OldChild = $Xml.appSettings.add | Where-Object {$_.key -eq 'ServerIPAddress'}
    $NewChild = $OldChild.Clone()
    $NewChild.value = $ServerIp
    Write-Host "Old Child is: " $OldChild.value
    Write-Host "New Child is: " $NewChild.value
    $Xml.appSettings.ReplaceChild($NewChild, $OldChild)
    # $keyIdx = $Xml.appSettings.add.key.IndexOf('ServerIPAddress')
    # $Xml.appSettings.add.value[$keyIdx] = $ServerIp
    # $keyIdx = $Xml.appSettings.add.key.IndexOf('DBServerHostname')
    # $Xml.appSettings.add.value[$keyIdx] = $DbServerIp
    # $keyIdx = $Xml.appSettings.add.key.IndexOf('DatabaseName')
    # $Xml.appSettings.add.value[$keyIdx] = $DbName
    # $keyIdx = $Xml.appSettings.add.key.IndexOf('DatabaseLoginName')
    # $Xml.appSettings.add.value[$keyIdx] = $DbUsername
    # $keyIdx = $Xml.appSettings.add.key.IndexOf('DatabasePassword')
    # $Xml.appSettings.add.value[$keyIdx] = $DbPassword
    # $keyIdx = $Xml.appSettings.add.key.IndexOf('ExistingRegistrationKey')
    # $Xml.appSettings.add.value[$keyIdx] = $RegKey
    # $keyIdx = $Xml.appSettings.add.key.IndexOf('ApplicationRootPath')
    # $Xml.appSettings.add.value[$keyIdx] = "http://$ServerIp/GVE"

    # Set-Location 'C:\Users\matra\source\repos\gve2\Build\configurations'

    Write-Host = Get-Location
    $Xml.Save($PathToSettingsFile)
}

$FilePath = Join-Path -Path $Path -ChildPath $File
UpdateSettings $FilePath '192.168.1.1' '192.168.1.2' 'gve' 'sa' 'extron' 'Registration Key'
