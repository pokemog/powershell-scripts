[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [string]$abstractcommand,

    [Parameter(Mandatory=$true)]
    [string]$filePath,

    [Parameter(Mandatory=$false)]
    [switch]$noOutput
    )

if (-not $noOutput)
{
    Write-Host $abstractcommand
}
