# Prestižní univerzita má přijmout 2000 nových studentů. 
# Tabulku s jejich celými jmény vždy dostáváme ve formátu CSV. 
# Naším prozatímním úkolem bude vytvořit každému z nich co nejefektivněji doménový účet s heslem.

#Doména
[string] $domainName = "firma"
[string] $domainEnding = "local"

#Hlavní organizační jednotka ROOT
[string] $root = "skola"

#Studenti a jejich umístění
[string] $studentsPath = "OU=studenti,OU=uzivatele,OU=$root,DC=$domainName,DC=$domainEnding"

$students = Import-Csv -Path "E:\studentsList500.csv"

#Synchronní přístup
foreach ($student in $students) {
    Write-Host "Vytvarim studenta:" $student.Name
    $generatedPassword = $student.Name.Substring(0, 1).ToUpper() + $student.Name.Substring(0, 1).ToLower() + "123456@"
    New-ADUser -Name $student.Name -AccountPassword (ConvertTo-SecureString -AsPlainText $generatedPassword -Force) -CannotChangePassword 0 -ChangePasswordAtLogon 0 -Enabled 1 -Path $studentsPath
    Add-ADGroupMember -Identity "studenti" -Members $student.Name
}

#Asynchronní přístup
$students | ForEach-Object -Parallel {
    Write-Host "Vytvarim studenta: " + $_.Name
    $generatedPassword = $_.Name.Substring(0, 1).ToUpper() + $_.Name.Substring(0, 1).ToLower() + "123456@"
    New-ADUser -Name $_.Name -AccountPassword (ConvertTo-SecureString -AsPlainText $generatedPassword -Force) -CannotChangePassword 0 -ChangePasswordAtLogon 0 -Enabled 1 -Path $using:studentsPath
    Add-ADGroupMember -Identity "studenti" -Members $_.Name
} -ThrottleLimit 2