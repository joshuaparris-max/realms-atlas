# ============================================================
# JoshOS Atlas Prep Bootstrap
# Safe/read-only for repos. Creates prep folders + audit files.
# ============================================================

$ErrorActionPreference = "Continue"

$Base = "C:\dev\joshos-atlas"
$DevRoot = "C:\dev"

$KitBase = Join-Path $Base "joshos-atlas-pdf-download-kit\joshos-atlas-pdf-download-kit"
$KitHelpers = Join-Path $KitBase "download-helpers"

$ChatGPTPrep = Join-Path $Base "chatgpt\joshos-atlas-prep"
$ClaudePrep = Join-Path $Base "joshos-atlas-prep\joshos-atlas-prep claude"

$Targets = @($ChatGPTPrep, $ClaudePrep)

New-Item -ItemType Directory -Force -Path $KitHelpers | Out-Null

function Write-FileUtf8 {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Content
    )
    $parent = Split-Path $Path -Parent
    if ($parent) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
    Set-Content -Path $Path -Value $Content -Encoding UTF8
}

Write-Host "Creating helper scripts in: $KitHelpers" -ForegroundColor Cyan

# ------------------------------------------------------------
# 01_create_joshos_prep_folders.ps1
# ------------------------------------------------------------
Write-FileUtf8 -Path (Join-Path $KitHelpers "01_create_joshos_prep_folders.ps1") -Content @'
param(
    [string[]]$Targets = @(
        "C:\dev\joshos-atlas\chatgpt\joshos-atlas-prep",
        "C:\dev\joshos-atlas\joshos-atlas-prep\joshos-atlas-prep claude"
    )
)

$folders = @(
    "scripts",
    "raw-inventory",
    "source-cards",
    "approved-for-fable",
    "excluded-private",
    "architecture-draft",
    "fable-output",
    "fable-output\scaffold",
    "pdf-download-kit"
)

$files = @(
    "00_SECURITY_PRECHECK.md",
    "01_PERSONAL_CONTEXT.md",
    "02_PRIVACY_BOUNDARIES.md",
    "03_CANONICAL_GOALS.md",
    "04_SOURCE_REGISTER.csv",
    "05_SEED_DATA_FORMAT.md",
    "06_FABLE_SESSION.md",
    "source-cards\repo-cards.md",
    "source-cards\deployment-cards.md",
    "source-cards\email-cards.md",
    "source-cards\doc-cards.md",
    "source-cards\local-workspace-cards.md",
    "source-cards\privacy-risk-cards.md",
    "source-cards\open-action-cards.md",
    "source-cards\QUALITY_GATE.md",
    "architecture-draft\architecture-draft.md",
    "architecture-draft\schema-draft.sql",
    "architecture-draft\first-commit-scope.md",
    "architecture-draft\risk-register.md",
    "fable-output\architecture-decision-record.md",
    "fable-output\canonical-repo-map.md",
    "fable-output\schema.sql",
    "fable-output\privacy-risk-report.md",
    "fable-output\top-10-actions.md",
    "fable-output\weekly-review-template.md",
    "fable-output\README.md",
    "fable-output\test-plan.md",
    "fable-output\implementation-plan.md"
)

