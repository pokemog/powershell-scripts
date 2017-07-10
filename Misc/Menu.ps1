$title = "Delete Files"
$message = "Do you want to delete the remaining files in the folder?"

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
    "Deletes all the files in the folder."

$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
    "Retains all the files in the folder."

$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

$result = $host.ui.PromptForChoice($title, $message, $options, 0) 

switch ($result){
    0 {"You selected Yes."}
    1 {"You selected No."}
}