$root = "C:\dev"
$out = "C:\joshos-atlas-prep\raw-inventory"

New-Item -ItemType Directory -Force -Path $out | Out-Null

$riskyNamePattern = '\\(\.env|\.env\..*|id_rsa|id_ed25519|credentials|secrets|secret|token|tokens|key|keys|firebase|supabase|vercel|openrouter|groq|anthropic|openai)(\.|$|\\)'

Get-ChildItem $root -Recurse -Force -ErrorAction SilentlyContinue |
  Where-Object {
    $_.FullName -match $riskyNamePattern -and
    $_.FullName -notmatch '\\node_modules\\|\\\.next\\|\\dist\\|\\build\\'
  } |
  Select-Object FullName, Length, LastWriteTime |
  Export-Csv "$out\risky-files.csv" -NoTypeInformation -Encoding utf8

Write-Host "Saved risky file list to $out\risky-files.csv"