foreach ($target in $Targets) {
    Write-Host "Preparing $target" -ForegroundColor Cyan
    New-Item -ItemType Directory -Force -Path $target | Out-Null

    foreach ($folder in $folders) {
        New-Item -ItemType Directory -Force -Path (Join-Path $target $folder) | Out-Null
    }

    foreach ($file in $files) {
        $path = Join-Path $target $file
        if (-not (Test-Path $path)) {
            New-Item -ItemType File -Force -Path $path | Out-Null
        }
    }

    $personal = Join-Path $target "01_PERSONAL_CONTEXT.md"
    if ((Get-Item $personal).Length -eq 0) {
        @"
# Personal Context

I am Josh Parris, a Christian husband and dad in Dubbo, NSW. I work across IT/library support, MSP-style tech work, family systems, job/career transition, and personal app building.

I have many apps, repos, deployments, documents, and ideas spread across GitHub accounts, Vercel, Google Drive, Gmail, and local folders. I need JoshOS Atlas to help me see what matters, what is broken, what is risky, and what to do next.

The system must be calm, practical, private-first, and realistic for a time-poor solo developer with family responsibilities.

## What success should feel like

JoshOS Atlas should help me feel calmer, clearer, and less scattered. It should reduce open loops, not create another project that nags me. When it is working, I should be able to open it and quickly see what matters, what can wait, what is unsafe or broken, and the next faithful step to take. The point is not more productivity for its own sake; it is more clarity, less mental clutter, and more presence for God, Kristy, Sylvie, Elias, work, and the things I have actually been given to steward.
"@ | Set-Content $personal -Encoding UTF8
    }

    $privacy = Join-Path $target "02_PRIVACY_BOUNDARIES.md"
    if ((Get-Item $privacy).Length -eq 0) {
        @"
# Privacy Boundaries

## Never commit to GitHub

- .env files
- API keys
- GitHub tokens
- Vercel tokens
- Anthropic/OpenAI/OpenRouter/Groq keys
- health records
- child therapy or NDIS documents
- school/student/staff data
- bank statements
- private family or marriage notes
- tenancy evidence photos unless deliberately redacted

## Local-only unless explicitly approved

- health material
- kids' support documents
- legal/tenancy documents
- financial account data
- family admin
- private emails

## AI rules

- Separate source facts from interpretation.
- If uncertain, mark uncertain.
- Do not invent missing facts.
- Do not give legal, medical, tax, financial, or investment advice as if qualified.
- Every recommendation must cite source IDs.
- Public deployments must use fake/sample data only.
"@ | Set-Content $privacy -Encoding UTF8
    }

    $canonical = Join-Path $target "03_CANONICAL_GOALS.md"
    if ((Get-Item $canonical).Length -eq 0) {
        @"
# Canonical Goals

## Primary GitHub account

joshualparris

This is the canonical long-term account for serious apps, finished work, public portfolio work, and JoshOS Atlas.

## Secondary GitHub account

joshuaparris-max

This is experimental / AI-build / draft space. Projects here should either be promoted to joshualparris, archived, or kept clearly labelled as experimental.

## Work-specific account

joshparri

This is only for work/professional-development projects where needed.

## Canonical hub

JoshOS Atlas / JoshHub becomes the private local-first command centre for app, repo, document, deployment, privacy-risk, and next-action tracking.

## Main decisions Fable must help make

- which repos to keep
- which repos to merge
- which repos to archive
- which repos to privatise
- which deployments to disable
- which child/family-named apps need neutral naming
- which local folders are canonical
"@ | Set-Content $canonical -Encoding UTF8
    }
}

Write-Host "Done creating prep folders/files." -ForegroundColor Green
'@

# ------------------------------------------------------------
# 02_security_precheck.ps1
# ------------------------------------------------------------
Write-FileUtf8 -Path (Join-Path $KitHelpers "02_security_precheck.ps1") -Content @'
param(
    [string]$DevRoot = "C:\dev",
    [string]$OutputRoot = "C:\dev\joshos-atlas\joshos-atlas-prep\joshos-atlas-prep claude\raw-inventory"
)

New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null

function Test-SkipPath {
    param([string]$Path)
    return ($Path -match '\\node_modules\\|\\\.git\\objects\\|\\\.next\\|\\dist\\|\\build\\|\\\.venv\\|\\venv\\|\\AppData\\')
}

Write-Host "Security scan 1/3: risky filenames..." -ForegroundColor Cyan

$riskyNamePattern = '\\(\.env|\.env\..*|id_rsa|id_ed25519|credentials|secrets|secret|token|tokens|key|keys|firebase|supabase|vercel|openrouter|groq|anthropic|openai)(\.|$|\\)'

Get-ChildItem $DevRoot -Recurse -Force -ErrorAction SilentlyContinue |
    Where-Object {
        $_.FullName -match $riskyNamePattern -and
        -not (Test-SkipPath $_.FullName)
    } |
    Select-Object FullName, Length, LastWriteTime |
    Export-Csv (Join-Path $OutputRoot "risky-files.csv") -NoTypeInformation -Encoding utf8

Write-Host "Security scan 2/3: token-looking strings without exposing line contents..." -ForegroundColor Cyan

$tokenOut = Join-Path $OutputRoot "token-string-hits.csv"

