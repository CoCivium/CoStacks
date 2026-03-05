Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

$taskName="CoCivium.CoGuardian.Watchdog"
$t = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if(-not $t){ throw "Missing scheduled task: $taskName" }

$info = Get-ScheduledTaskInfo -TaskName $taskName
"TaskName=$taskName"
"State=$($info.State)"
"LastRunTime=$($info.LastRunTime.ToString('o'))"
"NextRunTime=$($info.NextRunTime.ToString('o'))"
"LastTaskResult=$($info.LastTaskResult)"

# Show the action command line for sanity
$act = $t.Actions | Select-Object -First 1
"ActionExecute=$($act.Execute)"
"ActionArguments=$($act.Arguments)"
