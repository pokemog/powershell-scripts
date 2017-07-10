 # Retrieves logged on users at -ComputerName ""
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [string]$ComputerName
)

Get-WmiObject Win32_Process -Filter 'name="explorer.exe"' -ComputerName $computerName | ForEach-Object {$owner = $_.GetOwner(); '{0}\{1}' -f $owner.Domain, $owner.User } | Sort-Object | Get-Unique