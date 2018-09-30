$Path = '.\'
$Files = 'Settings.config', 'GVE.license.config', 'connectionStrings.config'

function UpdateSettings {
    param (
        $PathToSettingsFile,
        $ServerIp,
        $DbServerIp,
        $DbName,
        $DbUserName,
        $DbPassword,
        $RegKey
    )

    [Xml] $Xml = Get-Content $PathToSettingsFile
    
}
