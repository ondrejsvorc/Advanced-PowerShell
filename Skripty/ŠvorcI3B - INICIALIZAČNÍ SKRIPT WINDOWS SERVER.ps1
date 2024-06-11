#####################################################################################################################
#####################################################################################################################
#####################################################################################################################
#####################################################################################################################

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

#Zabezpečení struktury
Function Remove-ACL {    
    [CmdletBinding(SupportsShouldProcess=$True)]
    Param(
        [parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({Test-Path $_ -PathType Container})]
        [String[]]$Folder,
        [Switch]$Recurse
    )

    Process {
        foreach ($f in $Folder) {
            if ($Recurse) { $Folders = $(Get-ChildItem $f -Recurse -Directory).FullName} else {$Folders = $f }
            if ($Folders -ne $null) {
                $Folders | ForEach-Object {
                    # Remove inheritance
                    $acl = Get-Acl $_
                    $acl.SetAccessRuleProtection($false,$true)
                    Set-Acl $_ $acl

                    # Remove ACL
                    $acl = Get-Acl $_
                    $acl.Access | %{$acl.RemoveAccessRule($_)} | Out-Null
                    Set-Acl $_ $acl

                    Write-Verbose "Remove-HCacl: Inheritance disabled and permissions removed from $_"
                }
            }
            else {
                Write-Verbose "Remove-HCacl: No subfolders found for $f"
            }
        }
    }
}

[string] $passwordEnding = "123456"

# Funkce, která dokáže vytvořit heslo na základě uživatelského jména
function Get-UserPassword {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string] $userName
    )

    return ($userName.Substring(0, 1).ToUpper() + $userName[0] + $passwordEnding)
}

function Secure-Disk {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string] $Path
    )

    $acl = Get-Acl $Path

    $ace = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Users","ReadAndExecute","None","None","Allow")
    $acl.SetAccessRule($ace)

    $ace = Get-Acl $Path | Select-Object -ExpandProperty Access | Where-Object IdentityReference -eq "EVERYONE"
    $acl.RemoveAccessRule($ace)

    $ace = Get-Acl $Path | Select-Object -ExpandProperty Access | Where-Object IdentityReference -eq "CREATOR OWNER"
    $acl.RemoveAccessRule($ace)

    $acl | Set-Acl
}

function Secure-Home {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string] $Path
    )
	
    $acl = Get-Acl $Path
    $permission  = "BUILTIN\Users","ReadAndExecute", "None", "None", "Allow"
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($rule)
    Set-Acl $Path $acl
}

function Secure-Students {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string] $Path
    )
	
    $acl = Get-Acl $Path
    $permission  = "$domainName\studenti","ReadAndExecute", "None", "None", "Allow"
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($rule)
    Set-Acl $Path $acl
    $acl = Get-Acl $Path
    $permission  = "$domainName\ucitele","ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Allow"
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($rule)
    Set-Acl $Path $acl
}

function Secure-Teachers {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string] $Path
    )
	
    $acl = Get-Acl $Path
    $permission  = "$domainName\ucitele","ReadAndExecute", "None", "None", "Allow"
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($rule)
    Set-Acl $Path $acl
}

function Secure-Student {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string] $Student
    )
	
    $acl = Get-Acl "$studentsFolderPath\$Student"
    $permission  = "$domainName\$Student","Modify", "ContainerInherit,ObjectInherit", "None", "Allow"
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($rule)
    Set-Acl "$studentsFolderPath\$Student" $acl

    $acl = Get-Acl "$studentsFolderPath\$Student"
    $permission  = "$domainName\$Student","Delete", "None", "None", "Deny"
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($rule)
    Set-Acl "$studentsFolderPath\$Student" $acl
}

function Secure-Teacher {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string] $Teacher
    )
	
    $acl = Get-Acl "$teachersFolderPath\$Teacher"
    $permission  = "$domainName\$Teacher","Modify", "ContainerInherit,ObjectInherit", "None", "Allow"
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($rule)
    Set-Acl "$teachersFolderPath\$Teacher" $acl

    $acl = Get-Acl "$teachersFolderPath\$Teacher"
    $permission  = "$domainName\$Teacher","Delete", "None", "None", "Deny"
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($rule)
    Set-Acl "$teachersFolderPath\$Teacher" $acl
}

