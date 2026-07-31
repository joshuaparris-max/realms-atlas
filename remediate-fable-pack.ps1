# JoshOS Atlas - Fable Pack Remediation Script
# Purpose:
# 1. Move private-high / forbidden PDFs out of the safe upload path.
# 2. Rebuild a clean Claude/Fable upload pack from a whitelist.
# 3. Fix private-high include_now gating in 04_SOURCE_REGISTER.csv.
# 4. Create minimum approved-for-fable cards.
# 5. Leave security precheck for manual sign-off.

$ErrorActionPreference = "Continue"

$Base = "C:\dev\joshos-atlas"
$Canonical = Join-Path $Base "joshos-atlas-prep\joshos-atlas-prep claude"
$ChatGPTTree = Join-Path $Base "chatgpt\joshos-atlas-prep"

$OldSafePackFolder = Join-Path $Base "claude-project-upload-safe-pack"
$OldSafeZip = Join-Path $Base "claude-project-upload-safe-pack.zip"

$CleanPackFolder = Join-Path $Base "claude-project-upload-clean-pack"
$CleanZip = Join-Path $Base "claude-project-upload-clean-pack.zip"

$SourcePdfs = Join-Path $Canonical "source-pdfs"
$SourceDocs = Join-Path $Canonical "source-docs"
$PrivateReview = Join-Path $Canonical "excluded-private\source-pdfs-private-review"
$RawInventory = Join-Path $Canonical "raw-inventory"
$Approved = Join-Path $Canonical "approved-for-fable"

$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$Quarantine = Join-Path $Canonical "excluded-private\quarantined-from-safe-pack-$Stamp"

$LogFile = Join-Path $Canonical "FABLE_PACK_REMEDIATION_LOG_$Stamp.txt"

New-Item -ItemType Directory -Force -Path $Canonical | Out-Null
New-Item -ItemType Directory -Force -Path $SourcePdfs | Out-Null
New-Item -ItemType Directory -Force -Path $SourceDocs | Out-Null
New-Item -ItemType Directory -Force -Path $PrivateReview | Out-Null
New-Item -ItemType Directory -Force -Path $RawInventory | Out-Null
New-Item -ItemType Directory -Force -Path $Approved | Out-Null
New-Item -ItemType Directory -Force -Path $Quarantine | Out-Null

function Log {
    param([string]$Message)
    $line = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  $Message"
    Write-Host $line
    $line | Out-File $LogFile -Append -Encoding utf8
}

function Move-IfExists {
    param(
        [string]$Path,
        [string]$DestinationFolder
    )

    if (Test-Path $Path) {
        New-Item -ItemType Directory -Force -Path $DestinationFolder | Out-Null
        $dest = Join-Path $DestinationFolder (Split-Path $Path -Leaf)

        if (Test-Path $dest) {
            $name = [System.IO.Path]::GetFileNameWithoutExtension($Path)
            $ext = [System.IO.Path]::GetExtension($Path)
            $dest = Join-Path $DestinationFolder "$name-$Stamp$ext"
        }

        Move-Item -Path $Path -Destination $dest -Force
        Log "MOVED: $Path -> $dest"
    }
}

Log "=== JoshOS Atlas Fable Pack Remediation Started ==="
Log "Canonical folder: $Canonical"
Log "Clean pack target: $CleanPackFolder"
Log "Clean zip target: $CleanZip"

# -------------------------------------------------------------------
# 1. Move forbidden/private-high PDFs out of source-pdfs into private review.
# -------------------------------------------------------------------

Log "Step 1: Moving forbidden/private-high PDFs out of source-pdfs..."

$ForbiddenPatterns = @(
    "NDIS",
    "Sylvie Combined NDIS",
    "Sylvie_Family_Report",
    "Family_Report",
    "Search results.*Mail",
    "Mould_Escalation",
    "101_Boundary_Road",
    "sylvie_child_privacy",
    "elias_child_privacy",
    "family_public_information_threat_model",
    "joshua_parris_public_osint",
    "Joshua_Parris_OSINT",
    "Screen_Related_Blurry_Vision",
    "HeartBug",
    "JoshHealth",
    "Josh_____P",
    "Operational Dossier",
    "OG Josh",
    "health",
    "Health"
)

