# ------------------------------------------------------------------------------
# Create Virtual Machine Wizard Script
# ------------------------------------------------------------------------------
# Script generated on Thursday, November 10, 2016 7:10:38 PM by Virtual Machine Manager
# 
# For additional help on cmdlet usage, type get-help <cmdlet name>
# ------------------------------------------------------------------------------

# List of availabe ISO's to use
# ------------------------------------------------------------------------------
# en_sql_server_2014_standard_edition_with_service_pack_1_x64_dvd_6669998.iso
# en_sql_server_2012_standard_edition_with_service_pack_2_x64_dvd_4692562.iso
# SW_DVD5_Windows_Svr_DC_EE_SE_Web_2008_R2_64Bit_English_w_SP1_MLF_X17-22580.ISO
# rhel-server-7.3-x86_64-dvd.iso
# en_visual_studio_professional_2012_x86_dvd_2262334.iso
# ubuntu-14.04.3-desktop-amd64.iso
# en_windows_7_professional_with_sp1_x64_dvd_u_676939.iso
# en_visual_studio_professional_2015_x86_x64_dvd_6846629.iso
# SW_DVD5_Windows_Svr_Std_and_DataCtr_2012_R2_64Bit_English_Core_MLF_X19-05182.ISO
# SW_DVD5_WIN_ENT_10_64BIT_English_MLF_X20-26061.ISO
# ubuntu-16.04-server-amd64_1.iso
# en_visual_studio_professional_2013_with_update_5_x86_dvd_6815752.iso
# systemrescuecd-x86-4.7.0.iso
# en_windows_8.1_enterprise_with_update_x64_dvd_6054382.iso
# WindowsPE.iso
# CentOS-6.7-x86_64-minimal.iso
# en_windows_server_2016_x64_dvd_9327751.iso
# en_sql_server_2014_enterprise_core_edition_x64_dvd_3935310.iso
# ubuntu-16.04-server-amd64.iso
# CentOS-7-x86_64-Everything-1511.iso
# en_windows_server_2008_r2_standard_enterprise_datacenter_and_web_with_sp1_x64_dvd_617601.iso
# ubuntu-16.04-desktop-amd64.iso
# gparted-live-0.24.0-2-amd64.iso
# SW_DVD5_WIN_ENT_10_1511.2_64BIT_English_MLF_X20-99544.ISO

New-SCVirtualScsiAdapter -VMMServer rnc-lab-scvmm01.extron.com -JobGroup ee7c3ed5-6d6a-4016-909f-5ac532022d2c -AdapterID 255 -ShareVirtualScsiAdapter $false -ScsiControllerType DefaultTypeNoType 

$ISO = Get-SCISO -VMMServer rnc-lab-scvmm01.extron.com | Where-Object {$_.Name -eq "en_windows_server_2016_x64_dvd_9327751.iso"}

New-SCVirtualDVDDrive -VMMServer rnc-lab-scvmm01.extron.com -JobGroup ee7c3ed5-6d6a-4016-909f-5ac532022d2c -Bus 1 -LUN 0 -ISO $ISO 

$VMNetwork = Get-SCVMNetwork -VMMServer rnc-lab-scvmm01.extron.com -Name "ENG - Open Net"

New-SCVirtualNetworkAdapter -VMMServer rnc-lab-scvmm01.extron.com -JobGroup ee7c3ed5-6d6a-4016-909f-5ac532022d2c -MACAddressType Dynamic -Synthetic -EnableVMNetworkOptimization $false -IPv4AddressType Dynamic -IPv6AddressType Dynamic -VMNetwork $VMNetwork 


Set-SCVirtualCOMPort -NoAttach -VMMServer rnc-lab-scvmm01.extron.com -GuestPort 1 -JobGroup ee7c3ed5-6d6a-4016-909f-5ac532022d2c 


Set-SCVirtualCOMPort -NoAttach -VMMServer rnc-lab-scvmm01.extron.com -GuestPort 2 -JobGroup ee7c3ed5-6d6a-4016-909f-5ac532022d2c 


Set-SCVirtualFloppyDrive -RunAsynchronously -VMMServer rnc-lab-scvmm01.extron.com -NoMedia -JobGroup ee7c3ed5-6d6a-4016-909f-5ac532022d2c 