function Secure-Profiles {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string] $Path
    )
	
    $acl = Get-Acl $Path
    $permission  = "BUILTIN\Users","ReadAndExecute", "None", "None", "Allow"
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($rule)
    Set-Acl $Path $acl
}

function Secure-Profile {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string] $User
    )
	
    $profileFolder = "$User$version"
    $userProfileFolder = "$profilesFolderPath\$profileFolder"

    $acl = Get-Acl $userProfileFolder
    $permission  = "$domainName\$User","Modify", "ContainerInherit,ObjectInherit", "None", "Allow"
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($rule)
    Set-Acl $userProfileFolder $acl

    $acl = Get-Acl $userProfileFolder
    $permission  = "$domainName\$User","Delete", "None", "None", "Deny"
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($rule)
    Set-Acl $userProfileFolder $acl

    $acl = Get-Acl $userProfileFolder
    $permission  = "$domainName\$User","Modify", "ContainerInherit,ObjectInherit", "None", "Allow"
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($rule)
    Set-Acl $userProfileFolder $acl

    $acl = Get-Acl $userProfileFolder
    $permission  = "$domainName\$User","Delete", "None", "None", "Deny"
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
    $acl.SetAccessRule($rule)
    Set-Acl $userProfileFolder $acl
}



#####################################################################################################################
#####################################################################################################################
#####################################################################################################################
#####################################################################################################################

#Server
[string] $serverName = "srv1"

#Doména
[string] $domainName = "firma"
[string] $domainEnding = "local"

#Hlavní organizační jednotka ROOT
[string] $root = "skola"
[string] $rootPath = "DC=$domainName,DC=$domainEnding"

#Organizační jednotky v ROOT
[string[]] $ousRoot = @("pocitace", "skupiny", "uzivatele")
[string] $ousRootPath = "OU=$root,DC=$domainName,DC=$domainEnding"

#Organizační jednotky vnořené do POCITACE
[string[]] $ousClassrooms = @("U1", "U2", "U3", "U4", "U5")
[string] $ousClassroomsPath = "OU=pocitace,OU=$root,DC=$domainName,DC=$domainEnding"

#Skupiny vnořené do organizační jednotky SKUPINY
[string[]] $groups = @("studenti", "ucitele")
[string] $groupsPath = "OU=skupiny,OU=$root,DC=$domainName,DC=$domainEnding"

#Organizační jednotky vnořené do UZIVATELE
[string[]] $ousUsers = @("studenti", "ucitele")
[string] $ousUsersPath = "OU=uzivatele,OU=$root,DC=$domainName,DC=$domainEnding"

#Studenti a jejich umístění
[string[]] $students = @("jan", "petr")
[string] $studentsPath = "OU=studenti,OU=uzivatele,OU=$root,DC=$domainName,DC=$domainEnding"

#Ucitele a jejich umístění
[string[]] $teachers = @("ondra", "tomas")
[string] $teachersPath = "OU=ucitele,OU=uzivatele,OU=$root,DC=$domainName,DC=$domainEnding"

#Verze profilů
[string] $version = ".v6"
[string] $shareName = "domovske"

#Složky a jejich zabezpečení
[string] $rootDisk = "E:"
[string] $rootDiskPath = "E:\"
[string] $profilesFolder = "PROFILY"
[string] $profilesFolderPath = "$rootDisk\$profilesFolder"
[string] $rootFolder = "HOME"
[string] $rootFolderPath = "$rootDisk\$rootFolder"
[string[]] $rootFolderSubfolders = @("studenti", "ucitele")
[string] $studentsFolder = "studenti"
[string] $studentsFolderPath = "$rootFolderPath\$studentsFolder"
[string] $teachersFolder = "ucitele"
[string] $teachersFolderPath = "$rootFolderPath\$teachersFolder"


#$fullPermission = [System.Security.AccessControl.FileSystemRights]"FullControl"
$menit = [System.Security.AccessControl.FileSystemRights]"ReadAndExecute"
#$inheritanceFlag = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
$inheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::None
$propagationFlag = [System.Security.AccessControl.PropagationFlags]::None
$objTypeAllow = [System.Security.AccessControl.AccessControlType]::Allow
#$objTypeDeny = [System.Security.AccessControl.AccessControlType]::Deny

#Dodatečné proměnné pro zvýšení efektivity
[string] $generatedPassword
[string] $currentUser

#Vytvoření hlavní organizační jednotky ROOT
New-ADOrganizationalUnit -Name $root -Path $rootPath

