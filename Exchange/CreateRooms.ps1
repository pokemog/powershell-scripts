# Add Impersonation for GVE Exchange service account
# New-ManagementRoleAssignment –Name:impersonationAssignmentName –Role:ApplicationImpersonation –User:serviceAccount 
New-ManagementRoleAssignment -Name:GVERoomsImpersonation -Role:ApplicationImpersonation -User:GveUser@gve-eng16.com

# Create rooms
for ($i = 1; $i -le 100; $i++) {
    New-Mailbox -Name "ExchangeRoom$i" -DisplayName "Exchange Room $i" -Room
}

# Create a Distribution Group for rooms
# New-DistributionGroup -Name "Building 32 Conference Rooms" -OrganizationalUnit "contoso.com/rooms" -RoomList
New-DistributionGroup -Name "Building 1 Conference Rooms" -RoomList

# Adding Rooms to a Distribution Group
# Single room
Add-DistributionGroupMember -Identity "Building 32 Conference Rooms" -Member confroom3223@contoso.com

# Adding All rooms to a Distribution Group
Get-Mailbox | Where-Object {$_.ResourceType -eq "Room"} | Add-DistributionGroupMember -Identity "Building 1 Conference Rooms"

# Set Calendar-Processing for all rooms to auto accept if available and to not delete Subject, Organizer and Body
Get-MailBox | Where-Object {$_.ResourceType -eq "Room"} | Set-CalendarProcessing -AutomateProcessing:AutoAccept -DeleteSubject $False -AddOrganizerToSubject $False -DeleteComment $False

# Set reviewer access to a user for one rooms
Get-Mailbox | Where-Object {$_.ResourceType -eq "Room"} | Add-MailboxFolderPermission -Identity ConfRoom1@extrondev.com:\calendar -User gveuser@extrondev.com -AccessRights Reviewer

# Set reviewer access to a user for all rooms
$mailboxes = Get-Mailbox | Where-Object {$_.ResourceType -eq "Room"}

$mailboxes | ForEach-Object {
    $user = $_.Alias
    $path = $user + ”:\Calendar”
    Add-MailboxFolderPermission –Identity $path -User gveuser@gve-eng16.com -AccessRights Reviewer
}