$patterns = @(
    "ghp_",
    "github_pat_",
    "sk-",
    "OPENAI_API_KEY",
    "ANTHROPIC_API_KEY",
    "GROQ_API_KEY",
    "OPENROUTER_API_KEY",
    "VERCEL_TOKEN",
    "SUPABASE_SERVICE_ROLE",
    "FIREBASE_PRIVATE_KEY",
    "PRIVATE_KEY",
    "CLIENT_SECRET"
)

$allowedExtensions = @(
    ".md",".txt",".json",".js",".ts",".tsx",".jsx",".env",".yml",".yaml",".toml",".config",".ps1",".sh",".html",".css"
)

$maxBytes = 2MB
$hits = New-Object System.Collections.Generic.List[object]

Get-ChildItem $DevRoot -Recurse -File -Force -ErrorAction SilentlyContinue |
    Where-Object {
        -not (Test-SkipPath $_.FullName) -and
        $_.Length -lt $maxBytes -and
        ($allowedExtensions -contains $_.Extension.ToLower() -or $_.Name -like ".env*")
    } |
    ForEach-Object {
        $file = $_.FullName
        foreach ($pattern in $patterns) {
            try {
                $matches = Select-String -Path $file -Pattern $pattern -SimpleMatch -ErrorAction SilentlyContinue
                foreach ($m in $matches) {
                    $hits.Add([pscustomobject]@{
                        Path = $file
                        LineNumber = $m.LineNumber
                        Pattern = $pattern
                        Note = "Line content intentionally redacted. Open file locally to inspect."
                    })
                }
            } catch {}
        }
    }

$hits | Export-Csv $tokenOut -NoTypeInformation -Encoding utf8

Write-Host "Security scan 3/3: embedded credentials in .git/config remotes..." -ForegroundColor Cyan

$remoteOut = Join-Path $OutputRoot "embedded-credential-remotes.csv"
$remoteHits = New-Object System.Collections.Generic.List[object]

Get-ChildItem $DevRoot -Recurse -Force -Filter "config" -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -match '\\\.git\\config$' } |
    ForEach-Object {
        $file = $_.FullName
        try {
            $matches = Select-String -Path $file -Pattern "https://[^/:\s]+:[^@\s]+@github\.com" -ErrorAction SilentlyContinue
            foreach ($m in $matches) {
                $remoteHits.Add([pscustomobject]@{
                    Path = $file
                    LineNumber = $m.LineNumber
                    Risk = "Embedded GitHub credential remote"
                    Note = "Line content intentionally redacted. Open .git/config locally to inspect."
                })
            }
        } catch {}
    }

$remoteHits | Export-Csv $remoteOut -NoTypeInformation -Encoding utf8

$summary = Join-Path (Split-Path $OutputRoot -Parent) "00_SECURITY_PRECHECK.md"

@"
# Security Precheck

Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Checked by: Josh

## Scans run

- risky filename scan
- token string scan
- git config credential scan

## Output files

- raw-inventory/risky-files.csv
- raw-inventory/token-string-hits.csv
- raw-inventory/embedded-credential-remotes.csv

## Manual review required

Open the CSV files locally before uploading anything to AI.

If a file contains a real secret:
1. Rotate/revoke the secret.
2. Remove it from working files.
3. Consider removing it from Git history if it was committed.
4. Replace any copied output with [REDACTED_SECRET].

## Risks found

Fill this in after manual review.

## Fixed / removed / redacted

Fill this in after manual review.

## Still unsafe

Fill this in after manual review.

## Repos excluded from Fable for now

Fill this in after manual review.

## Notes

Token line contents were intentionally not exported, so secrets are not copied into the scan output.
"@ | Set-Content $summary -Encoding UTF8

Write-Host "Security precheck complete." -ForegroundColor Green
Write-Host "Review: $OutputRoot" -ForegroundColor Yellow
'@

# ------------------------------------------------------------
# 03_inventory_local_git.ps1
# ------------------------------------------------------------
Write-FileUtf8 -Path (Join-Path $KitHelpers "03_inventory_local_git.ps1") -Content @'
param(
    [string]$DevRoot = "C:\dev",
    [string]$OutputRoot = "C:\dev\joshos-atlas\joshos-atlas-prep\joshos-atlas-prep claude\raw-inventory"
)

New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null