#Vytvoření organizačních jednotek vnořených do hl. organizační jednotky ROOT (pocitace, skupiny, uzivatele)
foreach ($ouRoot in $ousRoot) {
   New-ADOrganizationalUnit -Name $ouRoot -Path $ousRootPath
}

#Vytvoření organizačních jednotek učeben v organizační jednotce POCITACE (u1, u2, u3, u4, u5)
foreach ($ouClassroom in $ousClassrooms) {
   New-ADOrganizationalUnit -Name $ouClassroom -Path $ousClassroomsPath
}

#Vytvoření skupin v organizační jednotce SKUPINY (studenti, ucitele)
foreach ($group in $groups) {
   New-ADGroup -GroupScope 1 -Name $group -Path $groupsPath
}

#Vytvoření organizačních jednotek vnořených do organizační jednotky UZIVATELE (studenti, ucitele)
foreach ($ouUser in $ousUsers) {
   New-ADOrganizationalUnit -Name $ouUser -Path $ousUsersPath
}

#Vytvoření uživatelů studentů a jejich následné přidání do skupiny STUDENTI
#Vytvoření jejich složek
foreach ($student in $students) {
    $generatedPassword = Get-UserPassword $student
    New-ADUser -Name $student -AccountPassword (ConvertTo-SecureString -AsPlainText $generatedPassword -Force) -CannotChangePassword 0 -ChangePasswordAtLogon 0 -Enabled 1 -Path $studentsPath
    Add-ADGroupMember -Identity "studenti" -Members $student
    New-Item -ItemType Directory -Path "$studentsFolderPath\$student"
    New-Item -ItemType Directory -Path "$profilesFolderPath\$student$version"
}

#Vytvoření uživatelů učitelů a jejich následné přidání do skupiny UCITELE
#Vytvoření jejich složek
foreach ($teacher in $teachers) {
    $generatedPassword = Get-UserPassword $teacher
    New-ADUser -Name $teacher -AccountPassword (ConvertTo-SecureString -AsPlainText $generatedPassword -Force) -CannotChangePassword 0 -ChangePasswordAtLogon 0 -Enabled 1 -Path $teachersPath
    Add-ADGroupMember -Identity "ucitele" -Members $teacher
    New-Item -ItemType Directory -Path "$teachersFolderPath\$teacher"
    New-Item -ItemType Directory -Path "$profilesFolderPath\$teacher$version"
}

#Vymazání všech oprávnění ze složek - přičemž přidání Administrators a SYSTEM, ty budou všude
Remove-ACL $rootDisk -Recurse -Verbose

# Zabezpečení E:
Secure-Disk $rootDiskPath

# Zabezpečení HOME
Secure-Home -Path $rootFolderPath

# Zabezpečení PROFILY
Secure-Profiles -Path $profilesFolderPath

# Zabezpečení STUDENTI
Secure-Students -Path $studentsFolderPath

#Zabezpečení UČITELÉ
Secure-Teachers -Path $teachersFolderPath

#Zabezpečení JEDNOTLIVÝCH STUDENTŮ
foreach ($student in $students) {
    Secure-Student -Student $student
    Secure-Profile -User $student
    Set-ADUser -Identity $student -ProfilePath "\\$serverName\$profilesFolder\$student"
    Set-ADUser -Identity $student -HomeDirectory "\\$serverName\$shareName\$studentsFolder\$student" -HomeDrive G:
}

#Zabezpečení JEDNOTLIVÝCH UČITELŮ
foreach ($teacher in $teachers) {
    Secure-Teacher -Teacher $teacher
    Secure-Profile -User $teacher
    Set-ADUser -Identity $teacher -ProfilePath "\\$serverName\$profilesFolder\$teacher"
    Set-ADUser -Identity $teacher -HomeDirectory "\\$serverName\$shareName\$teachersFolder\$teacher" -HomeDrive G:
}

New-SMBShare –Name $profilesFolder –Path "$rootDisk\$profilesFolder" –FullAccess Administrators -ChangeAccess Users -Confirm:$false
Set-SmbShare -Name $profilesFolder -FolderEnumerationMode AccessBased -CachingMode None -Confirm:$false
New-SMBShare –Name $shareName –Path "$rootDisk\$rootFolder" –FullAccess Administrators -ChangeAccess Users -Confirm:$false
Set-SmbShare -Name $shareName -FolderEnumerationMode AccessBased -CachingMode None -Confirm:$false