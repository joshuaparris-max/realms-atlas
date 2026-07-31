# Script 3 — Git Config Credential Scan
# Finds embedded credentials in .git/config files
# This catches tokens baked into remote URLs: https://username:TOKEN@github.com/...
# This is the MOST DANGEROUS exposure type — Scripts 1 and 2 will NOT catch this
# COMPLEMENTS Script 1 and Script 2
# Run BEFORE feeding any repo content to AI

$root = "C:\dev"
$out = "C:\joshos-atlas-prep\raw-inventory\embedded-credential-remotes.txt"

Remove-Item $out -ErrorAction SilentlyContinue

Write-Host "Scanning .git/config files for embedded credentials in $root..."

$foundCount = 0

Get-ChildItem $root -Recurse -Force -Filter "config" -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName -match '\\\.git\\config$' } |
  ForEach-Object {
    $file = $_.FullName
    $hits = Select-String -Path $file -Pattern "https://[^/:\s]+:[^@\s]+@github\.com" -ErrorAction SilentlyContinue

    if ($hits) {
      $foundCount++
      "=== CREDENTIAL FOUND IN: $file ===" | Out-File $out -Append -Encoding utf8
      $hits | Select-Object Path, LineNumber, Line | Out-File $out -Append -Encoding utf8
      "" | Out-File $out -Append -Encoding utf8
    }
  }

if ($foundCount -eq 0) {
  "No embedded credentials found in .git/config files." | Out-File $out -Encoding utf8
  Write-Host "Done. No embedded credentials found."
} else {
  Write-Host "Done. Found $foundCount repos with embedded credentials in .git/config!"
  Write-Host "These must be remediated before any repo content is shared with AI."
}

Write-Host "Saved to: $out"
Write-Host ""
Write-Host "IMPORTANT: Review this file manually before sharing with any AI."
Write-Host "To fix: git remote set-url origin https://github.com/user/repo.git"
Write-Host "Then revoke the exposed token in GitHub Settings > Developer Settings > Personal Access Tokens"
