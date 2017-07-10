<######################################################################
# V1.0 Begin
######################################################################>
CLS
# Exchange Module Check
write-host "Checking to see if the Exchange Management PowerShell is installed"
if ((get-pssnapin -name Microsoft.Exchange.Management.PowerShell.SnapIn -ErrorAction SilentlyContinue | foreach { $_.Name }) -ne "Microsoft.Exchange.Management.PowerShell.E2010")
{
write-host Exchange Management PowerShell is not added to this session, adding it now...
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn -ErrorAction SilentlyContinue
}
else
{
write-host Exchange Management PowerShell is good to go. -backgroundcolor black -foregroundcolor green
start-sleep -s 1
}
write-host
write-host

$xAppName    = "Configure-Exchange2016"
$startsleep = 10
[BOOLEAN]$global:xExitSession=$false
function LoadMenuSystem(){
	[INT]$xMenu1=0
	[INT]$xMenu2=0
	[BOOLEAN]$xValidSelection=$false
	while ( $xMenu1 -lt 1 -or $xMenu1 -gt 14 ){
		CLS
		#â€¦ Present the Menu Options
        Write-Host "`n`tConfigure Exchange 2016 Script created by Ward Vissers" -Fore Cyan
        Write-Host "`n`twww.wardvissers.nl" -Fore Cyan
        Write-Host "`n`tThis Script Configure Exchange 2016 " -Fore Cyan
        Write-Host "`n`tTested With Exchange 2016 RTM" -Fore Cyan
        Write-Host "`n`t" -Fore Cyan
        Write-Host "`n`tTHIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE RISK" -Fore Cyan
        Write-Host "`n`tOF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER " -Fore Cyan
        Write-Host "`n`t" -Fore Cyan
        Write-Host "`n`tLatest V1.0" -Fore Cyan
		Write-Host "`n`t" -Fore Cyan
		Write-Host "`t`tPlease select the admin area you require`n" -Fore Cyan
		Write-Host "`t`t`t1. Exchange Version & Health Status" -Fore Cyan
		Write-Host "`t`t`t2. Configure Exchange 2016" -Fore Cyan
		Write-Host "`t`t`t3. Get Special Mailboxes" -Fore Cyan
		Write-Host "`t`t`t4. Create & Configure DAG" -Fore Cyan
        Write-Host "`t`t`t5. Certificates" -Fore Cyan
        Write-Host "`t`t`t6. Exchange 2016 Best Practise" -Fore Cyan
        Write-Host "`t`t`t7. VMware & Hyper-V Best Practise" -Fore Cyan
        Write-Host "`t`t`t8. Export Mailbox to PST" -Fore Cyan
        Write-Host "`t`t`t9. Exchange 2010/Exchange 2016 Migratie" -Fore Cyan
        Write-Host "`t`t`t10. Exchange Edge Subscription" -Fore Cyan
        Write-Host "`t`t`t11. Fixes" -Fore Cyan
        Write-Host "`t`t`t12. Mountpoints" -Fore Cyan
        Write-Host "`t`t`t13. DAG Maintaince" -Fore Cyan
        Write-Host "`t`t`t14. Quit and exit`n" -Fore Cyan
		#â€¦ Retrieve the response from the user
		[int]$xMenu1 = Read-Host "`t`tEnter Menu Option Number"
		if( $xMenu1 -lt 1 -or $xMenu1 -gt 14){
			Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
		}
	}
	Switch ($xMenu1){    #â€¦ User has selected a valid entry.. load next menu
		1 {
			while ( $xMenu2 -lt 1 -or $xMenu2 -gt 8 ){
				CLS
				# Present the Menu Options
				Write-Host "`n`tExchange Version & Health Status4" -Fore Magenta
				Write-Host "`t`tPlease select the administration task you require`n" -Fore Cyan
                Write-Host "`t`t`t1. Get Exchange Build Number(s)"  -Fore Cyan
                Write-Host "`t`t`t2. Get-ServerHealth"  -Fore Cyan
                Write-Host "`t`t`t3. Get-HealthReport"  -Fore Cyan
                Write-Host "`t`t`t4. When is the last Full Backup Runned"  -Fore Cyan
                Write-Host "`t`t`t5. MailboxDatabase in GB"  -Fore Cyan
                Write-Host "`t`t`t6. List of all mailboxes on a Exchange server sorted on size."  -Fore Cyan
                Write-Host "`t`t`t7. Check Database White Space"  -Fore Cyan
				Write-Host "`t`t`t8. Go to Main Menu`n" -Fore Cyan
				[int]$xMenu2 = Read-Host "`t`tEnter Menu Option Number"
				if( $xMenu2 -lt 1 -or $xMenu2 -gt 8 ){
					Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
				}
			}
			Switch ($xMenu2){
                1{ 
                 Get-ExchangeServer | Select Name, Edition, AdminDisplayVersion, ServerRole ;start-Sleep -Seconds $startsleep
                 }
                2{ 
                 $servername = Read-Host 'What is the Servername?'
                 get-serverhealth -identity $servername | ? AlertValue -ne unHealthy | ft -autosize ;start-Sleep -Seconds $startsleep
                 }
                3{  
                 $servername = Read-Host 'What is the Servername?'
                 Get-Healthreport -identity $servername ;start-Sleep -Seconds $startsleep
                 }
                4{ 
                 # Check the Last Full Backup
                 $servername = Read-Host 'What is the Servername?'
                 Get-MailboxDatabase -Server $servername -Status | fl Name,*FullBackup ;start-Sleep -Seconds $startsleep
                 }
              `	5{ 
                 # MailboxDatabase in GB
                 $servername = Read-Host 'What is the Servername?'
                 get-mailboxdatabase -server $servername -includepre | foreach-object{select-object -inputobject $_ -property *,@{name="MailboxDBSizeinGB";expression={[math]::Round(((get-item ("\\" + $_.servername + "\" + $_.edbfilepath.pathname.replace(":","$"))).length / 1GB),2)}}} | Sort-Object mailboxdbsizeinGB -Descending | format-table identity,mailboxdbsizeinGB -autosize ;start-Sleep -Seconds $startsleep
                 }
                6{ 
                 # list of all mailboxes on a Exchange server sorted on size.
                 $mailboxstats = Read-Host 'Give the CSV locatie like c:\mailboxstats.csv ?'
                  get-mailbox -ResultSize unlimited | Sort-Object TotalItemSize -Descending | select-object DisplayName, IssueWarningQuota, ProhibitSendQuota, @{label="TotalItemSize(MB)";expression={(get-mailboxstatistics $_).TotalItemSize.Value.ToGB()}}, @{label="ItemCount";expression={(get-mailboxstatistics $_).ItemCount}}, Database | Export-Csv $mailboxstats –NoTypeInformation ;start-Sleep -Seconds $startsleep
                 }
                7{
                 # Check Database White Space
                 Get-MailboxDatabase -Status | Sort-Object DatabaseSize -Descending | Format-Table Name, DatabaseSize, AvailableNewMailboxSpace ;start-Sleep -Seconds $startsleep
                 }
				default { Write-Host "You Selected Option 7 Go to Main Menu`n" -Fore Yellow; break}
			}
		}
		2 {
			while ( $xMenu2 -lt 1 -or $xMenu2 -gt 19 ){
				CLS
				# Present the Menu Options
				Write-Host "`n`tConfigure Exchange 2016" -Fore Magenta
				Write-Host "`t`tPlease select the administration task you require`n" -Fore Cyan
				Write-Host "`t`t`t1. Disable Outlook Auto-Mapping with Full Access Mailboxes" -Fore Cyan
                Write-Host "`t`t`t2. Force Enable cached mode in Outlook 2016" -Fore Cyan
                Write-Host "`t`t`t3. Enable MailTips" -Fore Cyan
                Write-Host "`t`t`t4. OWA Standard op NL zetten" -Fore Cyan
                Write-Host "`t`t`t5. New Accepted Authoritative Domain" -Fore Cyan
                Write-Host "`t`t`t6. Configure Virtual Directory's" -Fore Cyan
                Write-Host "`t`t`t7. Get Virtual Directory's" -Fore Cyan
                Write-Host "`t`t`t8. Disable Form Based Authentication & Enable Basic & Windows Authenticatie" -Fore Cyan
                Write-Host "`t`t`t9. Set Postmaster Address" -Fore Cyan
                Write-Host "`t`t`t10. Block Outlook Versions till Outlook 2007" -Fore Cyan
                Write-Host "`t`t`t11. New Mailbox Database" -Fore Cyan
                Write-Host "`t`t`t12. Get-MailboxDatabase(s)" -Fore Cyan
                Write-Host "`t`t`t13. Set Mailbox Database Quota"  -Fore Cyan
                Write-Host "`t`t`t14. Set Deleted Item Retention" -Fore Cyan
                Write-Host "`t`t`t15. Move Arbitration Mailbox" -Fore Cyan
                Write-Host "`t`t`t16. Configure Outlook Anywhere" -Fore Cyan
                Write-Host "`t`t`t17. Get SafetyNetHoldTime (Default 2 Days)" -Fore Cyan
                Write-Host "`t`t`t18. Set SafetyNetHoldTime"  -Fore Cyan
                Write-Host "`t`t`t19. Go to Main Menu`n" -Fore Cyan
				[int]$xMenu2 = Read-Host "`t`tEnter Menu Option Number"
			}
			if( $xMenu2 -lt 1 -or $xMenu2 -gt 19 ){
				Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
			}
			Switch ($xMenu2){
	            1{                
                 #Disable Outlook Auto-Mapping with Full Access Mailboxes
                 $FixAutoMapping = Get-MailboxPermission sharedmailbox |where {$_.AccessRights -eq "FullAccess" -and $_.IsInherited -eq $false}
                 $FixAutoMapping | Remove-MailboxPermission
                 $FixAutoMapping | ForEach {Add-MailboxPermission -Identity $_.Identity -User $_.User -AccessRights:FullAccess -AutoMapping $false} 
                 }
                2{
                 # Force Enable cached mode in Outlook 2016. The configuration of cached mode can be made from the client side, by applying a Group Policy, or by forcing it at the Exchange servers:
                 Set-CasMailbox MailboxName –MAPIBlockOutlookNonCachedMode:$true ;start-Sleep -Seconds $startsleep
                 }
                3{
                 # Enable Mailtips
                 Set-OrganizationConfig -MailTipsAllTipsEnabled $true ;start-Sleep -Seconds $startsleep
                 }
                4{
                 # OWA LogonAndErrorLanguage &  DefaultClientLanguage 1043 
                 Set-OwaVirtualDirectory -identity "Owa (Default Web Site)" -LogonAndErrorLanguage 1043 ;start-Sleep -Seconds $startsleep
                 Set-OwaVirtualDirectory -identity "Owa (Default Web Site)" -DefaultClientLanguage 1043 ;start-Sleep -Seconds $startsleep
                 }
                5{
                 # Nieuw Accepted Domain
                 $domainname = Read-Host 'What is the Domain Name?'
                 New-AcceptedDomain -DomainName $domainname -DomainType Authoritative -Name $domainname ;start-Sleep -Seconds $startsleep
                 }
                6{
                 # Configure Virtual Directory's
                 $domainname = Read-Host 'What is the Domain Name?'
                 $servername = Read-Host 'What is the Server Name?'
                 $internalurl = Read-Host 'What is the Internal URL?'
                 $externalurl = Read-Host 'What is the External URL?'
                 Set-OwaVirtualDirectory -Identity $servername"\OWA (default Web site)" -InternalURL $internalurl/ECP -ExternalURL $externalurl/ECP
                 Set-ClientAccessServer -Identity $servername -AutoDiscoverServiceInternalUri $internalurl/Autodiscover/Autodiscover.xml 
                 Set-OABVirtualDirectory -Identity $servername"\oab (Default Web Site)" -InternalUrl $internalurl/oab -ExternalUrl $externalurl/oab
                 Set-ActiveSyncVirtualDirectory -Identity $servername"\Microsoft-Server-ActiveSync (Default Web Site)" -InternalURL $internalurl/Microsoft-Server-Activesync -ExternalURL $externalurl/Microsoft-Server-Activesync 
                 Set-ECPVirtualDirectory –Identity $servername"\ecp (default web site)" -InternalURL $internalurl/ECP -ExternalURL $externalurl/ECP
                 Set-WebServicesVirtualDirectory -Identity $servername"\EWS (Default Web Site)" -ExternalUrl $externalurl"/ews/exchange.asmx" -InternalUrl $internalurl"/ews/exchange.asmx" ;start-Sleep -Seconds $startsleep
                 }
                7{                
                 # Get Virtual Directory's
                 Get-OABVirtualDirectory | fl Identity, internalUrl, ExternalUrl 
                 Get-ActiveSyncVirtualDirectory | fl  Identity, InternalUrl, ExternalUrl 
                 Get-ECPVirtualDirectory  | fl Identity, InternalUrl, ExternalUrl 
                 Get-WebServicesVirtualDirectory | fl Identity, InternalUrl, ExternalUrl
                 Get-ClientAccessServer | fl Identity,AutoDiscoverServiceInternalUri ;start-Sleep -Seconds $startsleep
                 }
                8{
                 # Disable Form Based Authentication & Enable Basic & Windows Authenticatie 
                 $servername = Read-Host 'What is the Server Name?'
                 Set-OwaVirtualDirectory -Identity $servername"\OWA (default Web site)" -FormsAuthentication $false
                 Set-OwaVirtualDirectory -Identity $servername"\OWA (default Web site)" -BasicAuthentication $true -WindowsAuthentication $true
                 Set-WebServicesVirtualDirectory -Identity $servername"\EWS (Default Web Site)” -WindowsAuthentication $true -BasicAuthentication $true
                 Set-EcpVirtualdirectory –Identity $servername"\ECP (default web site)” -BasicAuthentication $true -WindowsAuthentication $true -FormsAuthentication $false
                 Set-OabVirtualDirectory -Identity $servername"\oab (Default Web Site)” -WindowsAuthentication $true -BasicAuthentication $true
                 Set-ActiveSyncVirtualDirectory -Identity $servername"\Microsoft-Server-ActiveSync (Default Web Site)” -BasicAuthEnabled $true
                 Set-OutlookAnywhere -Identity $servername"\rpc (Default Web Site)" -IISAuthenticationMethods NTLM ;start-Sleep -Seconds $startsleep
                 }
                9{                
                 # Set Postmaster Address
                 $postmaster = Read-Host 'What is the PostMaster Address?'
                 Set-TransportConfig –ExternalPostmasterAddress $postmaster ;start-Sleep -Seconds $startsleep
                 }
                10{                
                 # Block Outlook Versions till Outlook 2007
                 $servername = Read-Host 'What is the Server name?'
                 Set-RpcClientAccess -Server $servername -BlockedClientVersions "0.0.0-5.6535.6535;7.0.0;8.02.4-11.6535.6535" ;start-Sleep -Seconds $startsleep
                 }
                11{                
                 # New MailboxDatabase
                 $server = Read-Host 'What is the Server Name?'
                 $mailstore = Read-Host 'What is de name for the MailBox Database?'
                 $edppath = Read-Host 'What is the path van de EDB ?'
                 $logpath = Read-Host 'What is the path for the LOG Files?'
                 New-MailboxDatabase -Server $server -Name $mailstore -EdbFilePath $edbpath -LogFolderPath $logpath ;start-Sleep -Seconds $startsleep
                 }
                12{
                 # Get-Mailboxdatabase
                 Get-MailboxDatabase
                 }
                13{
                 # Set Mailbox Database Quota
                 $mailboxdatabase= Read-Host 'What is the MailboxDatabase name?'
                 $IssueWarningQuota= Read-Host 'What is the IssueWarningQuota ?'
                 $ProhibitSendQuota= Read-Host 'What is the ProhibitSendQuota ?'
                 $ProhibitSendReceiveQuota= Read-Host 'What is the ProhibitSendReceiveQuota ?'
                 Set-Mailboxdatabase -Identity $mailboxdatabase  -IssueWarningQuota $IssueWarningQuota -ProhibitSendQuota $ProhibitSendQuota -ProhibitSendReceiveQuota $ProhibitSendReceiveQuota ;start-Sleep -Seconds $startsleep
                 }
                14{               
                 # Set DeletedItemRetentionDeletedItemRetention
                 write-host = "DeletedItemRetention must like 14.00:00:00"
                 $mailboxdatabase= Read-Host 'What is the MailboxDatabase name?'
                 $DeletedItemRetention= Read-Host 'What is the DeletedItemRetention ?'
                 Set-Mailboxdatabase -Identity $mailboxdatabase  -DeletedItemRetention $DeletedItemRetention ;start-Sleep -Seconds $startsleep
                 }
                15{
                 #Move Arbitration Mailbox
                 $mailboxdatabase1= Read-Host 'What is the Mailbox Database name where the Arbitration Mailbox Are?'
                 $mailboxdatabase2= Read-Host 'What is the Target Mailbox Database name where the Arbitration Mailbox are moving to?'
                 Get-Mailbox -Database $mailboxdatabase1 -Arbitration | New-MoveRequest -TargetDatabase $mailboxdatabase2 ;start-Sleep -Seconds $startsleep
                 }
                16{
                 # Configure Outlook AnyWhere
                 $internalurl = Read-Host 'What is the Internal URL?'
                 $externalurl = Read-Host 'What is the External URL?'
                 $domain = Read-Host 'What is the FQDN like *.wardvissers.nl ?'
                 Get-OutlookAnywhere | Set-OutlookAnywhere -ExternalHostname $externalurl -InternalHostname $internalurl -ExternalClientsRequireSsl $true -InternalClientsRequireSsl $true -DefaultAuthenticationMethod NTLM ;start-Sleep -Seconds $startsleep 
                 Set-OutlookProvider -Identity EXPR -CertPrincipalName msstd:$domain
                 Set-OutlookProvider -Identity EXCH -CertPrincipalName msstd:$domain
                 }
                17{
                 #Get SafetyNetHoldTime
                 Get-TransportConfig | Select SafetyNetHoldTime ;start-Sleep -Seconds $startsleep
                 }
                18{
                 #Set SafetyNetHoldTime
                 $safety = Read-Host 'What is the Safety Net Hold Time?'
                 Set-TransportConfig -SafetyNetHoldTime $safety ;start-Sleep -Seconds $startsleep
                 }
                 default { Write-Host "`n`tYou Selected Option 19 Go to Main Menu`n" -Fore Yellow; break}
			}
		}
		3 {
			while ( $xMenu2 -lt 1 -or $xMenu2 -gt 5 ){
				CLS
				# Present the Menu Options
				Write-Host "`n`tSpecial Mailboxes" -Fore Magenta
				Write-Host "`t`tPlease select the administration task you require`n" -Fore Cyan
                Write-Host "`t`t`t1. Arbitration Mailboxes"  -Fore Cyan
                Write-Host "`t`t`t2. Archive Mailboxes"  -Fore Cyan
                Write-Host "`t`t`t3. PublicFolder Mailboxes"  -Fore Cyan
                Write-Host "`t`t`t4. Auditlog Mailboxen"  -Fore Cyan
				Write-Host "`t`t`t5. Go to Main Menu`n" -Fore Cyan
				[int]$xMenu2 = Read-Host "`t`tEnter Menu Option Number"
				if( $xMenu2 -lt 1 -or $xMenu2 -gt 5 ){
					Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
				}
			}
			Switch ($xMenu2){
				1{
                 # Arbitration
                 $databasename = Read-Host 'What is the Database Name?'
                 Get-Mailbox –Database $databasename -Arbitration;start-Sleep -Seconds $startsleep
                 }
                2{
                 # Archive
                 $databasename = Read-Host 'What is the Database Name?'
                 Get-Mailbox –Database $databasename –Archive;start-Sleep -Seconds $startsleep
                 }
                3{
                 # PublicFolder
                 $databasename = Read-Host 'What is the Database Name?'
                 Get-Mailbox –Database $databasename –PublicFolder;start-Sleep -Seconds $startsleep
                 }
                4{
                 # Auditlog
                 $databasename = Read-Host 'What is the Database Name?'
                 Get-Mailbox –Database $databasename –AuditLog;start-Sleep -Seconds $startsleep
                 }
                 default { Write-Host "`n`tYou Selected Option 4 Go to Main Menu`n" -Fore Yellow; break}
			}
		}
        4 {
			while ( $xMenu2 -lt 1 -or $xMenu2 -gt 11 ){
				CLS
				# Present the Menu Options
				Write-Host "`n`tCreate & Configure DAG" -Fore Magenta
				Write-Host "`t`tPlease select the administration task you require`n" -Fore Cyan
				Write-Host "`t`t`t1. Create DAG (Server 2012 R2 Only)" -Fore Cyan
				Write-Host "`t`t`t2. Add Mailbox Server to DAG" -Fore Cyan
				Write-Host "`t`t`t3. Add Mailbox Database Copy on DAG Mailbox Member"  -Fore Cyan
				Write-Host "`t`t`t4. Check DatacenterActivationMode"  -Fore Cyan
				Write-Host "`t`t`t5. Enable DatacenterActivationMode DagOnly" -Fore Cyan
				Write-Host "`t`t`t6. Get-DatabaseAvailabilityGroupNetwork" -Fore Cyan
				Write-Host "`t`t`t7. Set-DatabaseAvailabilityGroupNetwork on Manual" -Fore Cyan
				Write-Host "`t`t`t8. Add Static Route" -Fore Cyan
				Write-Host "`t`t`t9. Disable Replation Network on DAG" -Fore Cyan
				Write-Host "`t`t`t10. Database Copies Per Volume (AutoReseed)" -Fore Cyan
				Write-Host "`t`t`t11. Go to Main Menu`n" -Fore Cyan
				[int]$xMenu2 = Read-Host "`t`tEnter Menu Option Number"
				if( $xMenu2 -lt 1 -or $xMenu2 -gt 11 ){
					Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
				}
			}
			Switch ($xMenu2){
				1{
                 # New DAG Server 2012 R2 
                 $dag = Read-Host 'What is the DAG Name?'
                 $witnessserver= Read-Host 'What is the Witness Server Name?'
                 $witnessdir= Read-Host 'What is the Witness Dir?'
                 New-DatabaseAvailabilityGroup –Name $dag –WitnessServer $witnessserver -WitnessDirectory $witnessdir –DatabaseAvailabilityGroupIpAddresses ([System.Net.IPAddress]::None) ;start-Sleep -Seconds $startsleep
                 }
                2{
                 # Add Dag Server
                 $dag = Read-Host 'What is the DAG Name?'
                 $server = Read-Host 'What is the Mailbox Server Name?'
                 Add-DatabaseAvailabilityGroupServer –Identity $dag –MailboxServer $server ;start-Sleep -Seconds $startsleep
                 }
                3{
                 # Add MailboxDatabase Copy
                 $server = Read-Host 'What is the Server Name?'
                 $mailstore = Read-Host 'What is de name for the MailBox Database?'
                 Add-MailboxDatabaseCopy -Identity $mailstore -MailboxServer $server ;start-Sleep -Seconds $startsleep
                 }
                4{
                 # Get Dag Mode
                 Get-DatabaseAvailabilityGroup | Select Name,*mode* ;start-Sleep -Seconds $startsleep
                 }
                5{
                 # Enable DAC
                 $dag = Read-Host 'What is the DAG Name?'
                 Set-DatabaseAvailabilityGroup –Identity $dag –DatacenterActivationMode DagOnly ;start-Sleep -Seconds $startsleep
                 }
                6{
                 # DatabaseAvailabilityGroupNetwork
                 Get-DatabaseAvailabilityGroupNetwork | select Name,Subnets,Interfaces | fl ;start-Sleep -Seconds $startsleep
                 }
                7{
                 # Dag Network Manual
                 $dag = Read-Host 'What is the DAG Name?'
                 Set-DatabaseAvailabilityGroup –Identity $dag –ManualDagNetworkConfiguration $True ;start-Sleep -Seconds $startsleep
                 }
                8{
                 # Add Route 
                 $destinationprefix = Read-Host 'What is the Destination Prefix?'
                 $nexthop = Read-Host 'What is the NextHop?'
                 New-NetRoute -DestinationPrefix $destinationprefix -InterfaceAlias Replication -NextHop $nexthop ;start-Sleep -Seconds $startsleep
                 }
                9{
                 # Disable Replation Network on DAG
                 $networkname = Read-Host 'What is the DAG Replication Network?'
                 $name = Read-Host 'What is the DAG Replication Network Name?'
                 Set-DatabaseAvailabilityGroupNetwork $networkname –Name $name –ReplicationEnabled:$false –IgnoreNetwork:$true ;start-Sleep -Seconds $startsleep
                 }
                10{
                 # AutoDagDatabaseCopiesPerVolume (AutoReseed)
                 $copies = Read-Host 'What is the Database Copies Per Volume?'
                 Set-DatabaseAvailabilityGroup DAG1 -AutoDagDatabaseCopiesPerVolume $copies ;start-Sleep -Seconds $startsleep
                 }
				default { Write-Host "`n`tYou Selected Option 11 Go to Main Menu`n" -Fore Yellow; break}
			}
		}
        5 {
			while ( $xMenu2 -lt 1 -or $xMenu2 -gt 4 ){
				CLS
				# Present the Menu Options
				Write-Host "`n`tCertificates" -Fore Magenta
				Write-Host "`t`tPlease select the administration task you require`n" -Fore Cyan
				Write-Host "`t`t`t1. Import Certificate" -Fore Cyan
				Write-Host "`t`t`t2. Show All Certifcates" -Fore Cyan
				Write-Host "`t`t`t3. Certificate to Services" -Fore Cyan
				Write-Host "`t`t`t4. Go to Main Menu`n" -Fore Cyan
				[int]$xMenu2 = Read-Host "`t`tEnter Menu Option Number"
				if( $xMenu2 -lt 1 -or $xMenu2 -gt 4 ){
					Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
				}
			}
			Switch ($xMenu2){
				1{
                 $pfxpath = Read-Host 'What is the .PFX path?'
                 $password = Read-Host 'What is the Password from the PFX file?'
                 $servername = Read-Host 'What is de name from the Server?'
                 Import-ExchangeCertificate -Path $pfxpath -Password:$password.password -Server $servername ;start-Sleep -Seconds $startsleep
                 }
                2{
                 # Certificaten
                 Get-ExchangeCertificate | FL ;start-Sleep -Seconds $startsleep
                 }
                3{
                 # Certificaten to Services
                 $servername = Read-Host 'What is the Server name?'
                 $thumbprint = Read-Host 'What is the ThumbPrint name?'
                 Enable-ExchangeCertificate -Server $servername -Thumbprint $thumbprint -Services POP,IMAP,SMTP,IIS ;start-Sleep -Seconds $startsleep
                 }
				default { Write-Host "`n`tYou Selected Option 4 Go to Main Menu`n" -Fore Yellow; break}
			}
		}
        6 {
			while ( $xMenu2 -lt 1 -or $xMenu2 -gt 7 ){
				CLS
				# Present the Menu Options
				Write-Host "`n`tExchange 2016 Best Practise" -Fore Magenta
				Write-Host "`t`tPlease select the administration task you require`n" -Fore Cyan
				Write-Host "`t`t`t1. KB2995145: Check KB2803755 is installed on Windows Server 2012 (NOT Server 2012 R2)" -Fore Cyan
				Write-Host "`t`t`t2. KB2995145: .NET Framework 4.5 garbage collector heap Fix 2008R2/2012/2012R2"-Fore Cyan
				Write-Host "`t`t`t3. Set Minimum Disk Space Warning level (200GB CU5 180GB Default CU6  175GB CU7)"-Fore Cyan
				Write-Host "`t`t`t4. NTFS allocation unit size Check 64k EDB and log file volumes" -Fore Cyan
                Write-Host "`t`t`t5. Check Transaction Log Growth" -Fore Cyan
                Write-Host "`t`t`t6. Set Power Options to High Performance" -Fore Cyan
                Write-Host "`t`t`t7. Go to Main Menu`n" -Fore Cyan
				[int]$xMenu2 = Read-Host "`t`tEnter Menu Option Number"
				if( $xMenu2 -lt 1 -or $xMenu2 -gt 7 ){
					Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
				}
			}
			Switch ($xMenu2){
				1{
                 # KB2803755 on Windows Server 2012 not (Server 2012 R2)
                 $servername = Read-Host 'What is the Server name?'
                 Get-Hotfix KB2803755 -computername $servername ;start-Sleep -Seconds $startsleep
                 }
                2{
                 # Dot.Net Performance Tunning http://support.microsoft.com/kb/2995145
                 [Environment]::SetEnvironmentVariable("COMPLUS_DisableRetStructPinning", "1", "Machine")
                 New-ItemProperty "HKLM:\Software\Microsoft\.NETFramework" -Name "DisableRetStructPinning" -PropertyType DWord -Value 1 ;start-Sleep -Seconds $startsleep
                 } 
                3{
                 # Set Minimum Disk Space Warning Level
                 write-host = "Default 175GB CU7"
                 $diskspace = Read-Host 'What is the Minimum Free Disk Space in MB?'
                 Add-GlobalMonitoringOverride -Item Monitor –Identity MailboxSpace\StorageLogicalDriveSpaceMonitor -PropertyName MonitoringThreshold -PropertyValue $diskspace
                 }
                4{
                 # NTFS allocation unit size Check 64k edb and log file volumes
                 $servername = Read-Host 'What is the Server name?'
                 Get-WmiObject Win32_DiskPartition -ComputerName $servername | select Name, Index, BlockSize, StartingOffset ;start-Sleep -Seconds $startsleep
                 }
                5{
                 # Check Transaction Log Growth
                 $database = Read-Host 'What is de Mailbox Database Name?'
                 . $exscripts\StoreTSLibrary.ps1
                 $offenders = $null
                 $offenders += Get-TopLogGenerators -database $database | sort totallogbytes -descending | select -first 20| select {($_.totallogbytes/1024/1024)}, {$database}, {(get-mailbox $_.mailboxguid.tostring() )}
                 $offenders | Sort-Object -Property '($_.totallogbytes/1024/1024)' -descending
                 }
                6{
                 # Set Power Options to HighPerformance
                 Powercfg.exe /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
                 } 
                 default { Write-Host "`n`tYou Selected Option 6  Go to Main Menu`n" -Fore Yellow; break}
			}
		}
        7 {
			while ( $xMenu2 -lt 1 -or $xMenu2 -gt 3 ){
				CLS
				# Present the Menu Options
				Write-Host "`n`tHyper-V & VMWare Best Practise" -Fore Magenta
				Write-Host "`t`tPlease select the administration task you require`n" -Fore Cyan
				Write-Host "`t`t`t1. Hyper-V Exchange 2016 DAG Cluster Best Practise"-Fore Cyan
                Write-Host "`t`t`t2. VMware Exchange 2016 DAG Cluster Best Practise"-Fore Cyan
				Write-Host "`t`t`t3. Go to Main Menu`n" -Fore Cyan
				[int]$xMenu2 = Read-Host "`t`tEnter Menu Option Number"
				if( $xMenu2 -lt 1 -or $xMenu2 -gt 3 ){
					Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
				}
			}
			Switch ($xMenu2){
				1{
                 # Hyper-V Exchange 2016 DAG Best Practise
                 Import-module FailoverClusters
                 (Get-Cluster).SameSubnetThreshold=10
                 (Get-Cluster).SameSubnetDelay=000 ;start-Sleep -Seconds $startsleep
                 }
                2{
                 # VMWare Exchange 2016 DAG Best Practise
                 Import-module FailoverClusters
                 (Get-Cluster).SameSubnetDelay=2000 ;start-Sleep -Seconds $startsleep
                 }
				default { Write-Host "`n`tYou Selected Option 3 Go to Main Menu`n" -Fore Yellow; break}
			}
		}
        8 {
			while ( $xMenu2 -lt 1 -or $xMenu2 -gt 6 ){
				CLS
				# Present the Menu Options
				Write-Host "`n`tExport Mailbox to PST" -Fore Magenta
				Write-Host "`t`tPlease select the administration task you require`n" -Fore Cyan
				Write-Host "`t`t`t1. Give user import and export role" -Fore Cyan
				Write-Host "`t`t`t2. Mailbox Export to PST" -Fore Cyan
				Write-Host "`t`t`t3. Archive Mailbox export to PST" -Fore Cyan
				Write-Host "`t`t`t4. (Archief) Mailbox Export Request" -Fore Cyan
				Write-Host "`t`t`t5. Remove ALL Mailbox Export Request" -Fore Cyan
				Write-Host "`t`t`t6. Go to Main Menu`n" -Fore Cyan
				[int]$xMenu2 = Read-Host "`t`tEnter Menu Option Number"
				if( $xMenu2 -lt 1 -or $xMenu2 -gt 6 ){
					Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
				}
			}
			Switch ($xMenu2){
				1{
                 # Give user import and export role
                 $Username = Read-Host 'What is the User name dat get the Import & Export Role?'
                 New-ManagementRoleAssignment -Role "Mailbox Import Export" -User $username ;start-Sleep -Seconds $startsleep
                 }
                2{
                 # Mailbox Export to PST
                 $username = Read-Host 'What is the User name which the mailbox must be exported?'
                 $path = Read-Host 'Give the UNC path where the .pst will be saved (Must be on a Share)'
                 New-MailboxExportRequest -Mailbox $username -FilePath $path ;start-Sleep -Seconds $startsleep
                 }
                3{
                 # Archive Mailbox Export to PST
                 $username = Read-Host 'What is the User name which the archive mailbox must be exported?'
                 $path = Read-Host 'Give the UNC path where the .pst will be saved (Must be on a Share)'
                 New-MailboxExportRequest -Mailbox $username -FilePath $path -IsArchive ;start-Sleep -Seconds $startsleep
                 }
                4{
                 # Status Mailbox Export Request
                 Get-MailboxExportRequest ;start-Sleep -Seconds $startsleep
                 }
                5{
                 # Remove ALL Mailbox Export Request
                 Get-MailboxExportRequest -Status Completed | Remove-MailboxExportRequest ;start-Sleep -Seconds $startsleep
                 }
				default { Write-Host "`n`tYou Selected Option 6 Go to Main Menu`n" -Fore Yellow; break}
			}
		}
        9 {
			while ( $xMenu2 -lt 1 -or $xMenu2 -gt 2 ){
				CLS
				# Present the Menu Options
				Write-Host "`n`tExchange 2007/Exchange 2010 Migratie" -Fore Magenta
				Write-Host "`t`tPlease select the administration task you require`n" -Fore Cyan
				Write-Host "`t`t`t1. KB2990117: Check if KB2545850 installed Windows 2008 R2x" -Fore Cyan
				Write-Host "`t`t`t2. Go to Main Menu`n" -Fore Cyan
				[int]$xMenu2 = Read-Host "`t`tEnter Menu Option Number"
				if( $xMenu2 -lt 1 -or $xMenu2 -gt 2 ){
					Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
				}
			}
			Switch ($xMenu2){
				1{ 
                 # KB2990117: Check if KB2545850 installed Windows 2008 R2
                 $servername = Read-Host 'What is the Server name?'
                 Get-Hotfix KB2545850 -computername $servername ;start-Sleep -Seconds $startsleep
                 }
				default { Write-Host "`n`tYou Selected Option 2 Go to Main Menu`n" -Fore Yellow; break}
			}
		}
        10 {
			while ( $xMenu2 -lt 1 -or $xMenu2 -gt 3 ){
				CLS
				# Present the Menu Options
				Write-Host "`n`tExchange Edge Subscription" -Fore Magenta
				Write-Host "`t`tPlease select the administration task you require`n" -Fore Cyan
				Write-Host "`t`t`t1. New EdgeSubscription (Edge Server)" -Fore Cyan
				Write-Host "`t`t`t2. New EdgeSubscription (Mailbox Server)" -Fore Cyan
				Write-Host "`t`t`t3. Go to Main Menu`n" -Fore Cyan
				[int]$xMenu2 = Read-Host "`t`tEnter Menu Option Number"
				if( $xMenu2 -lt 1 -or $xMenu2 -gt 3 ){
					Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
				}
			}
			Switch ($xMenu2){
				1{
                 #
                 $edge = Read-Host 'Give the location the location to save the xml file?'
                 New-EdgeSubscription -FileName $edge ;start-Sleep -Seconds $startsleep
                 }
                2{
                 # 
                 $edge = Read-Host 'Give the location of the xml file?'
                 $site = Read-Host 'What is the Site name?'
                 New-EdgeSubscription -FileData ([byte[]]$(Get-Content -Path $edge -Encoding Byte -ReadCount 0)) -Site $site ;start-Sleep -Seconds $startsleep
                 }
				default { Write-Host "`n`tYou Selected Option 3 Go to Main Menu`n" -Fore Yellow; break}
			}
		}
        11 {
			while ( $xMenu2 -lt 1 -or $xMenu2 -gt 3){
				CLS
				# Present the Menu Options
				Write-Host "`n`tFixes" -Fore Magenta
				Write-Host "`t`tPlease select the administration task you require`n" -Fore Cyan
                Write-Host "`t`t`t1. Eventid:  106 Error"  -Fore Cyan
                Write-Host "`t`t`t2. Eventid: 3018 Error"  -Fore Cyan
				Write-Host "`t`t`t3. Go to Main Menu`n" -Fore Cyan
				[int]$xMenu2 = Read-Host "`t`tEnter Menu Option Number"
				if( $xMenu2 -lt 1 -or $xMenu2 -gt 3 ){
					Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
				}
			}
			Switch ($xMenu2){
				1{
                # Eventid 106
                Add-PsSnapin Microsoft.Exchange.Management.PowerShell.Setup
                $files = Get-ChildItem $exinstall\setup\perf\*.xml
                Write-Host "Registering the perfmon counters"
                Write-Host 
                $count = 0; 
                foreach ($i in $files)
                  {
                   $count++ 
                   $f =  $i.directory, "\", $i.name -join ""
                   Write-Host $count $f -BackgroundColor red
                   New-PerfCounters -DefinitionFileName $f
                  }
                 }
                2{
                 # Eventid 3018 meldingen
                 $servername = Read-Host 'What is the Servername?'
                 $proxyserver = Read-Host 'What is the Proxy Server? http://192.168.150.233 '
                 Set-ExchangeServer $servername -InternetWebProxy $proxyserver
                 }
               default { Write-Host "`n`tYou Selected Option 4 Go to Main Menu`n" -Fore Yellow; break}
			}
		}
        12 {
			while ( $xMenu2 -lt 1 -or $xMenu2 -gt 3 ){
				CLS
				# Present the Menu Options
				Write-Host "`n`tMountpoint" -Fore Magenta
				Write-Host "`t`tPlease select the administration task you require`n" -Fore Cyan
                Write-Host "`t`t`t1. Diskspace Mountpoints"  -Fore Cyan
                Write-Host "`t`t`t2. Create Mountpoints"  -Fore Cyan
               	Write-Host "`t`t`t3. Go to Main Menu`n" -Fore Cyan
				[int]$xMenu2 = Read-Host "`t`tEnter Menu Option Number"
				if( $xMenu2 -lt 1 -or $xMenu2 -gt 3 ){
					Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
				}
			}
		 Switch ($xMenu2){
				1{
                 $servername = Read-Host 'What is the Servername?'
                 $TotalGB = @{Name="Capacity(GB)";expression={[math]::round(($_.Capacity/ 1073741824),2)}}
                 $FreeGB = @{Name="FreeSpace(GB)";expression={[math]::round(($_.FreeSpace / 1073741824),2)}}
                 $FreePerc = @{Name="Free(%)";expression={[math]::round(((($_.FreeSpace / 1073741824)/($_.Capacity / 1073741824)) * 100),0)}}

                 function get-mountpoints {
                 $volumes = Get-WmiObject -computer $servername win32_volume | Where-object {$_.DriveLetter -eq $null}
                 $volumes | Select SystemName, Label, $TotalGB, $FreeGB, $FreePerc | Format-Table -AutoSize
                  }
                 get-mountpoints
                 start-Sleep -Seconds 15
                 }
                2{
                 # Create Mountpoints
                 $mountpoints = Read-Host 'How many mountpoints Min 2?'
                 For ($i=1; $i -le $mountpoints; $i++) {New-Item C:\ExDb\MDB$i –ItemType Directory}
                 For ($i=2; $i -le $mountpoints; $i++) {
                  Get-Disk –Number $i | Initialize-Disk –PartitionStyle GPT
                  $MDBCounter = $i-1
                  $MDB = "MDB$MDBCounter"
                  New-Partition –DiskNumber $i –UseMaximumSize
                  Add-PartitionAccessPath -DiskNumber $i -PartitionNumber 2 –AccessPath "C:\ExDb\$MDB"
                  Get-Partition –Disknumber $i –PartitionNumber 2 | Format-Volume –FileSystem NTFS –NewFileSystemLabel $MDB -AllocationUnitSize 65536 –Confirm:$false
                  }cl
                  start-Sleep -Seconds 15
                 }
               	default { Write-Host "`n`tYou Selected Option 4 Go to Main Menu`n" -Fore Yellow; break}
			   }
            }
            13 {
			while ( $xMenu2 -lt 1 -or $xMenu2 -gt 4 ){
				CLS
				# Present the Menu Options
				Write-Host "`n`tMaintaince" -Fore Magenta
				Write-Host "`t`tPlease select the administration task you require`n" -Fore Cyan
                Write-Host "`t`t`t1. Start Maintaince"  -Fore Cyan
                Write-Host "`t`t`t2. Check Maintaince"  -Fore Cyan
                Write-Host "`t`t`t3. Stop Maintaince"  -Fore Cyan
               	Write-Host "`t`t`t4. Go to Main Menu`n" -Fore Cyan
				[int]$xMenu2 = Read-Host "`t`tEnter Menu Option Number"
				if( $xMenu2 -lt 1 -or $xMenu2 -gt 4 ){
					Write-Host "`tPlease select one of the options available.`n" -Fore Red;start-Sleep -Seconds 1
				}
			}
		 Switch ($xMenu2){
				1{
                 # Start Maintaince
                 $server1= Read-Host 'What is the Server name to Start Maintaince Mode?'
                 $server2= Read-Host 'What is the Server name who is is Online?'
                 $domain= Read-Host 'What is the Domain Name?'
                 Set-ServerComponentState $server1 -Component HubTransport -State Draining -Requester Maintenance
                 Restart-Service MSExchangeTransport
                 Restart-Service MSExchangeFrontEndTransport
                 Redirect-Message -Server $server1- Target $server2.$domain
                 Suspend-ClusterNode $server1
                 Set-MailboxServer $server1 -DatabaseCopyActivationDisabledAndMoveNow $True
                 Get-MailboxServer $server1 | Select DatabaseCopyAutoActivationPolicy
                 Set-MailboxServer $server1 -DatabaseCopyAutoActivationPolicy Blocked
                 Set-ServerComponentState $server1 -Component ServerWideOffline -State Inactive -Requester Maintenance                 
                 start-Sleep -Seconds 15
                 }
                2{
                 # Check Maintaince
                 $server1= Read-Host 'What is the Server name to check Maintaince Mode?'
                 Get-ServerComponentState $server1 | ft Component,State –Autosize
                 start-Sleep -Seconds 15
                 }
                3{
                 # Stop Maintaince
                 $server1= Read-Host 'What is the Server name to Stop Maintaince Mode?'
                 Set-ServerComponentState $server1 -Component ServerWideOffline -State Active -Requester Maintenance
                 Resume-ClusterNode $server1 
                 Set-MailboxServer $server1 -DatabaseCopyActivationDisabledAndMoveNow $False
                 Set-MailboxServer $server1 -DatabaseCopyAutoActivationPolicy Unrestricted
                 Set-ServerComponentState $server1 -Component HubTransport -State Active -Requester Maintenance
                 Restart-Service MSExchangeTransport
                 Restart-Service MSExchangeFrontEndTransport
                 start-Sleep -Seconds 15
                 }
               	default { Write-Host "`n`tYou Selected Option 4 Go to Main Menu`n" -Fore Yellow; break}
			}
		}
		default { $global:xExitSession=$true;break }
	}
}
LoadMenuSystem
If ($xExitSession){
	exit-pssession    #â€¦ User quit & Exit
}
else{
	.\Configure-Exchange2016.ps1
}