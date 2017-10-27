secedit /export /cfg c:\old.cfg
(Get-Content c:\old.cfg) | ForEach-Object { $_ -replace "PasswordComplexity = 1", "PasswordComplexity = 0" } | Set-Content c:\new.cfg
secedit /configure /db $env:windir\security\new.sdb /cfg c:\new.cfg /areas SECURITYPOLICY
Remove-Item c:\new.cfg
Remove-Item c:\old.cfg
