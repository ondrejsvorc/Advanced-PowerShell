function Secure-Disk {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string] $DiskPath
    )

    $acl = Get-Acl "W:/"

    $ace = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Users", "ReadAndExecute", "None", "None", "Allow")
    $acl.SetAccessRule($ace)

    $ace = Get-Acl $DiskPath | Select-Object -ExpandProperty Access | Where-Object IdentityReference -eq "EVERYONE"
    $acl.RemoveAccessRule($ace)

    $ace = Get-Acl $DiskPath | Select-Object -ExpandProperty Access | Where-Object IdentityReference -eq "CREATOR OWNER"
    $acl.RemoveAccessRule($ace)

    $acl | Set-Acl
}

Secure-Disk -DiskPath "W:/"

$acl = Get-Acl "W:/"
$acl.Access | % { $acl.RemoveAccessRule($_) }

# Preruseni dedicnosti
$acl = Get-ACL "W:/"
$acl.SetAccessRuleProtection($True, $True)
$acl | Set-Acl