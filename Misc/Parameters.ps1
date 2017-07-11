[CmdletBinding()]
Param(
    # This parameter is mandatory
    [Parameter(Mandatory=$true)]
    [string]$abstractcommand,
    
    # This parameter is mandatory
    [Parameter(Mandatory=$true)]
    [string]$filePath,

    [Parameter(Mandatory=$false)]
    [switch]$noOutput
    )

if (-not $noOutput)
{
    Write-Host "abstractcommand = ", $abstractcommand
    Write-Host "filePath = " $filePath
}
