$VM = Get-SCVirtualMachine -VMMServer rnc-lab-scvmm01 -Name "RNCENG-VM-GVETP" | Where-Object {$_.Cloud.Name -eq "RNC-LAB-ENG1"}
$UserRole = Get-SCUserRole -VMMServer rnc-lab-scvmm01  -Name "ENG Users" -ID "cfb47d17-2725-4c97-a242-c086f4d7b6eb"
$Cloud = Get-SCCloud
$CPUType = Get-SCCPUType -VMMServer rnc-lab-scvmm01 | Where-Object {$_.Name -eq "3.60 GHz Xeon (2 MB L2 cache)"}
$VMNetwork = Get-SCVMNetwork | Where-Object {$_.Name -eq "ENG - Open Net"}
$NewVMName = "RNCENG-VM-GVE27"

New-SCVirtualMachine  -Cloud $Cloud -VM $VM -Name $NewVMName -Description "New Virtual Machine cloned from RNCENG-VM-GVE" -UserRole $UserRole -CPUCount 2 -MemoryMB 2048 -CPURelativeWeight 100 -CPULimitForMigration $false -CPUType $CPUType -StartAction AlwaysAutoTurnOnVM -StopAction SaveVM

# Replace Disk Drive with new blank Disk Drive named after VM Name
$VM = Get-SCVirtualMachine | Where-Object {$_.Name -eq $NewVMName}
$VirtualDiskDrive = Get-SCVirtualDiskDrive -VM $VM
Remove-SCVirtualDiskDrive -VirtualDiskDrive $VirtualDiskDrive
New-SCVirtualDiskDrive -Bus 0 -Dynamic -FileName $NewVMName -LUN 0 -IDE -VirtualHardDiskSizeMB 40000 -VM $VM

# Insert Windows Server 2016 DVD into DVD Drive
$ISO = Get-SCISO -VMMServer rnc-lab-scvmm01.extron.com | Where-Object {$_.Name -eq "en_windows_server_2016_x64_dvd_9327751.iso"}
$VirtualDVDDrive = Get-SCVirtualDVDDrive -VM $NewVMName
Remove-SCVirtualDVDDrive -VirtualDVDDrive $VirtualDVDDrive
New-SCVirtualDVDDrive -VM $NewVMName -Bus 1 -LUN 0 -ISO $ISO

# Connect Network Adapter to Open Net network
$VirtualNetworkAdapter = Get-SCVirtualNetworkAdapter -VM $NewVMName
Set-SCVirtualNetworkAdapter -VirtualNetworkAdapter $VirtualNetworkAdapter -VMNetwork $VMNetwork