function Test-SkipPath {
    param([string]$Path)
    return ($Path -match '\\node_modules\\|\\\.git\\|\\\.next\\|\\dist\\|\\build\\|\\\.venv\\|\\venv\\|\\AppData\\')
}

Write-Host "Creating local folder inventory..." -ForegroundColor Cyan

Get-ChildItem $DevRoot -Recurse -Depth 3 -Force -ErrorAction SilentlyContinue |
    Where-Object { -not (Test-SkipPath $_.FullName) } |
    Select-Object FullName, Name, Mode, LastWriteTime |
    Export-Csv (Join-Path $OutputRoot "local-folders-raw.csv") -NoTypeInformation -Encoding utf8

Write-Host "Creating Git repo status inventory..." -ForegroundColor Cyan

$gitOut = Join-Path $OutputRoot "git-status-raw.txt"
Remove-Item $gitOut -ErrorAction SilentlyContinue

Get-ChildItem $DevRoot -Directory -Force -ErrorAction SilentlyContinue | ForEach-Object {
    $repoPath = $_.FullName

    if (Test-Path (Join-Path $repoPath ".git")) {
        "==================================================" | Out-File $gitOut -Append -Encoding utf8
        "REPO: $($_.Name)" | Out-File $gitOut -Append -Encoding utf8
        "PATH: $repoPath" | Out-File $gitOut -Append -Encoding utf8
        "==================================================" | Out-File $gitOut -Append -Encoding utf8

        Push-Location $repoPath

        "REMOTE:" | Out-File $gitOut -Append -Encoding utf8
        git remote -v 2>&1 | Out-File $gitOut -Append -Encoding utf8

        "`nBRANCH:" | Out-File $gitOut -Append -Encoding utf8
        git branch --show-current 2>&1 | Out-File $gitOut -Append -Encoding utf8

        "`nSTATUS:" | Out-File $gitOut -Append -Encoding utf8
        git status --short 2>&1 | Out-File $gitOut -Append -Encoding utf8

        "`nLAST COMMIT:" | Out-File $gitOut -Append -Encoding utf8
        git log -1 --pretty=format:"%h %ad %s" --date=short 2>&1 | Out-File $gitOut -Append -Encoding utf8

        "`n" | Out-File $gitOut -Append -Encoding utf8

        Pop-Location
    }
}

Write-Host "Local/Git inventory complete." -ForegroundColor Green
Write-Host "Saved to: $OutputRoot" -ForegroundColor Yellow
'@

# ------------------------------------------------------------
# 04_export_github_metadata.ps1
# ------------------------------------------------------------
Write-FileUtf8 -Path (Join-Path $KitHelpers "04_export_github_metadata.ps1") -Content @'
param(
    [string]$OutputRoot = "C:\dev\joshos-atlas\joshos-atlas-prep\joshos-atlas-prep claude\raw-inventory"
)

New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "GitHub CLI not found. Skipping GitHub metadata export." -ForegroundColor Yellow
    Write-Host "Install later from: https://cli.github.com/" -ForegroundColor Yellow
    exit 0
}

Write-Host "Checking GitHub CLI auth status..." -ForegroundColor Cyan
gh auth status

$accounts = @("joshualparris", "joshuaparris-max", "joshparri")

foreach ($account in $accounts) {
    $outFile = Join-Path $OutputRoot "github-repos-$account.json"
    Write-Host "Exporting repos for $account..." -ForegroundColor Cyan

    gh repo list $account --limit 200 --json name,nameWithOwner,url,visibility,description,isPrivate,updatedAt,pushedAt,primaryLanguage 2>&1 |
        Out-File $outFile -Encoding utf8
}

Write-Host "GitHub metadata export complete." -ForegroundColor Green
'@

# ------------------------------------------------------------
# 05_copy_pdf_link_kit_to_targets.ps1
# ------------------------------------------------------------
Write-FileUtf8 -Path (Join-Path $KitHelpers "05_copy_pdf_link_kit_to_targets.ps1") -Content @'
param(
    [string]$KitBase = "C:\dev\joshos-atlas\joshos-atlas-pdf-download-kit\joshos-atlas-pdf-download-kit",
    [string[]]$Targets = @(
        "C:\dev\joshos-atlas\chatgpt\joshos-atlas-prep",
        "C:\dev\joshos-atlas\joshos-atlas-prep\joshos-atlas-prep claude"
    )
)