if (Test-Path $SourcePdfs) {
    Get-ChildItem $SourcePdfs -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
        $file = $_
        foreach ($pattern in $ForbiddenPatterns) {
            if ($file.Name -match $pattern) {
                Move-IfExists -Path $file.FullName -DestinationFolder $PrivateReview
                break
            }
        }
    }
}

# -------------------------------------------------------------------
# 2. Quarantine unsafe binaries and nested zips from old safe pack if present.
# -------------------------------------------------------------------

Log "Step 2: Quarantining nested zips, installers, and forbidden files from old safe pack if present..."

if (Test-Path $OldSafePackFolder) {
    Get-ChildItem $OldSafePackFolder -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
        $file = $_
        $name = $file.Name

        $isUnsafe = $false

        if ($name -match "\.zip$") { $isUnsafe = $true }
        if ($name -match "\.exe$") { $isUnsafe = $true }
        if ($name -match "Claude Setup") { $isUnsafe = $true }

        foreach ($pattern in $ForbiddenPatterns) {
            if ($name -match $pattern) { $isUnsafe = $true }
        }

        if ($isUnsafe) {
            Move-IfExists -Path $file.FullName -DestinationFolder $Quarantine
        }
    }
} else {
    Log "Old safe pack folder not found. Skipping old-pack quarantine."
}

# -------------------------------------------------------------------
# 3. Fix source register gating: private-high rows become include_now no.
# -------------------------------------------------------------------

Log "Step 3: Fixing 04_SOURCE_REGISTER.csv gating..."

$RegisterPath = Join-Path $Canonical "04_SOURCE_REGISTER.csv"

if (Test-Path $RegisterPath) {
    $rows = Import-Csv $RegisterPath

    foreach ($row in $rows) {
        $props = $row.PSObject.Properties.Name

        if ($props -contains "sensitivity") {
            if ($row.sensitivity -eq "private-high" -or $row.sensitivity -eq "local-only") {
                if ($props -contains "include_now") { $row.include_now = "no" }
                if ($props -contains "include_later") { $row.include_later = "yes" }
                if ($props -contains "notes") {
                    if ($row.notes -notmatch "Fable gated") {
                        $row.notes = ($row.notes + " | Fable gated: source-card summary only, no raw upload").Trim(" |")
                    }
                }
            }
        }

        if (($props -contains "source_type") -and ($props -contains "location_or_url") -and ($props -contains "confidence")) {
            if ($row.source_type -eq "repo" -and ($null -eq $row.location_or_url -or $row.location_or_url.Trim() -eq "" -or $row.location_or_url -notmatch "^https?://")) {
                $row.confidence = "low"
            }
        }
    }

    $BackupRegister = Join-Path $Canonical "04_SOURCE_REGISTER.backup-$Stamp.csv"
    Copy-Item $RegisterPath $BackupRegister -Force
    $rows | Export-Csv $RegisterPath -NoTypeInformation -Encoding utf8
    Log "Updated register: $RegisterPath"
    Log "Backup register: $BackupRegister"
} else {
    Log "WARNING: 04_SOURCE_REGISTER.csv not found."
}

# -------------------------------------------------------------------
# 4. Create minimum approved-for-fable cards.
# -------------------------------------------------------------------

Log "Step 4: Creating minimum approved-for-fable cards..."

$ApprovedReadme = Join-Path $Approved "README_APPROVED_FOR_FABLE.md"
@(
    "# Approved for Fable",
    "",
    "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    "",
    "This folder contains source-card summaries and action cards that are safer to provide to Fable than raw private-high files.",
    "",
    "Rules:",
    "- Do not include raw child, NDIS, health, tenancy/legal, school/student/staff, financial, or family-private contents.",
    "- Use source IDs and filenames as evidence pointers.",
    "- Mark uncertain facts LOW CONFIDENCE.",
    "- Private-high source rows are allowed only as metadata or rules-only cards.",
    "- Raw private-high PDFs remain in excluded-private/source-pdfs-private-review."
) | Set-Content $ApprovedReadme -Encoding utf8

