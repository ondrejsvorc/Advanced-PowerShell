# Ziskani hesla z textoveho souboru
$adminName = Get-Content "G:\username.txt" | ConvertTo-SecureString
$adminPassword = Get-Content "G:\password.txt" | ConvertTo-SecureString

# Vytvoreni Credential objektu
$adminCredential = New-Object System.Management.Automation.PsCredential -ArgumentList $adminName, $adminPassword