if (-not (Test-Path $KitBase)) {
    Write-Host "Kit base not found: $KitBase" -ForegroundColor Red
    exit 1
}

$filesToCopy = @(
    "PDF_LINKS.csv",
    "PDF_LINKS.md",
    "PDF_LINKS.html",
    "SOURCE_REGISTER_PDF_ROWS.csv",
    "REPO_LINKS.md",
    "GMAIL_PDF_ATTACHMENTS.md"
)

foreach ($target in $Targets) {
    $dest = Join-Path $target "pdf-download-kit"
    New-Item -ItemType Directory -Force -Path $dest | Out-Null

    foreach ($file in $filesToCopy) {
        $src = Join-Path $KitBase $file
        if (Test-Path $src) {
            Copy-Item $src -Destination (Join-Path $dest $file) -Force
            Write-Host "Copied $file to $dest" -ForegroundColor Green
        } else {
            Write-Host "Missing $src" -ForegroundColor Yellow
        }
    }
}

Write-Host "PDF link kit copy complete." -ForegroundColor Green
'@

# ------------------------------------------------------------
# 06_open_drive_links_in_browser.ps1
# ------------------------------------------------------------
Write-FileUtf8 -Path (Join-Path $KitHelpers "06_open_drive_links_in_browser.ps1") -Content @'
param(
    [string]$CsvPath = "C:\dev\joshos-atlas\joshos-atlas-pdf-download-kit\joshos-atlas-pdf-download-kit\PDF_LINKS.csv",
    [string]$FilterIncludeNow = "yes",
    [int]$Max = 20,
    [int]$DelayMs = 700
)

if (-not (Test-Path $CsvPath)) {
    Write-Host "CSV not found: $CsvPath" -ForegroundColor Red
    exit 1
}

$rows = Import-Csv $CsvPath

function Get-FirstValue {
    param($Row, [string[]]$Names)
    foreach ($name in $Names) {
        if ($Row.PSObject.Properties.Name -contains $name) {
            $value = $Row.$name
            if ($value -and $value.Trim().Length -gt 0) { return $value.Trim() }
        }
    }
    return $null
}

$selected = @()

foreach ($row in $rows) {
    $include = Get-FirstValue $row @("include_now","IncludeNow","include","Include")
    $url = Get-FirstValue $row @("drive_url","url","DriveUrl","GoogleDriveUrl","view_url","webViewLink","direct_download_url")

    if (-not $url) { continue }

    if ($FilterIncludeNow -eq "all" -or -not $include -or $include.ToLower() -eq $FilterIncludeNow.ToLower()) {
        $selected += $url
    }
}

$selected = $selected | Select-Object -First $Max

Write-Host "Opening $($selected.Count) Drive links in your browser..." -ForegroundColor Cyan
Write-Host "Using your signed-in browser session is safer than command-line downloading for private Drive files." -ForegroundColor Yellow

foreach ($url in $selected) {
    Start-Process $url
    Start-Sleep -Milliseconds $DelayMs
}
'@

# ------------------------------------------------------------
# 07_audit_joshos_folder_structure.ps1
# ------------------------------------------------------------
Write-FileUtf8 -Path (Join-Path $KitHelpers "07_audit_joshos_folder_structure.ps1") -Content @'
param(
    [string]$Base = "C:\dev\joshos-atlas",
    [string]$OutputRoot = "C:\dev\joshos-atlas\joshos-atlas-prep\joshos-atlas-prep claude\raw-inventory"
)

New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$auditFile = Join-Path $OutputRoot "joshos-folder-audit-$stamp.txt"
$csvFile = Join-Path $OutputRoot "joshos-folder-audit-$stamp.csv"

"JoshOS Atlas Folder Audit" | Out-File $auditFile -Encoding utf8
"Generated: $(Get-Date)" | Out-File $auditFile -Append -Encoding utf8
"Base: $Base" | Out-File $auditFile -Append -Encoding utf8
"" | Out-File $auditFile -Append -Encoding utf8

