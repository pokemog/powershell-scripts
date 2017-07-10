$timer = New-Object System.Timers.Timer

$action = {Write-Host "Timer Elapse Event: $(get-date -Format ‘HH:mm:ss’)"}  

$timer.Interval = 3000 #3 seconds  
 
Register-ObjectEvent -InputObject $timer -EventName elapsed –SourceIdentifier thetimer -Action $action 

$timer.start() 

#to stop run 
#$timer.stop() 
#cleanup 
#Unregister-Event thetimer
