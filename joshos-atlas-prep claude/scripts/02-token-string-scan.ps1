# Script 2 — Token String Scan
# Finds token-looking strings INSIDE ordinary files (not just risky filenames)
# COMPLEMENTS Script 1 (filename scan) and Script 3 (git config scan)
# Run BEFORE feeding any repo content to AI

$root = "C:\dev"
$out = "C:\joshos-atlas-prep\raw-inventory\token-string-hits.txt"

$patterns = @(
  "ghp_",
  "github_pat_",
  "sk-",
  "OPENAI_API_KEY",
  "ANTHROPIC_API_KEY",
  "GROQ_API_KEY",
  "OPENROUTER_API_KEY",
  "VERCEL_TOKEN",
  "SUPABASE_SERVICE_ROLE",
  "FIREBASE_PRIVATE_KEY"
)

$extensions = "*.md","*.txt","*.json","*.js","*.ts","*.tsx","*.jsx","*.env","*.yml","*.yaml","*.toml","*.config.*"

Remove-Item $out -ErrorAction SilentlyContinue

Write-Host "Scanning for token-looking strings in $root..."
Write-Host "This may take a few minutes..."

$totalHits = 0

foreach ($pattern in $patterns) {
  "=== Searching for: $pattern ===" | Out-File $out -Append -Encoding utf8

  $hits = Get-ChildItem $root -Recurse -Include $extensions -File -Force -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch '\\node_modules\\|\\\.git\\objects\\|\\\.next\\|\\dist\\|\\build\\' } |
    Select-String -Pattern $pattern -SimpleMatch -ErrorAction SilentlyContinue

  if ($hits) {
    $hits | Select-Object Path, LineNumber, Line | Out-File $out -Append -Encoding utf8
    $totalHits += $hits.Count
  } else {
    "(no hits)" | Out-File $out -Append -Encoding utf8
  }

  "" | Out-File $out -Append -Encoding utf8
}

Write-Host "Done. Found $totalHits total string hits."
Write-Host "Saved to: $out"
Write-Host ""
Write-Host "IMPORTANT: Review this file manually before sharing with any AI."
Write-Host "Replace any real tokens with: [REDACTED_SECRET]"
