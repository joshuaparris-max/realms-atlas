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

$extensions = "*.md","*.txt","*.json","*.js","*.ts","*.tsx","*.jsx","*.env","*.yml","*.yaml","*.toml"

Remove-Item $out -ErrorAction SilentlyContinue

foreach ($pattern in $patterns) {
  "=== Searching for $pattern ===" | Out-File $out -Append -Encoding utf8

  Get-ChildItem $root -Recurse -Include $extensions -File -Force -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch '\\node_modules\\|\\\.git\\objects\\|\\\.next\\|\\dist\\|\\build\\' } |
    Select-String -Pattern $pattern -SimpleMatch -ErrorAction SilentlyContinue |
    Select-Object Path, LineNumber, Line |
    Out-File $out -Append -Encoding utf8
}

Write-Host "Saved token string hits to $out"
