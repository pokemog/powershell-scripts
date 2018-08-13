# Create shares to deploy to GVE and temp shared folders
# https://community.spiceworks.com/topic/1068305-powrshell-to-add-multiple-security-groups-to-shares
New-Item -Path "C:\shared" -ItemType Directory
New-Item -Path "C:\inetpub\wwwroot\GVE"

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