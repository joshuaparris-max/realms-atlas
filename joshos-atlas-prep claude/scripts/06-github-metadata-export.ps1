# Script 6 — GitHub CLI Metadata Export
# Exports repo metadata from all three GitHub accounts
# Requires: GitHub CLI installed and authenticated (gh auth login)
# Check: gh --version && gh auth status

$out = "C:\joshos-atlas-prep\raw-inventory"

New-Item -ItemType Directory -Force -Path $out | Out-Null

# Check GitHub CLI is available
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  Write-Host "GitHub CLI (gh) is not installed."
  Write-Host "Install from: https://cli.github.com/"
  Write-Host "Or manually export repo lists from GitHub web UI."
  exit 1
}

Write-Host "Exporting GitHub repo metadata..."

Write-Host "Account: joshualparris"
gh repo list joshualparris --limit 200 --json name,nameWithOwner,url,visibility,description,isPrivate,updatedAt,pushedAt,primaryLanguage |
  Out-File "$out\github-repos-joshualparris.json" -Encoding utf8

Write-Host "Account: joshuaparris-max"
gh repo list joshuaparris-max --limit 200 --json name,nameWithOwner,url,visibility,description,isPrivate,updatedAt,pushedAt,primaryLanguage |
  Out-File "$out\github-repos-joshuaparris-max.json" -Encoding utf8

Write-Host "Account: joshparri"
gh repo list joshparri --limit 200 --json name,nameWithOwner,url,visibility,description,isPrivate,updatedAt,pushedAt,primaryLanguage |
  Out-File "$out\github-repos-joshparri.json" -Encoding utf8

Write-Host "Done. Saved to $out"
Write-Host ""
Write-Host "If any account export failed, log in with: gh auth login --hostname github.com"
