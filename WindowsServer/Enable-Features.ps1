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

$features = @(
    'IIS-WebServerRole'
    'IIS-WebServer'
    'IIS-CommonHttpFeatures'
    'IIS-DefaultDocument'
    'IIS-DirectoryBrowsing'
    'IIS-HttpErrors'
    'IIS-StaticContent'
    'IIS-HealthAndDiagnostics'
    'IIS-HttpLogging'
    'IIS-Performance'
    'IIS-HttpCompressionStatic'
    'IIS-Security'
    'IIS-RequestFiltering'
    'IIS-WindowsAuthentication'
    'WAS-WindowsActivationService'
    'WAS-ProcessModel'
    'WAS-ConfigurationAPI'
    'NetFx4'
    'NetFx4Extended-ASPNET45'
    'WCF-Services45'
    'WCF-HTTP-Activation45 '
    'WCF-TCP-PortSharing45'
    'IIS-ApplicationDevelopment'
    'IIS-NetFxExtensibility45'
    'IIS-ISAPIExtensions'
    'IIS-ISAPIFilter'
    'IIS-ASP'
    'IIS-ASPNET45'
    'IIS-WebServerManagementTools'
    'IIS-ManagementConsole'
    'IIS-ManagementScriptingTools'
    'IIS-ManagementService'
    'Windows-Identity-Foundation'
    'ServerCore-WOW64'
)

# Retrieve lists of Windows Features to enable
#$features = Get-Content features.txt

# Enable the Features
foreach ($feature in $Features) {
    Enable-WindowsOptionalFeature -Online -FeatureName $feature -All
}