#Doména
[string] $domainName = "firma"
[string] $domainEnding = "local"

#Hlavní organizační jednotka
[string] $root = "skola"

Measure-Command {
    1..100 | % {
        New-ADGroup -Name $_ -GroupScope 1 -Path "OU=skupiny,OU=$root,DC=$domainName,DC=$domainEnding"
    }
}

#Asynchronní přístup
Measure-Command {
    1..100 | % {
        Start-Job -Name $_ -ScriptBlock { 
            New-ADGroup -Name $args[0] -GroupScope 1 -Path "OU=skupiny,OU=$using:root,DC=$using:domainName,DC=$using:domainEnding" 
        } –ArgumentList $_
    
        Remove-Job -State Completed
    }
}