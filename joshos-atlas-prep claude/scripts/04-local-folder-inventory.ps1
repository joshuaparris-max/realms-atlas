# Script 4 — Local Folder Inventory
# General folder map only — limited depth for readability
# NOT for secret scanning — use Scripts 1-3 for that
# Run AFTER security precheck is complete

$root = "C:\dev"
$out = "C:\joshos-atlas-prep\raw-inventory"

New-Item -ItemType Directory -Force -Path $out | Out-Null

Write-Host "Generating local folder inventory (depth 3) from $root..."

Get-ChildItem $root -Recurse -Depth 3 -Force -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName -notmatch '\\node_modules\\|\\\.git\\|\\\.next\\|\\dist\\|\\build\\' } |
  Select-Object FullName, Name, Mode, LastWriteTime |
  Export-Csv "$out\local-folders-raw.csv" -NoTypeInformation -Encoding utf8

Write-Host "Saved to: $out\local-folders-raw.csv"
