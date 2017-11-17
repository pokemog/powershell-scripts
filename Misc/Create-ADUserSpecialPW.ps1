$Password = @(
    '~', '`', '!', '@', '#', '$', '%', '^',
    '&', '*', '(', ')', '-', '_', '=', '+',
    '\', '|', ']', '}', '[', '{', ';', ':',
    '/', '?', '.', '>', '<', ',', 'a', '1'
)

for ($i = 1; $i -le $Password.Count; $i++) {
    $OFS = ''
    $first, $rest = $Password
    $Password = $rest + $first
    $PasswordString = [String]$Password
    $PasswordString
    $PasswordSecureString = ConvertTo-SecureString -string $PasswordString -AsPlainText -force
    New-ADUser -Name "GVE User $i" -SamAccountName "gve$i" -GivenName 'gve' -Surname "$i" -DisplayName "GVE $i" -Path "OU=Eng,OU=Building 3,DC=gve-eng,DC=com" -Enabled $True -AccountPassword $PasswordSecureString
}