$CPUType = Get-SCCPUType -VMMServer rnc-lab-scvmm01.extron.com | Where-Object {$_.Name -eq "3.60 GHz Xeon (2 MB L2 cache)"}

$CapabilityProfile = Get-SCCapabilityProfile -VMMServer rnc-lab-scvmm01.extron.com | Where-Object {$_.Name -eq "Hyper-V"}

# Uncomment to create a new Hardware Profile
# Existing Profile has:
# CPUCount = 2
# Memory = 2048 MB
# 
# New-SCHardwareProfile -VMMServer rnc-lab-scvmm01.extron.com -CPUType $CPUType -Name "Profile6877b040-f7fb-4d4f-b349-f9d6e6d92c35" -Description "Profile used to create a VM/Template" -CPUCount 2 -MemoryMB 2048 -VirtualVideoAdapterEnabled $false -CPUExpectedUtilizationPercent 20 -DiskIops 0 -CPUMaximumPercent 100 -CPUReserve 0 -NetworkUtilizationMbps 0 -CPURelativeWeight 100 -HighlyAvailable $false -DRProtectionRequired $false -NumLock $false -BootOrder "CD", "IdeHardDrive", "PxeBoot", "Floppy" -CPULimitFunctionality $false -CPULimitForMigration $false -CapabilityProfile $CapabilityProfile -JobGroup ee7c3ed5-6d6a-4016-909f-5ac532022d2c 


$VM = Get-SCVirtualMachine -VMMServer rnc-lab-scvmm01.extron.com -Name "RNCENG-VM-GVEDD" -ID "25ea91f6-928a-4389-8b2f-6c4e266505f5" | Where-Object {$_.Cloud.Name -eq "RNC-LAB-ENG1"}
$Cloud = Get-SCCloud -VMMServer rnc-lab-scvmm01.extron.com | Where-Object {$_.Name -eq "RNC-LAB-ENG1"}
$HardwareProfile = Get-SCHardwareProfile -VMMServer rnc-lab-scvmm01.extron.com | Where-Object {$_.Name -eq "Profile6877b040-f7fb-4d4f-b349-f9d6e6d92c35"}

New-SCVirtualMachine -VM $VM -Name "RNCENG-VM-GVEHD" -Description "GVE deployment server for Help Desk Improvement Feature" -JobGroup ee7c3ed5-6d6a-4016-909f-5ac532022d2c -RunAsynchronously -Cloud $Cloud -HardwareProfile $HardwareProfile -StartAction AlwaysAutoTurnOnVM -DelayStartSeconds 0 -StopAction SaveVM 

# Parameter Set: NewVmFromHWProfile
New-SCVirtualMachine [-Name] "RNCENG-VM-GTEST" -Cloud $Cloud -VM $VM [-BlockDynamicOptimization <Boolean> ] [-CPUCount <Byte> ] [-CPULimitForMigration <Boolean> ] [-CPULimitFunctionality <Boolean> ] [-CPURelativeWeight <Int32> ] [-CPUType <ProcessorType> ] [-DelayStartSeconds <Int32> ] [-Description <String> ] [-DynamicMemoryBufferPercentage <Int32> ] [-DynamicMemoryEnabled <Boolean> ] [-DynamicMemoryMaximumMB <Int32> ] [-HardwareProfile <HardwareProfile> ] [-HighlyAvailable <Boolean> ] [-JobGroup <Guid> ] [-JobVariable <String> ] [-MemoryMB <Int32> ] [-MemoryWeight <Int32> ] [-MonitorMaximumCount <Int32> ] [-MonitorMaximumResolution <String> ] [-OperatingSystem <OperatingSystem> ] [-Owner <String> ] [-PROTipID <Guid> ] [-ReturnImmediately] [-RunAsynchronously] [-SkipInstallVirtualizationGuestServices] [-StartAction <VMStartAction> ] [-StartVM] [-StopAction <VMStopAction> ] [-UseLocalVirtualHardDisk] [-UserRole <UserRole> ] [-VirtualVideoAdapterEnabled <Boolean> ] [-VMMServer <ServerConnection> ] [ <CommonParameters>]

