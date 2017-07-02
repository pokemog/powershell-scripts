Get-ChildItem -Name *.par2 > par2.txt
$par2files = Get-Content par2.txt
$par2unique = ""

# find only one unique par2 file per each par2 volume set
foreach($par2file in $par2files)
{
    $file = [IO.PATH]::GetFileNameWithoutExtension($par2file)
    $file = $file -replace "\.(vol)\d+\+\d+", ""

    if("$par2unique" -notmatch [regex]::Escape($file))
    {
        $par2unique += $file
        Add-Content par2unique.txt $par2file
    }
}

$par2files = Get-Content par2unique.txt

# verifies and repair each par2 volume set
foreach($par2file in $par2files)
{
    par2j64.exe repair $par2file

    if($LASTEXITCODE -eq 132){$par2file >> Par2RepairNeeded.txt}
    if($LASTEXITCODE -eq 1){"$par2file bad par2 file" >> Par2RepairUnable.txt}
    if($LASTEXITCODE -eq 12){"$par2file not enough repair blocks" >> Par2RepairUnable.txt}
    if($LASTEXITCODE -eq 268){"$par2file par2 error and not enough repair blocks" >> Par2RepairUnable.txt}
    if($LASTEXITCODE -eq 0){$par2file >> Par2Repaired.txt}
    if($LASTEXITCODE -eq 16){$par2file >> Par2Repaired.txt}
    if($LASTEXITCODE -eq 272){$par2file >> Par2Repaired.txt}
    if($LASTEXITCODE -eq 256){$par2file >> Par2RepairNotNeeded.txt}
}