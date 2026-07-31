$Targets = @(
  "C:\dev\joshos-atlas\chatgpt\joshos-atlas-prep",
  "C:\dev\joshos-atlas\joshos-atlas-prep\joshos-atlas-prep claude"
)

foreach ($Target in $Targets) {
  New-Item -ItemType Directory -Force -Path $Target | Out-Null
  New-Item -ItemType Directory -Force -Path (Join-Path $Target "pdfs") | Out-Null
  New-Item -ItemType Directory -Force -Path (Join-Path $Target "download-helpers") | Out-Null
}

$KitRoot = Split-Path -Parent $PSScriptRoot

foreach ($Target in $Targets) {
  Copy-Item (Join-Path $KitRoot "PDF_LINKS.csv") -Destination $Target -Force
  Copy-Item (Join-Path $KitRoot "PDF_LINKS.md") -Destination $Target -Force
  Copy-Item (Join-Path $KitRoot "PDF_LINKS.html") -Destination $Target -Force
  Copy-Item (Join-Path $KitRoot "REPO_LINKS.md") -Destination $Target -Force
  Copy-Item (Join-Path $KitRoot "TARGET_PATHS.txt") -Destination $Target -Force
  Copy-Item (Join-Path $KitRoot "download-helpers\*.ps1") -Destination (Join-Path $Target "download-helpers") -Force
}

Write-Host "Copied link kit to both target folders."
