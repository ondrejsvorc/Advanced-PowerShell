$taskExists = Get-ScheduledTask | ? { $_.TaskName -like "U1_VypniPc" }

if ($taskExists) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}