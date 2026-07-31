# Script 1 — Risky Filename Scan
# Finds files with names that suggest they may contain secrets
# COMPLEMENTS Script 2 (string scan) and Script 3 (git config scan)
# Run BEFORE feeding any repo content to AI

$root = "C:\dev"
$out = "C:\joshos-atlas-prep\raw-inventory"

New-Item -ItemType Directory -Force -Path $out | Out-Null

$riskyNamePattern = '\\(\.env|\.env\..*|id_rsa|id_ed25519|credentials|secrets|secret|token|tokens|key|keys|firebase|supabase|vercel|openrouter|groq|anthropic|openai)(\.|$|\\)'

Write-Host "Scanning for risky filenames in $root..."

Get-ChildItem $root -Recurse -Force -ErrorAction SilentlyContinue |
  Where-Object {
    $_.FullName -match $riskyNamePattern -and
    $_.FullName -notmatch '\\node_modules\\|\\\.next\\|\\dist\\|\\build\\'
  } |
  Select-Object FullName, Length, LastWriteTime |
  Export-Csv "$out\risky-files.csv" -NoTypeInformation -Encoding utf8

$count = (Import-Csv "$out\risky-files.csv" -ErrorAction SilentlyContinue | Measure-Object).Count
Write-Host "Done. Found $count potentially risky files."
Write-Host "Saved to: $out\risky-files.csv"
Write-Host ""
Write-Host "IMPORTANT: Review this file manually before sharing with any AI."
Write-Host "Replace any real tokens with: [REDACTED_SECRET]"