$importantPaths = @(
    $Base,
    "C:\dev\joshos-atlas\chatgpt\joshos-atlas-prep",
    "C:\dev\joshos-atlas\joshos-atlas-prep\joshos-atlas-prep claude",
    "C:\dev\joshos-atlas\joshos-atlas-pdf-download-kit",
    "C:\dev\joshos-atlas\joshos-atlas-pdf-download-kit\joshos-atlas-pdf-download-kit",
    "C:\dev\joshos-atlas\joshos-atlas-pdf-download-kit\joshos-atlas-pdf-download-kit\download-helpers"
)

"IMPORTANT PATHS" | Out-File $auditFile -Append -Encoding utf8
foreach ($p in $importantPaths) {
    "$p : Exists=$((Test-Path $p))" | Out-File $auditFile -Append -Encoding utf8
}

"" | Out-File $auditFile -Append -Encoding utf8
"TREE SNAPSHOT" | Out-File $auditFile -Append -Encoding utf8

if (Test-Path $Base) {
    Get-ChildItem $Base -Recurse -Depth 5 -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notmatch '\\node_modules\\|\\\.git\\objects\\|\\\.next\\|\\dist\\|\\build\\' } |
        Select-Object FullName, Name, Mode, Length, LastWriteTime |
        Tee-Object -Variable items |
        Format-Table -AutoSize |
        Out-String -Width 240 |
        Out-File $auditFile -Append -Encoding utf8

    $items | Export-Csv $csvFile -NoTypeInformation -Encoding utf8
} else {
    "Base path does not exist." | Out-File $auditFile -Append -Encoding utf8
}

Write-Host "Audit saved:" -ForegroundColor Green
Write-Host $auditFile
Write-Host $csvFile
'@

# ------------------------------------------------------------
# 08_run_all_safe_prep.ps1
# ------------------------------------------------------------
Write-FileUtf8 -Path (Join-Path $KitHelpers "08_run_all_safe_prep.ps1") -Content @'
$ErrorActionPreference = "Continue"

$Base = "C:\dev\joshos-atlas"
$KitBase = Join-Path $Base "joshos-atlas-pdf-download-kit\joshos-atlas-pdf-download-kit"
$KitHelpers = Join-Path $KitBase "download-helpers"
$ClaudePrep = Join-Path $Base "joshos-atlas-prep\joshos-atlas-prep claude"
$OutputRoot = Join-Path $ClaudePrep "raw-inventory"

Write-Host "=== JoshOS Atlas Safe Prep Runner ===" -ForegroundColor Cyan
Write-Host "This creates folders and read-only audit outputs. It does not modify repos." -ForegroundColor Yellow

& (Join-Path $KitHelpers "01_create_joshos_prep_folders.ps1")
& (Join-Path $KitHelpers "05_copy_pdf_link_kit_to_targets.ps1")
& (Join-Path $KitHelpers "07_audit_joshos_folder_structure.ps1")
& (Join-Path $KitHelpers "02_security_precheck.ps1")
& (Join-Path $KitHelpers "03_inventory_local_git.ps1")
& (Join-Path $KitHelpers "04_export_github_metadata.ps1")

Write-Host ""
Write-Host "Safe prep completed." -ForegroundColor Green
Write-Host "Review these files before uploading anything to AI:" -ForegroundColor Yellow
Write-Host (Join-Path $OutputRoot "risky-files.csv")
Write-Host (Join-Path $OutputRoot "token-string-hits.csv")
Write-Host (Join-Path $OutputRoot "embedded-credential-remotes.csv")
Write-Host (Join-Path $OutputRoot "git-status-raw.txt")
Write-Host (Join-Path $OutputRoot "local-folders-raw.csv")
Write-Host ""
Write-Host "To open Drive PDF links in browser later, run:" -ForegroundColor Cyan
Write-Host "powershell -ExecutionPolicy Bypass -File `"$KitHelpers\06_open_drive_links_in_browser.ps1`" -FilterIncludeNow yes -Max 20"
'@

# ------------------------------------------------------------
# RUN_ORDER.md
# ------------------------------------------------------------
Write-FileUtf8 -Path (Join-Path $KitHelpers "RUN_ORDER.md") -Content @'
# JoshOS Atlas Download Helper Run Order

Run this first:

powershell -ExecutionPolicy Bypass -File "C:\dev\joshos-atlas\joshos-atlas-pdf-download-kit\joshos-atlas-pdf-download-kit\download-helpers\08_run_all_safe_prep.ps1"
