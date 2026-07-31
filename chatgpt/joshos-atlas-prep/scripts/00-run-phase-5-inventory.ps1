powershell -ExecutionPolicy Bypass -File C:\joshos-atlas-prep\scripts\04-local-folder-inventory.ps1
powershell -ExecutionPolicy Bypass -File C:\joshos-atlas-prep\scripts\05-git-status-inventory.ps1
powershell -ExecutionPolicy Bypass -File C:\joshos-atlas-prep\scripts\06-github-metadata-export.ps1
Write-Host "Inventory scripts complete. If GitHub CLI is not installed/logged in, script 06 may fail safely."
