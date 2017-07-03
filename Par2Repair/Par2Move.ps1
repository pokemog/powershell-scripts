$a = Get-Content Par2RepairUnable.txt
mkdir temp

foreach($file in $a){
    if($file -match 'vol\d+\+\d+'){
        $b = [System.IO.Path]::GetFileNameWithoutExtension([System.IO.Path]::GetFileNameWithoutExtension($file))
        Move-Item "$b*" temp
    }
    else{
        $b = [System.IO.Path]::GetFileNameWithoutExtension($file)
        Move-Item "$b*" temp
    }
    Write-Output $b >> Par2Move.txt
    
}