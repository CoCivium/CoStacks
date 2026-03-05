Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'

$taskName="CoCivium.CoGuardian.Watchdog"

$t = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if(-not $t){ throw "Missing scheduled task: $taskName" }

"TaskName=$taskName"

# State is NOT reliably present on Get-ScheduledTaskInfo across environments
try {
  "State=$($t.State)"
} catch {
  "State=(unknown via Get-ScheduledTask)"
}

# Scheduling / last-run details
$info = $null
try { $info = Get-ScheduledTaskInfo -TaskName $taskName -ErrorAction Stop } catch { $info = $null }

if($info){
  foreach($p in @('LastRunTime','NextRunTime','LastTaskResult','NumberOfMissedRuns')){
    try {
      if($info.PSObject.Properties.Name -contains $p){
        $v = $info.$p
        if($v -is [datetime]){ "{0}={1}" -f $p, $v.ToString('o') } else { "{0}={1}" -f $p, $v }
      } else {
        "{0}=(missing)" -f $p
      }
    } catch {
      "{0}=(error:{1})" -f $p, $_.Exception.Message
    }
  }
} else {
  "Get-ScheduledTaskInfo=(failed)"
}

# Show action line(s)
try {
  $acts = @($t.Actions)
  $i=0
  foreach($a in $acts){
    $i++
    "Action[$i].Execute=$($a.Execute)"
    "Action[$i].Arguments=$($a.Arguments)"
  }
} catch {
  "Actions=(error:{0})" -f $_.Exception.Message
}

# Fallback proof via schtasks
try {
  ""
  "=== schtasks /Query proof (first ~40 lines) ==="
  $q = & schtasks /Query /TN $taskName /V /FO LIST 2>&1
  $q | Select-Object -First 40
} catch {
  "schtasks=(error:{0})" -f $_.Exception.Message
}
