function Get-UserPassword {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $UserName
    )

    # Cmdlet
}

Get-UserPassword -UserName "jan"

function GetUserPassword ([string] $userName) {
    # Klasicka funkce
}

GetUserPassword("jan")

