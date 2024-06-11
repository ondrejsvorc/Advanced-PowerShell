# V počítačové učebně U1 se nachází 20 počítačů. 
# Potřebujeme se ujistit, že jsou po 17. hodině všechny počítače vypnuty. 
# Domů ale odcházíme už v 15:00. Jak můžeme co nejefektivněji k problému pomocí PowerShellu přistoupit? 

#$adminName = "FIRMA\Administrator"
#$adminPassword = ConvertTo-SecureString -String "Aa123456" -AsPlainText -Force
#$domainCredentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminName, $adminPassword

$domainCredential = Import-CliXml -Path 'E:\credentials.xml'

[string[]] $computers = Get-ADComputer -Filter * -SearchBase "OU=U1,OU=pocitace,OU=skola,DC=firma,DC=local" | Select-Object -ExpandProperty Name

$computers | ForEach-Object {
    if (Test-WSMan $_) {
        $session = New-PSSession -ComputerName $_ -Credential $domainCredential
        $computer = $_
        Invoke-Command -Session $session -ScriptBlock { Stop-Computer -ComputerName $using:computer -Force }
        $session | Disconnect-PSSession | Remove-PSSession
    }
}