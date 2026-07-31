$root = "C:\dev"
$out = "C:\joshos-atlas-prep\raw-inventory\embedded-credential-remotes.txt"

Remove-Item $out -ErrorAction SilentlyContinue

Get-ChildItem $root -Recurse -Force -Filter "config" -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName -match '\\\.git\\config$' } |
  ForEach-Object {
    $file = $_.FullName
    $hits = Select-String -Path $file -Pattern "https://[^/:\s]+:[^@\s]+@github\.com" -ErrorAction SilentlyContinue

    if ($hits) {
      "=== $file ===" | Out-File $out -Append -Encoding utf8
      $hits | Select-Object Path, LineNumber, Line | Out-File $out -Append -Encoding utf8
      "" | Out-File $out -Append -Encoding utf8
    }
  }

Write-Host "Saved embedded credential remote hits to $out"
