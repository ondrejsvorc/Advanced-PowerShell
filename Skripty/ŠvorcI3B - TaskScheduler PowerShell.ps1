[string] $taskName = "U1_VypniPc"
[string] $time = "5:00 PM"
[string] $executor = "powershell.exe"
[string] $path = "E:\PSremoting.ps1"
[string] $description = "Skript, který každý den po 17:00 vypne všechny počítače v U1."

$taskExists = Get-ScheduledTask | ? { $_.TaskName -like $taskName }

if (!$taskExists) {
   $taskTrigger = New-ScheduledTaskTrigger -Daily -At $time
   $taskAction = New-ScheduledTaskAction -Execute $executor -Argument $path
   Register-ScheduledTask -TaskName $taskName -Description $description -Trigger $taskTrigger -Action $taskAction -RunLevel Highest –Force
}