$PrivacyCards = Join-Path $Approved "privacy-rules-cards.md"
@(
    "# Privacy Rules Cards",
    "",
    "## privacy_rules_001 - Private-high raw files must not enter Fable",
    "",
    "Source type: rules-only card",
    "Sensitivity: private-high",
    "Confidence: high",
    "",
    "Source says:",
    "- Child, NDIS, health, tenancy/legal, school/student/staff, financial, family-private, and OSINT/privacy files must not be raw-uploaded to Fable.",
    "",
    "Interpretation:",
    "- These files may be represented by source IDs, filenames, and rules-only summaries.",
    "- Fable may reason about privacy process and risk classes, but not raw contents.",
    "",
    "Recommended action:",
    "- Keep raw files in excluded-private/source-pdfs-private-review.",
    "- Create source cards that describe only safe metadata, risk class, and allowed handling.",
    "",
    "Affected source examples:",
    "- family_public_information_threat_model.pdf",
    "- joshua_parris_public_osint_audit.pdf",
    "- Joshua_Parris_OSINT_Audit.pdf",
    "- sylvie_child_privacy_osint_audit.pdf",
    "- elias_child_privacy_osint_audit.pdf",
    "- NDIS/Sylvie reports",
    "- Mould/tenancy/legal report",
    "",
    "Fable allowed use:",
    "- Use these sources to create privacy rules, gating decisions, and rename/privatise recommendations.",
    "",
    "Fable forbidden use:",
    "- Do not summarise personal contents.",
    "- Do not quote private details.",
    "- Do not generate public seed data from these files."
) | Set-Content $PrivacyCards -Encoding utf8

$ActionCards = Join-Path $Approved "open-action-cards-minimum.md"
@(
    "# Minimum Open Action Cards",
    "",
    "## action_001 - Rebuild clean Claude/Fable upload pack",
    "",
    "Priority: P0",
    "Owner: Josh",
    "Status: in-progress",
    "Timeframe: before Fable run",
    "Source IDs: fable_audit, privacy_boundaries, source_register",
    "",
    "Why this matters:",
    "- The earlier safe pack contained private-high/local-only files.",
    "",
    "Concrete next step:",
    "- Upload only claude-project-upload-clean-pack.zip.",
    "- Remove old unsafe uploads from Claude Project.",
    "",
    "## action_002 - Complete security precheck manual sign-off",
    "",
    "Priority: P0",
    "Owner: Josh",
    "Status: open",
    "Timeframe: before Fable run",
    "Source IDs: 00_SECURITY_PRECHECK.md, token-string-hits.csv, risky-files.csv",
    "",
    "Why this matters:",
    "- Token/path scans found hits that need human classification.",
    "",
    "Concrete next step:",
    "- Review token-string-hits.csv and risky-files.csv locally.",
    "- Do not upload those CSVs raw.",
    "- Fill in 00_SECURITY_PRECHECK.md.",
    "",
    "## action_003 - Keep private-high source rows gated",
    "",
    "Priority: P1",
    "Owner: Josh",
    "Status: open",
    "Timeframe: before Fable run",
    "Source IDs: 04_SOURCE_REGISTER.csv",
    "",
    "Why this matters:",
    "- Fable can know that private-high sources exist without receiving raw contents.",
    "",
    "Concrete next step:",
    "- Verify all private-high rows have include_now=no and include_later=yes.",
    "",
    "## action_004 - Use source cards instead of raw private files",
    "",
    "Priority: P1",
    "Owner: Josh",
    "Status: open",
    "Timeframe: before Fable run",
    "Source IDs: approved-for-fable/privacy-rules-cards.md",
    "",
    "Why this matters:",
    "- This keeps privacy rules useful while protecting the raw data.",
    "",
    "Concrete next step:",
    "- Upload approved-for-fable cards, not excluded-private raw files.",
    "",
    "## action_005 - Remove old unsafe Claude Project uploads",
    "",
    "Priority: P0",
    "Owner: Josh",
    "Status: manual-required",
    "Timeframe: immediately",
    "Source IDs: fable_audit",
    "",
    "Why this matters:",
    "- Claude Project already saw the old unsafe pack according to Fable.",
    "",
    "Concrete next step:",
    "- In Claude Project, delete old uploaded unsafe ZIP/files.",
    "- Upload the new clean ZIP only."
) | Set-Content $ActionCards -Encoding utf8

