$root = "C:\dev"
$out = "C:\joshos-atlas-prep\raw-inventory"

Get-ChildItem $root -Recurse -Depth 3 -Force -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName -notmatch '\\node_modules\\|\\\.git\\|\\\.next\\|\\dist\\|\\build\\' } |
  Select-Object FullName, Name, Mode, LastWriteTime |
  Export-Csv "$out\local-folders-raw.csv" -NoTypeInformation -Encoding utf8

Write-Host "Saved folder inventory to $out\local-folders-raw.csv"
