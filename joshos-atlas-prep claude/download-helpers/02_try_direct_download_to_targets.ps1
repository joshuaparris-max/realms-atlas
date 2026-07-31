param(
  [string]$CsvPath = "",
  [string]$TargetRoot = "",
  [switch]$IncludePrivateHigh,
  [switch]$IncludeLocalOnly
)

if ([string]::IsNullOrWhiteSpace($CsvPath)) {
  $CsvPath = Join-Path (Split-Path -Parent $PSScriptRoot) "PDF_LINKS.csv"
  if (!(Test-Path $CsvPath)) {
    $CsvPath = Join-Path (Get-Location) "PDF_LINKS.csv"
  }
}

$Targets = @(
  "C:\dev\joshos-atlas\chatgpt\joshos-atlas-prep",
  "C:\dev\joshos-atlas\joshos-atlas-prep\joshos-atlas-prep claude"
)

if ($TargetRoot) {
  $Targets = @($TargetRoot)
}

$Links = Import-Csv $CsvPath

# By default, avoid pulling local-only or private-high raw docs.
if (-not $IncludePrivateHigh) {
  $Links = $Links | Where-Object { $_.sensitivity -ne "private-high" }
}
if (-not $IncludeLocalOnly) {
  $Links = $Links | Where-Object { $_.sensitivity -ne "local-only" }
}

foreach ($Target in $Targets) {
  New-Item -ItemType Directory -Force -Path $Target | Out-Null

  foreach ($Link in $Links) {
    $Folder = Join-Path $Target $Link.target_subfolder
    New-Item -ItemType Directory -Force -Path $Folder | Out-Null

    $OutFile = Join-Path $Folder $Link.filename
    Write-Host "Trying direct download: $($Link.filename) -> $OutFile"

    try {
      Invoke-WebRequest -Uri $Link.direct_download_url -OutFile $OutFile -UseBasicParsing -ErrorAction Stop

      # Basic sanity check: Google login/error HTML is not a real PDF.
      $bytes = [System.IO.File]::ReadAllBytes($OutFile)
      $header = [System.Text.Encoding]::ASCII.GetString($bytes[0..([Math]::Min(4, $bytes.Length-1))])
      if ($header -notlike "%PDF*") {
        Write-Warning "Downloaded file does not look like a PDF. It may be a Google login/permission HTML page: $OutFile"
      }
    }
    catch {
      Write-Warning "Failed: $($Link.filename). Open the Drive link manually instead: $($Link.drive_url)"
    }
  }
}

Write-Host "Done. Note: private Google Drive links usually need browser download while signed in."
