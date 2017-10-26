# Setting Up Deploy Server for GVE
# https://peter.hahndorf.eu/blog/WindowsFeatureViaCmd.html
# Allow remote connections for RDP

## Enable Windows Features Prerequisites
#IIS-WebServerRole
#IIS-WebServer
#
## Common HTTP Features
#IIS-CommonHttpFeatures
#IIS-DefaultDocument
#IIS-DirectoryBrowsing
#IIS-HttpErrors
#IIS-StaticContent
#
## Health and Diagnostics
#IIS-HealthAndDiagnostics
#IIS-HttpLogging
#
## Performance
#IIS-Performance
#IIS-HttpCompressionStatic
#
## Security
#IIS-Security
#IIS-RequestFiltering
#IIS-WindowsAuthentication
#
## Windows Process Activation Service
#WAS-WindowsActivationService
#WAS-ProcessModel
#WAS-ConfigurationAPI
#
## .NET Framework 4.6 Features
#NetFx4
#NetFx4Extended-ASPNET45
#
## WCF Services
#WCF-Services45
#WCF-HTTP-Activation45 
#WCF-TCP-PortSharing45
#
## Application Development
#IIS-ApplicationDevelopment
#IIS-NetFxExtensibility45
#IIS-ASP
#IIS-ASPNET45
#IIS-ISAPIExtensions
#IIS-ISAPIFilter
#
## Management Tools
#IIS-WebServerManagementTools
#IIS-ManagementConsole
#IIS-ManagementScriptingTools
#IIS-ManagementService
#
#Windows-Identity-Foundation
#
## WOW64 support
#ServerCore-WOW64

# Retrieve lists of Windows Features to enable
$features = Get-Content features.txt
# Enabling the Features
foreach ($feature in $Features) {
    Enable-WindowsOptionalFeature -Online -FeatureName $feature
}

# Adding Firewall Rule for inbound port 5555
Import-Module NetSecurity
New-NetFirewallRule -Name Allow_Extron -DisplayName "Allow Extron UDP Packets" -Description "Allow
inbound UDP packets from Extron Products" -Protocol UDP -LocalPort 5555 -Enabled True -Profile Any -Action Allow

# Rename Computer
Get-ChildItem ENV:\ComputerName
Rename-Computer -NewName "RNCENG-VM-GVESM"

# Create shares to deploy to GVE and temp shared folders
# https://community.spiceworks.com/topic/1068305-powrshell-to-add-multiple-security-groups-to-shares
New-Item -Path "C:\shared" -ItemType Directory

Set-Location "C:\inetpub\wwwroot\GVE"
$Folders = "C:\inetpub\wwwroot\GVE", "C:\shared"
foreach ($Folder in $Folders) {
    ## Kill all inherited permissions
    $acl = Get-Acl $Folder
    $acl.SetAccessRuleProtection($true, $false)
    
    # Grant Everyone FullControl
    $everyone = [System.Security.Principal.NTAccount] "Everyone"
    $permission = $everyone, "FullControl", "ObjectInherit, ContainerInherit", "None", "Allow"
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.AddAccessRule($accessRule)

    # Set the ACL
    $acl | Set-Acl -Path $Folder
}

New-SmbShare -Name "GVE" -Path "C:\inetpub\wwwroot\GVE" -Description "GVE share for deployment" -FullAccess "Everyone"
New-SmbShare -Name "shared" -Path "C:\shared" -Description "GVE share for temp files" -FullAccess "Everyone"