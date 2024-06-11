# Ziskani hesla z textoveho souboru
$adminName = Get-Content "E:\username.txt" | ConvertTo-SecureString
$adminPassword = Get-Content "E:\password.txt" | ConvertTo-SecureString

# Vytvoreni Credential objektu
$adminCredential = New-Object System.Management.Automation.PsCredential -ArgumentList $adminName, $adminPassword