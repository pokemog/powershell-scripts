# Exchange Power Shell Commands for Rooms

# Create and Manage Room Mailboxes
# https://technet.microsoft.com/en-us/library/jj215781(v=exchg.160).aspx
	
	#This example creates a room mailbox with the following configuration:
	#	* The room mailbox resides on Mailbox Database 1.
	#	* The mailbox's name is ConfRoom1. This name will also be used to create the room’s email address.
	#	* The display name in the Exchange Admin Center and the address book will be Conference Room 1.
	#	* The Room switch specifies that this mailbox will be created as a room mailbox.
	New-Mailbox -Database "Mailbox Database 1" -Name ConfRoom1 - -DisplayName "Conference Room 1" -Room
			
	#This example creates a room list for building 32.
	New-DistributionGroup -Name "Building 32 Conference Rooms" -OrganizationalUnit "contoso.com/rooms" -RoomList
		
	#This example adds confroom3223 to the building 32 room list.
	Add-DistributionGroupMember -Identity "Building 32 Conference Rooms" -Member confroom3223@contoso.com
		
	#This example converts the distribution group, building 34 conference rooms, to a room list.
	Set-DistributionGroup -Identity "Building 34 Conference Rooms" -RoomList
		
	
# Exchange Calendar Permissions
# https://proximagr.wordpress.com/2014/10/07/exchange-calendar-permissions-using-powershell/
	
	# To check current permissions
	Get-MailboxFolderPermission -Identity "user@mydomain.com":\calendar
 
	# To add calendar permissions, permission can be Editor,Reviewer,Author etc
	Add-MailboxFolderPermission -Identity "user@mydomain.com":\calendar -User "manager@mydomain" -AccessRights Editor
 
	# To change the calendar permission of an existing access (thi swill change the access to Author
	Set-MailboxFolderPermission -Identity "user@mydomain.com":\calendar -User "manager@mydomain" -AccessRights Author
 
	# To remove calendar permissions
	Remove-MailboxFolderPermission -Identity "user@mydomain.com":\calendar -User "manager@mydomain"
	
# Share a Mailbox Using Folder Permissions
# For each user you add to the Permissions dialog box, you must specify an access level. You can choose from the following permission levels using the Permission Level drop-down list.

# Owner – The user has all permissions on the folder and the items within the folder.  The user can edit all items in the folder, including items the user didn’t create.  The user can also delete all items within the folder.
# Publishing Editor – The user has full permissions to create, edit, and delete items in the folder, and can create subfolders, but does not own the folder.
# Editor – Users can create, edit, and delete items within the folder, but cannot create subfolders.
# Publishing Author – Users can create new items, and edit and delete their own items.  They cannot edit or delete items created by others; however, they can create subfolders.
# Author – An author can do everything a Publishing Author can do except create subfolders.
# Non editing Author – Users can create new items and delete their own items.  They cannot edit their own items, delete other’s items, or create subfolders.
# Reviewer – Users can view items, but they cannot view, modify, or delete existing items.  They cannot create new items.
# None – The folder is visible to other users, but they cannot view, modify, or delete existing items.  They cannot create new items.


# Manage Exchange mailbox
# http://exchangeserverpro.com/show-full-freebusy-exchange-2010-room-resource-mailboxes/

	#You can modify all the default permissions on Room mailboxes with the following commands in the Exchange Management Shell.
	$rooms = Get-Mailbox -RecipientTypeDetails RoomMailbox
	$rooms | %{Set-MailboxFolderPermission $_":\Calendar" -User Default -AccessRights Reviewer}

# Need to set Room's Calendar's mailbox's to show subject instead of organizer's name
# https://support.microsoft.com/en-us/kb/2842288
	
# To resolve this issue, follow these steps:
# 	Open the Exchange Management Shell.
# 	Run the one of following cmdlets:
# 
# 	For Exchange Server 2016, Exchange Server 2013 or Exchange Server 2010

		Set-CalendarProcessing -Identity <RESOURCEMAILBOX> -DeleteSubject $False -AddOrganizerToSubject $False

#	For Exchange Server 2007

		Set-MailboxCalendarSettings -Identity <RESOURCEMAILBOX> -AutomateProcessing AutoAccept -AddOrganizerToSubject $False -DeleteSubject $False

# Ex.
[PS] C:\Windows\system32>for($i=1; $i -le 10; $i++){
>> Set-CalendarProcessing -Identity pm$i -DeleteSubject $False -AddOrganizerToSubject $False }
>>
[PS] C:\Windows\system32>for($i=1; $i -le 7; $i++){
>> Set-CalendarProcessing -Identity confRoom$i -DeleteSubject $False -AddOrganizerToSubject $False }
>>


# Setting Impersonation for Exchange 2013/2016/Online
# http://documents.software.dell.com/messagestats/7.1/messagestats-business-insights-deployment-guide/appendix-aconfiguring-impersonation/setting-impersonation-forexchange-2013

# https://msdn.microsoft.com/en-us/library/office/dn722376(v=exchg.150).aspx
# Command to run for Exchange Administrator:

	New-ManagementRoleAssignment –name:impersonationAssignmentName –Role:ApplicationImpersonation –User:serviceAccount 
	# Ex:
	New-ManagementRoleAssignment -Name:MyImpersonationAccount -Role:ApplicationImpersonation User:myaccount@email.com