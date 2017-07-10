$User = "RNCENG-VM-GVEHD\GVE"
$PWord = ConvertTo-SecureString -String 'P@$$w0rd' -AsPlainText -Force
$Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User, $PWord

Invoke-Command -ComputerName RNCENG-VM-GVEHD -ScriptBlock {Start-Service extron*} -Credential $Credential
Invoke-Command -ComputerName RNCENG-VM-GVEHD -ScriptBlock {iisreset} -Credential $Credential