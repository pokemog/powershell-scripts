# Updates the modular's connection string to use deploy sql server
# Update BeaconClientIpAddress and GveServerHostIp with deploy server's hostname

[CmdletBinding(PositionalBinding = $false)]
Param (
    # Deploy Server Name
    [Parameter(Mandatory = $true)]
    [string] $ComputerName,
    # Path to Modular folder
    [Parameter(Mandatory = $false)]
    [string] $FolderPath = 'C:\inetpub\wwwroot\GVE\Modulars\Device',
    # SQL Server Host
    [Parameter(Mandatory = $true)]
    [string] $DbServerName,
    # GVE Database Name
    [Parameter(Mandatory = $true)]
    [string] $DbName,
    # SQL Server Username
    [Parameter(Mandatory = $true)]
    [String] $DbUsername,
    # SQL Server Password
    [Parameter(Mandatory = $true)]
    [string] $DbPassword
)

$BeaconClientIpAddress = $ComputerName
$GveServerHostIp = 'http://' + $ComputerName + '/GVE'

$SettingsFile = 'appsettings.json'
$SettingsPath = $FolderPath
$SettingsFilePath = Join-Path $SettingsPath $SettingsFile
$SettingsOutputPath = '.\output_files\release'
$SettingsOutputFilePath = Join-Path $SettingsOutputPath $SettingsFile

$Settings = (Get-Content -Path $SettingsFilePath -Raw) | ConvertFrom-Json
$Settings.AppSettings.BeaconClientIpAddress = $BeaconClientIpAddress
$Settings.AppSettings.GveServerHostIp = $GveServerHostIp

$SqlBuilder = New-Object System.Data.SqlClient.SqlConnectionStringBuilder -ArgumentList $Settings.ConnectionStrings.DefaultConnection
$SqlBuilder["Data Source"] = $DbServerName
$SqlBuilder["Initial Catalog"] = $DbName
$SqlBuilder["User ID"] = $DbUsername
$SqlBuilder["Password"] = $DbPassword

$Settings.ConnectionStrings.DefaultConnection = $SqlBuilder.ToString()
$Settings | ConvertTo-Json -Depth 10 | Out-File -FilePath $SettingsFilePath
