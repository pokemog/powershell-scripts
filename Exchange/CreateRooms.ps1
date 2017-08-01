# Create rooms
for ($i = 1; $i -le 100; $i++) {
    New-Mailbox -Name "ExchangeRoom$i" -DisplayName "Exchange Room $i" -Room
}

# Set Calendar-Processing for all rooms to auto accept if available and to not delete Subject, Organizer and Body
Get-MailBox | Where-Object {$_.ResourceType -eq "Room"} | Set-CalendarProcessing -AutomateProcessing:AutoAccept -DeleteSubject $False -AddOrganizerToSubject $False -DeleteComment $False

# Set reviewer access to a user for all rooms
Get-Mailbox | Where-Object {$_.ResourceType -eq "Room"} | Add-MailboxFolderPermission -Identity ConfRoom1@extrondev.com:\calendar -User gveuser@extrondev.com -AccessRights Reviewer

$mailboxes = Get-Mailbox | Where-Object {$_.ResourceType -eq "Room"}

$mailboxes | ForEach-Object {
    $user = $_.Alias
    $path = $user + ”:\Calendar”
    Add-MailboxFolderPermission –Identity $path -User gveeng@extrondev.com -AccessRights Reviewer
}
