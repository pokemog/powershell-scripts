[CmdletBinding()]
Param(
    # This parameter is mandatory
    [Parameter(Mandatory=$true)]
    [string]$Hostname,
    
    # This parameter is mandatory
    [Parameter(Mandatory=$true)]
    [string]$Username,

    [Parameter(Mandatory=$true)]
    [string]$PWord,

    [Parameter(Mandatory=$false)]
    [switch]$noOutput
)

$PWordSec = ConvertTo-SecureString -String $PWord -AsPlainText -Force
$Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $Username, $PWordSec

Invoke-Command -ComputerName $Hostname -ScriptBlock {Start-Service extron*} -Credential $Credential