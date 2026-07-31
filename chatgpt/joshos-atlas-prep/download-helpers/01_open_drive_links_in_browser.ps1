param(
  [string]$CsvPath = "",
  [string]$FilterIncludeNow = "",
  [string]$FilterCategory = ""
)

if ([string]::IsNullOrWhiteSpace($CsvPath)) {
  $CsvPath = Join-Path (Split-Path -Parent $PSScriptRoot) "PDF_LINKS.csv"
  if (!(Test-Path $CsvPath)) {
    $CsvPath = Join-Path (Get-Location) "PDF_LINKS.csv"
  }
}

$Links = Import-Csv $CsvPath

if ($FilterIncludeNow) {
  $Links = $Links | Where-Object { $_.include_now -eq $FilterIncludeNow }
}

if ($FilterCategory) {
  $Links = $Links | Where-Object { $_.category -eq $FilterCategory }
}

Write-Host "Opening $($Links.Count) Drive links in your default browser."
Write-Host "Make sure you are signed into the correct Google account."

foreach ($Link in $Links) {
  Write-Host "Opening: $($Link.filename)"
  Start-Process $Link.drive_url
  Start-Sleep -Milliseconds 700
}
