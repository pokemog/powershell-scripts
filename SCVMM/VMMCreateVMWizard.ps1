# ------------------------------------------------------------------------------
# Create Virtual Machine Wizard Script
# ------------------------------------------------------------------------------
# Script generated on Thursday, November 10, 2016 7:10:38 PM by Virtual Machine Manager
# 
# For additional help on cmdlet usage, type get-help <cmdlet name>
# ------------------------------------------------------------------------------


New-SCVirtualScsiAdapter -VMMServer rnc-lab-scvmm01.extron.com -JobGroup ee7c3ed5-6d6a-4016-909f-5ac532022d2c -AdapterID 255 -ShareVirtualScsiAdapter $false -ScsiControllerType DefaultTypeNoType 

$ISO = Get-SCISO -VMMServer rnc-lab-scvmm01.extron.com -ID "70ad38db-ddb1-4233-aac3-45aebb451add" | where {$_.Name -eq "SW_DVD5_Windows_Svr_Std_and_DataCtr_2012_R2_64Bit_English_Core_MLF_X19-05182.ISO"}

New-SCVirtualDVDDrive -VMMServer rnc-lab-scvmm01.extron.com -JobGroup ee7c3ed5-6d6a-4016-909f-5ac532022d2c -Bus 1 -LUN 0 -ISO $ISO 

$VMNetwork = Get-SCVMNetwork -VMMServer rnc-lab-scvmm01.extron.com -Name "ENG - Open Net" -ID "f570bc62-25c5-4910-8bda-15f93685f16e"

New-SCVirtualNetworkAdapter -VMMServer rnc-lab-scvmm01.extron.com -JobGroup ee7c3ed5-6d6a-4016-909f-5ac532022d2c -MACAddressType Dynamic -Synthetic -EnableVMNetworkOptimization $false -IPv4AddressType Dynamic -IPv6AddressType Dynamic -VMNetwork $VMNetwork 


Set-SCVirtualCOMPort -NoAttach -VMMServer rnc-lab-scvmm01.extron.com -GuestPort 1 -JobGroup ee7c3ed5-6d6a-4016-909f-5ac532022d2c 


Set-SCVirtualCOMPort -NoAttach -VMMServer rnc-lab-scvmm01.extron.com -GuestPort 2 -JobGroup ee7c3ed5-6d6a-4016-909f-5ac532022d2c 


Set-SCVirtualFloppyDrive -RunAsynchronously -VMMServer rnc-lab-scvmm01.extron.com -NoMedia -JobGroup ee7c3ed5-6d6a-4016-909f-5ac532022d2c 

$CPUType = Get-SCCPUType -VMMServer rnc-lab-scvmm01.extron.com | where {$_.Name -eq "3.60 GHz Xeon (2 MB L2 cache)"}

$CapabilityProfile = Get-SCCapabilityProfile -VMMServer rnc-lab-scvmm01.extron.com | where {$_.Name -eq "Hyper-V"}

New-SCHardwareProfile -VMMServer rnc-lab-scvmm01.extron.com -CPUType $CPUType -Name "Profile6877b040-f7fb-4d4f-b349-f9d6e6d92c35" -Description "Profile used to create a VM/Template" -CPUCount 2 -MemoryMB 2048 -VirtualVideoAdapterEnabled $false -CPUExpectedUtilizationPercent 20 -DiskIops 0 -CPUMaximumPercent 100 -CPUReserve 0 -NetworkUtilizationMbps 0 -CPURelativeWeight 100 -HighlyAvailable $false -DRProtectionRequired $false -NumLock $false -BootOrder "CD", "IdeHardDrive", "PxeBoot", "Floppy" -CPULimitFunctionality $false -CPULimitForMigration $false -CapabilityProfile $CapabilityProfile -JobGroup ee7c3ed5-6d6a-4016-909f-5ac532022d2c 


$VM = Get-SCVirtualMachine -VMMServer rnc-lab-scvmm01.extron.com -Name "RNCENG-VM-GVEDD" -ID "25ea91f6-928a-4389-8b2f-6c4e266505f5" | where {$_.Cloud.Name -eq "RNC-LAB-ENG1"}
$Cloud = Get-SCCloud -VMMServer rnc-lab-scvmm01.extron.com | where {$_.Name -eq "RNC-LAB-ENG1"}
$HardwareProfile = Get-SCHardwareProfile -VMMServer rnc-lab-scvmm01.extron.com | where {$_.Name -eq "Profile6877b040-f7fb-4d4f-b349-f9d6e6d92c35"}

New-SCVirtualMachine -VM $VM -Name "RNCENG-VM-GVEHD" -Description "GVE deployment server for Help Desk Improvement Feature" -JobGroup ee7c3ed5-6d6a-4016-909f-5ac532022d2c -RunAsynchronously -Cloud $Cloud -HardwareProfile $HardwareProfile -StartAction AlwaysAutoTurnOnVM -DelayStartSeconds 0 -StopAction SaveVM 


