$taskExists = Get-ScheduledTask | ? { $_.TaskName -like "U1_VypniPc" }

if ($taskExists) {
    $newTrigger = New-ScheduledTaskTrigger -Weekly -At "5:30 PM"
    Set-ScheduledTask -TaskName $taskName -Trigger $newTrigger
}