Start-Job -Name "job" -ScriptBlock { 
    [int] $a = 5 + 5
    [int] $b = 5 + 10
    [int] $c = 5 + 15

    return @($a,$b,$c);

    #Bud pres return, nebo Write-Output
}

$result = Get-Job -Name "job" | Receive-Job
Remove-Job -State Completed
