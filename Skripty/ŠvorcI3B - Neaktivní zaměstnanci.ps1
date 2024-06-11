# Účty bývalých zaměstnanců rušíme zpravidla po 2 měsících neaktivity. 
# Pro statistické účely si chceme seznam neaktivních uživatelů uložit jako CSV.

[string] $ouEmployees = "OU=zamestnanci,OU=uzivatele,DC=firma,DC=local"
[string] $exportPath = "E:\zamestnanci.csv"
$date = (Get-Date).AddMonths(-2)

Get-ADUser -Filter { ((Enabled -eq $true) -and (LastLogonDate -lt $date)) } -SearchBase $ouEmployees -Properties LastLogonDate | 
Select-Object samaccountname, LastLogonDate | 
Sort-Object LastLogonDate | 
Export-CSV $exportPath -NoTypeInformation -Encoding UTF8