# -------------------------------------------------------------------
# 5. Create security precheck manual review worksheet.
# -------------------------------------------------------------------

Log "Step 5: Creating manual security review worksheet..."

$SecurityWorksheet = Join-Path $Canonical "SECURITY_PRECHECK_MANUAL_REVIEW_REQUIRED.md"
@(
    "# Security Precheck Manual Review Required",
    "",
    "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    "",
    "Do not run full Fable until this is completed by Josh.",
    "",
    "## Files to review locally",
    "",
    "- raw-inventory/risky-files.csv",
    "- raw-inventory/token-string-hits.csv",
    "- raw-inventory/embedded-credential-remotes.csv",
    "",
    "## How to classify each hit",
    "",
    "Use one of:",
    "- real-secret-rotated",
    "- false-positive",
    "- example-only",
    "- deleted",
    "- excluded-from-fable",
    "- needs-more-work",
    "",
    "## Sign-off checklist",
    "",
    "- [ ] I reviewed risky-files.csv",
    "- [ ] I reviewed token-string-hits.csv",
    "- [ ] I confirmed embedded-credential-remotes.csv is empty or handled",
    "- [ ] I rotated any real keys/tokens",
    "- [ ] I removed or excluded unsafe files from upload packs",
    "- [ ] I did not upload raw token/path scan CSVs to Fable",
    "- [ ] I updated 00_SECURITY_PRECHECK.md with results",
    "",
    "## Result",
    "",
    "Security precheck status: NOT SIGNED YET"
) | Set-Content $SecurityWorksheet -Encoding utf8

# -------------------------------------------------------------------
# 6. Rebuild clean pack from whitelist only.
# -------------------------------------------------------------------

Log "Step 6: Rebuilding clean Claude/Fable upload pack from whitelist..."

