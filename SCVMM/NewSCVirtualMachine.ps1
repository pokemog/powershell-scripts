$VM = Get-SCVirtualMachine -VMMServer rnc-lab-scvmm01 -Name "RNCENG-VM-GVEHD" | where {$_.Cloud.Name -eq "RNC-LAB-ENG1"}
$UserRole = Get-SCUserRole -VMMServer rnc-lab-scvmm01  -Name "ENG Users" -ID "cfb47d17-2725-4c97-a242-c086f4d7b6eb"
$Cloud = Get-SCCloud
$CPUType = Get-SCCPUType -VMMServer rnc-lab-scvmm01 | where {$_.Name -eq "3.60 GHz Xeon (2 MB L2 cache)"}

New-SCVirtualMachine -VM $VM -Name "RNCENG-VM-GVE" -Description "GVE Server to manage Extron" -UserRole $UserRole -CPUCount 4 -MemoryMB 4096 -CPURelativeWeight 100 -CPULimitForMigration $false -CPUType $CPUType -RunAsynchronously -StartAction AlwaysAutoTurnOnVM -StopAction SaveVM -Cloud $Cloud