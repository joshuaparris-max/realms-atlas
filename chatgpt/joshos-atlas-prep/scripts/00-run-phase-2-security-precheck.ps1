powershell -ExecutionPolicy Bypass -File C:\joshos-atlas-prep\scripts\01-risky-file-scan.ps1
powershell -ExecutionPolicy Bypass -File C:\joshos-atlas-prep\scripts\02-token-string-scan.ps1
powershell -ExecutionPolicy Bypass -File C:\joshos-atlas-prep\scripts\03-git-config-credential-scan.ps1
Write-Host "Security precheck complete. Review raw-inventory outputs before sharing with AI."
