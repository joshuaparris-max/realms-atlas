$root = "C:\dev"
$out = "C:\joshos-atlas-prep\raw-inventory\git-status-raw.txt"

Remove-Item $out -ErrorAction SilentlyContinue

Get-ChildItem $root -Directory -Force | ForEach-Object {
  $repoPath = $_.FullName

  if (Test-Path (Join-Path $repoPath ".git")) {
    "==================================================" | Out-File $out -Append -Encoding utf8
    "REPO: $($_.Name)" | Out-File $out -Append -Encoding utf8
    "PATH: $repoPath" | Out-File $out -Append -Encoding utf8
    "==================================================" | Out-File $out -Append -Encoding utf8

    Push-Location $repoPath

    "REMOTE:" | Out-File $out -Append -Encoding utf8
    git remote -v | Out-File $out -Append -Encoding utf8

    "`nBRANCH:" | Out-File $out -Append -Encoding utf8
    git branch --show-current | Out-File $out -Append -Encoding utf8

    "`nSTATUS:" | Out-File $out -Append -Encoding utf8
    git status --short | Out-File $out -Append -Encoding utf8

    "`nLAST COMMIT:" | Out-File $out -Append -Encoding utf8
    git log -1 --pretty=format:"%h %ad %s" --date=short | Out-File $out -Append -Encoding utf8

    "`n" | Out-File $out -Append -Encoding utf8

    Pop-Location
  }
}

Write-Host "Saved git status inventory to $out"
