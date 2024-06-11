[string] $ipAddress = "192.168.0.11"
[string] $maskAddress = "255.255.255.0"
[string] $dnsAddress = "192.168.0.1"

[string] $domainName = "firma.local"
[string] $pcPath = "OU=u1,OU=pocitace,OU=jicin,DC=firma,DC=local" 

$administrator = "FIRMA\Administrator"
$password = ConvertTo-SecureString "Aa123456" -AsPlainText -Force

$adminCredential = New-Object System.Management.Automation.PsCredential ($administrator, $password)

New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress $ipAddress -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $dnsAddress

Rename-Computer -NewName "PC1"
sleep 5
Add-Computer -DomainName $domainName -Force –Options JoinWithNewName,accountcreate -Credential $adminCredential -Restart