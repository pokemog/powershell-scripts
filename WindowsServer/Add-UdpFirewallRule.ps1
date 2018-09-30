# Adding Firewall Rule for inbound port 5555
Import-Module NetSecurity
New-NetFirewallRule -Name Allow_Extron -DisplayName "Allow Extron UDP Packets" -Description "Allow
inbound UDP packets from Extron Products" -Protocol UDP -LocalPort 5555 -Enabled True -Profile Any -Action Allow