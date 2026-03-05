param([Parameter(Mandatory=$true)][string]$Text)

Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"

function Fail([string]$m){ throw "FAIL-CLOSED: $m" }

# Heuristic: flag lines that look like naked prose (letters/slashes) but are not comments, not strings, not valid PS starters.
$bad = New-Object System.Collections.Generic.List[string]
$lines = $Text -split "`r?`n"
for($i=0;$i -lt $lines.Count;$i++){
  $l = $lines[$i]
  $t = $l.Trim()
  if($t -eq ""){ continue }
  if($t.StartsWith("#")){ continue }
  if($t.StartsWith("<#")){ continue }
  if($t.StartsWith("}")){ continue }
  if($t.StartsWith("{")){ continue }
  if($t.StartsWith("$")){ continue }
  if($t.StartsWith("param(")){ continue }
  if($t.StartsWith("function ")){ continue }
  if($t.StartsWith("if(") -or $t.StartsWith("if (")){ continue }
  if($t.StartsWith("for(") -or $t.StartsWith("foreach(") -or $t.StartsWith("while(")){ continue }
  if($t.StartsWith("try") -or $t.StartsWith("catch") -or $t.StartsWith("finally")){ continue }
  if($t.StartsWith("@'") -or $t.StartsWith("@\"")){ continue }
  if($t.StartsWith("'") -or $t.StartsWith("""")){ continue }
  if($t -match "^[\)\];,]+$"){ continue }

  # PROSE smell: starts with a letter and contains no typical PS operators; also catches "engine/runbooks:"
  if($t -match "^[A-Za-z]" -and $t -notmatch "[=\$\(\)\{\}]" ){
    $bad.Add(("{0}: {1}" -f ($i+1), $t)) | Out-Null
    continue
  }
  if($t -match "^[A-Za-z0-9\._-]+\/[A-Za-z0-9\._-]+:"){
    $bad.Add(("{0}: {1}" -f ($i+1), $t)) | Out-Null
    continue
  }
}
if($bad.Count -gt 0){
  Fail ("Prose-leak suspected. Fix DO block before running. Offenders:`n" + ($bad -join "`n"))
}