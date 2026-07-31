# Script 5 — Git Status Inventory
# Generates git remote, branch, status, and last commit for every repo in C:\dev
# Run AFTER security precheck is complete

$root = "C:\dev"
$out = "C:\joshos-atlas-prep\raw-inventory\git-status-raw.txt"

Remove-Item $out -ErrorAction SilentlyContinue

Write-Host "Generating git status inventory from $root..."

$repoCount = 0

Get-ChildItem $root -Directory -Force | ForEach-Object {
  $repoPath = $_.FullName

  if (Test-Path (Join-Path $repoPath ".git")) {
    $repoCount++
    "==================================================" | Out-File $out -Append -Encoding utf8
    "REPO: $($_.Name)" | Out-File $out -Append -Encoding utf8
    "PATH: $repoPath" | Out-File $out -Append -Encoding utf8
    "==================================================" | Out-File $out -Append -Encoding utf8

    Push-Location $repoPath

    "REMOTE:" | Out-File $out -Append -Encoding utf8
    git remote -v 2>&1 | Out-File $out -Append -Encoding utf8

    "`nBRANCH:" | Out-File $out -Append -Encoding utf8
    git branch --show-current 2>&1 | Out-File $out -Append -Encoding utf8

    "`nSTATUS:" | Out-File $out -Append -Encoding utf8
    git status --short 2>&1 | Out-File $out -Append -Encoding utf8

    "`nLAST COMMIT:" | Out-File $out -Append -Encoding utf8
    git log -1 --pretty=format:"%h %ad %s" --date=short 2>&1 | Out-File $out -Append -Encoding utf8

    "`n" | Out-File $out -Append -Encoding utf8

    Pop-Location
  }
}

Write-Host "Done. Found $repoCount git repos."
Write-Host "Saved to: $out"