if (Test-Path $CleanPackFolder) {
    Remove-Item $CleanPackFolder -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $CleanPackFolder | Out-Null

$CoreFiles = @(
    "00_SECURITY_PRECHECK.md",
    "SECURITY_PRECHECK_MANUAL_REVIEW_REQUIRED.md",
    "01_PERSONAL_CONTEXT.md",
    "02_PRIVACY_BOUNDARIES.md",
    "03_CANONICAL_GOALS.md",
    "04_SOURCE_REGISTER.csv",
    "05_SEED_DATA_FORMAT.md",
    "06_FABLE_SESSION.md",
    "06_FABLE_PROMPT.md"
)

foreach ($file in $CoreFiles) {
    $src = Join-Path $Canonical $file
    if (Test-Path $src) {
        Copy-Item $src -Destination (Join-Path $CleanPackFolder $file) -Force
        Log "Copied core file: $file"
    }
}

$WhitelistedFolders = @(
    "source-cards",
    "architecture-draft",
    "approved-for-fable",
    "download-launcher",
    "source-docs"
)

foreach ($folder in $WhitelistedFolders) {
    $src = Join-Path $Canonical $folder
    $dest = Join-Path $CleanPackFolder $folder

    if (Test-Path $src) {
        Copy-Item $src -Destination $dest -Recurse -Force
        Log "Copied folder: $folder"
    }
}

# Copy cleaned source-pdfs, but exclude private-high patterns, zips, and installers.
$CleanPdfsDest = Join-Path $CleanPackFolder "source-pdfs"
New-Item -ItemType Directory -Force -Path $CleanPdfsDest | Out-Null

if (Test-Path $SourcePdfs) {
    Get-ChildItem $SourcePdfs -File -ErrorAction SilentlyContinue | ForEach-Object {
        $file = $_
        $exclude = $false

        if ($file.Name -match "\.zip$") { $exclude = $true }
        if ($file.Name -match "\.exe$") { $exclude = $true }

        foreach ($pattern in $ForbiddenPatterns) {
            if ($file.Name -match $pattern) { $exclude = $true }
        }

        if (-not $exclude) {
            Copy-Item $file.FullName -Destination (Join-Path $CleanPdfsDest $file.Name) -Force
            Log "Copied safe source PDF: $($file.Name)"
        } else {
            Log "Excluded source PDF from clean pack: $($file.Name)"
        }
    }
}

# Copy only safe raw-inventory files. Never copy token/risky scan CSVs.
$CleanRawDest = Join-Path $CleanPackFolder "raw-inventory"
New-Item -ItemType Directory -Force -Path $CleanRawDest | Out-Null

$SafeRawPatterns = @(
    "github-repos-*.json",
    "local-folders-raw.csv",
    "git-status-raw.txt",
    "joshos-folder-audit-*.csv",
    "joshos-folder-audit-*.txt",
    "github-cli-not-installed.txt"
)

foreach ($pattern in $SafeRawPatterns) {
    Get-ChildItem $RawInventory -Filter $pattern -ErrorAction SilentlyContinue | ForEach-Object {
        Copy-Item $_.FullName -Destination (Join-Path $CleanRawDest $_.Name) -Force
        Log "Copied safe raw-inventory: $($_.Name)"
    }
}

# Add upload readme.
$UploadReadme = Join-Path $CleanPackFolder "UPLOAD_README.md"
@(
    "# JoshOS Atlas - Clean Claude/Fable Upload Pack",
    "",
    "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    "",
    "Upload this clean ZIP to Claude Project only after deleting old unsafe uploads.",
    "",
    "Included:",
    "- planning files",
    "- privacy boundaries",
    "- source register with private-high rows gated",
    "- source cards and approved-for-fable cards",
    "- architecture draft",
    "- safe raw inventory files",
    "- low/medium project source PDFs/docs only",
    "",
    "Excluded:",
    "- excluded-private/",
    "- child/NDIS/health/tenancy/legal raw PDFs",
    "- OSINT/private-high raw PDFs",
    "- token-string-hits.csv",
    "- risky-files.csv",
    "- embedded-credential-remotes.csv",
    "- .env files",
    "- API keys/tokens/secrets",
    "- nested zip files",
    "- installers/exe files",
    "",
    "Manual requirement:",
    "- Complete SECURITY_PRECHECK_MANUAL_REVIEW_REQUIRED.md before full Fable architecture/scaffold pass."
) | Set-Content $UploadReadme -Encoding utf8

# Remove any accidental unsafe files from clean pack.
Log "Step 7: Final scan of clean pack for forbidden patterns..."

Get-ChildItem $CleanPackFolder -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
    $file = $_
    $exclude = $false

    if ($file.Name -match "\.zip$") { $exclude = $true }
    if ($file.Name -match "\.exe$") { $exclude = $true }
    if ($file.Name -in @("token-string-hits.csv","risky-files.csv","embedded-credential-remotes.csv")) { $exclude = $true }

    foreach ($pattern in $ForbiddenPatterns) {
        if ($file.Name -match $pattern) { $exclude = $true }
    }

    if ($exclude) {
        Move-IfExists -Path $file.FullName -DestinationFolder $Quarantine
        Log "Removed accidental unsafe file from clean pack: $($file.Name)"
    }
}

# Create clean zip.
if (Test-Path $CleanZip) {
    Remove-Item $CleanZip -Force
}

Compress-Archive -Path (Join-Path $CleanPackFolder "*") -DestinationPath $CleanZip -Force

Log "=== Remediation Complete ==="
Log "Clean pack folder: $CleanPackFolder"
Log "Clean pack zip: $CleanZip"
Log "Quarantine folder: $Quarantine"
Log "Private review folder: $PrivateReview"
Log "Manual security worksheet: $SecurityWorksheet"

Write-Host ""
Write-Host "DONE." -ForegroundColor Green
Write-Host ""
Write-Host "Clean ZIP to upload to Claude Project:" -ForegroundColor Cyan
Write-Host $CleanZip
Write-Host ""
Write-Host "Private files were moved/reviewed here:" -ForegroundColor Yellow
Write-Host $PrivateReview
Write-Host ""
Write-Host "Quarantined unsafe upload-pack files are here:" -ForegroundColor Yellow
Write-Host $Quarantine
Write-Host ""
Write-Host "Manual review still required before full Fable run:" -ForegroundColor Red
Write-Host $SecurityWorksheet
Write-Host ""