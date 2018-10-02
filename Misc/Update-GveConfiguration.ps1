# Updates GVE's Settings.config, connectionStrings, and GVE.license.config

[CmdletBinding(PositionalBinding = $false)]
Param (
    # Path to GVE, defaults to GVE's default location
    [Parameter(Mandatory = $false)]
    [string] $GvePath = 'C:\inetpub\wwwroot\GVE\bin',
    # Deploy Server Name
    [Parameter(Mandatory = $true)]
    [string] $GveServerIp,
    # SQL Server Host
    [Parameter(Mandatory = $true)]
    [string] $DbServerIp,
    # GVE Database Name
    [Parameter(Mandatory = $true)]
    [string] $DbName,
    # SQL Server Username
    [Parameter(Mandatory = $false)]
    [String] $DbUsername = 'sa',
    # SQL Server Password
    [Parameter(Mandatory = $true)]
    [string] $DbPassword,
    # GVE Registration Key
    [Parameter(Mandatory = $true)]
    [string] $RegKey
)

function UpdateSettings {
    param (
        $PathToSettingsFile,
        $ServerIp,
        $DbServerIp,
        $DbName,
        $DbUsername,
        $DbPassword,
        $RegistrationKey
    )

    $Settings = @{
        'ServerIPAddress'         = $ServerIp;
        'DatabaseServerIP'        = $DbServerIp;
        'DatabaseName'            = $DbName;
        'DatabaseLoginName'       = $DbUsername;
        'DatabasePassword'        = $DbPassword;
        'ExistingRegistrationKey' = $RegistrationKey;
        'ApplicationRootPath'     = "http://$($ServerIP)/GVE/"
    }

    [Xml] $Xml = Get-Content $PathToSettingsFile

    foreach ($Setting in $Settings.GetEnumerator()) {
        $OldChild = $Xml.appSettings.add | Where-Object {$_.key -eq $Setting.Key}
        $NewChild = $OldChild.Clone()

        if ($Setting.Key -eq 'DatabasePassword') {
            $Setting.Value = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes(":$($Setting.Value)"))
        }

        $NewChild.value = $Setting.Value
        $Xml.appSettings.ReplaceChild($NewChild, $OldChild)
    }

    $Xml.Save($PathToSettingsFile)
}

function UpdateConnectionStrings {
    param (
        $PathToSettingsFile,
        $DbServerIp,
        $DbName,
        $DbUsername,
        $DbPassword
    )

    $DbContexts = 'gveconn', 'gveconnDbContext', 'GveModel'
    
    [Xml] $Xml = Get-Content $PathToSettingsFile
    
    foreach ($DbContext in $DbContexts) {
        $OldChild = $Xml.connectionStrings.add | Where-Object {$_.name -eq $DbContext}
        $NewChild = $OldChild.Clone()
        if ($DbContext -eq 'GveModel') {
            $SqlBuilder = New-Object System.Data.SqlClient.SqlConnectionStringBuilder
            $SqlBuilder["Data Source"] = $DbServerIp
            $SqlBuilder["Initial Catalog"] = $DbName
            $SqlBuilder["User ID"] = $DbUsername
            $SqlBuilder["Password"] = $DbPassword
            $SqlBuilder["MultipleActiveResultSets"] = $true

            $EntityBuilder = New-Object System.Data.EntityClient.EntityConnectionStringBuilder -ArgumentList $OldChild.connectionString
            $EntityBuilder["metadata"] = "res://*/EF.GveModel.csdl|res://*/EF.GveModel.ssdl|res://*/EF.GveModel.msl"
            $EntityBuilder["provider connection string"] = $SqlBuilder.ToString()
            $EntityBuilder["provider"] = 'System.Data.SqlClient'

            $NewChild.connectionString = $EntityBuilder.ToString()
            $Xml.connectionStrings.ReplaceChild($NewChild, $OldChild)
        }
        else {
            $SqlBuilder = New-Object System.Data.SqlClient.SqlConnectionStringBuilder -ArgumentList $OldChild.connectionString
            $SqlBuilder["Data Source"] = $DbServerIp
            $SqlBuilder["Initial Catalog"] = $DbName
            $SqlBuilder["User ID"] = $DbUsername
            $SqlBuilder["Password"] = $DbPassword

            $NewChild.connectionString = $SqlBuilder.ToString()
            $Xml.connectionStrings.ReplaceChild($NewChild, $OldChild)
        }
    }

    $Xml.Save($PathToSettingsFile)
}
function UpdateLicense {
    param (
        $PathToSettingsFile,
        $ServerIp,
        $RegistrationKey
    )
    
    [Xml] $Xml = Get-Content $PathToSettingsFile
    $Xml.RegistrationInfo.ExistingRegistrationKey = $RegistrationKey
    $Xml.RegistrationInfo.IPAddress = $ServerIp
    $Xml.Save($PathToSettingsFile)
}

$SettingsFiles = 'Settings.config', 'GVE.license.config', 'connectionStrings.config'
[System.Reflection.Assembly]::LoadWithPartialName('System.Data.Entity')

foreach ($SettingsFile in $SettingsFiles) {
    switch ($SettingsFile) {
        'Settings.config' {
            $FilePath = Join-Path -Path $GvePath -ChildPath $SettingsFile
            UpdateSettings $FilePath $GveServerIp $DbServerIp $DbName $DbUsername $DbPassword $RegKey
            break
        }
        'connectionStrings.config' {
            #C:\Windows\Microsoft.NET\Framework64\v4.0.30319\aspnet_regiis -pd "connectionStrings" -app /GVE
            $FilePath = Join-Path -Path $GvePath -ChildPath $SettingsFile
            UpdateConnectionStrings $FilePath $DbServerIp $DbName $DbUsername $DbPassword
        }
        'GVE.license.config' {
            $FilePath = Join-Path -Path $GvePath -ChildPath $SettingsFile
            UpdateLicense $FilePath $GveServerIp $RegKey
            break
        }
        Default {}
    }
}
