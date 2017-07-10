for ($i=1; $i -le 100; $i++)
{
    New-Mailbox -Database "MDB01" -Name "ExchangeRoom$i" -DisplayName "Exchange Room$i" -Room
}


Get-MailBox | Where {$_.ResourceType -eq "Room"} | Set-CalendarProcessing -AutomateProcessing:AutoAccept