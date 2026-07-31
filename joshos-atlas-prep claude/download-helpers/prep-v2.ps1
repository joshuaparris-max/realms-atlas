$ErrorActionPreference = "Continue"

$Base = "C:\dev\joshos-atlas"
$DevRoot = "C:\dev"
$ChatGPTPrep = Join-Path $Base "chatgpt\joshos-atlas-prep"
$ClaudePrep = Join-Path $Base "joshos-atlas-prep\joshos-atlas-prep claude"
$KitBase = Join-Path $Base "joshos-atlas-pdf-download-kit\joshos-atlas-pdf-download-kit"
$KitHelpers = Join-Path $KitBase "download-helpers"
$Targets = @($ChatGPTPrep, $ClaudePrep)

Write-Host "=== JoshOS Atlas Prep v2 ===" -ForegroundColor Cyan
Write-Host "Creating folders/files, then running read-only audits." -ForegroundColor Yellow

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
    if (-not (Test-Path $path)) { New-Item -ItemType File -Force -Path $path | Out-Null }
  }

  Set-Content -Path (Join-Path $target "01_PERSONAL_CONTEXT.md") -Encoding UTF8 -Value @(
    "# Personal Context",
    "",
    "I am Josh Parris, a Christian husband and dad in Dubbo, NSW. I work across IT/library support, MSP-style tech work, family systems, job/career transition, and personal app building.",
    "",
    "I have many apps, repos, deployments, documents, and ideas spread across GitHub accounts, Vercel, Google Drive, Gmail, and local folders. I need JoshOS Atlas to help me see what matters, what is broken, what is risky, and what to do next.",
    "",
    "The system must be calm, practical, private-first, and realistic for a time-poor solo developer with family responsibilities.",
    "",
    "## What success should feel like",
    "",
    "JoshOS Atlas should help me feel calmer, clearer, and less scattered. It should reduce open loops, not create another project that nags me. When it is working, I should be able to open it and quickly see what matters, what can wait, what is unsafe or broken, and the next faithful step to take."
  )

  Set-Content -Path (Join-Path $target "02_PRIVACY_BOUNDARIES.md") -Encoding UTF8 -Value @(
    "# Privacy Boundaries",
    "",
    "## Never commit to GitHub",
    "",
    "- .env files",
    "- API keys",
    "- GitHub tokens",
    "- Vercel tokens",
    "- Anthropic/OpenAI/OpenRouter/Groq keys",
    "- health records",
    "- child therapy or NDIS documents",
    "- school/student/staff data",
    "- bank statements",
    "- private family or marriage notes",
    "- tenancy evidence photos unless deliberately redacted",
    "",
    "## Local-only unless explicitly approved",
    "",
    "- health material",
    "- kids support documents",
    "- legal/tenancy documents",
    "- financial account data",
    "- family admin",
    "- private emails",
    "",
    "## AI rules",
    "",
    "- Separate source facts from interpretation.",
    "- If uncertain, mark uncertain.",
    "- Do not invent missing facts.",
    "- Do not give legal, medical, tax, financial, or investment advice as if qualified.",
    "- Every recommendation must cite source IDs.",
    "- Public deployments must use fake/sample data only."
  )

  Set-Content -Path (Join-Path $target "03_CANONICAL_GOALS.md") -Encoding UTF8 -Value @(
    "# Canonical Goals",
    "",
    "## Primary GitHub account",
    "",
    "joshualparris",
    "",
    "## Secondary GitHub account",
    "",
    "joshuaparris-max",
    "",
    "## Work-specific account",
    "",
    "joshparri",
    "",
    "## Canonical hub",
    "",
    "JoshOS Atlas / JoshHub becomes the private local-first command centre for app, repo, document, deployment, privacy-risk, and next-action tracking."
  )
}

$ClaudeRaw = Join-Path $ClaudePrep "raw-inventory"
New-Item -ItemType Directory -Force -Path $ClaudeRaw | Out-Null

Write-Host "Copying PDF link kit if present..." -ForegroundColor Cyan
$filesToCopy = @("PDF_LINKS.csv","PDF_LINKS.md","PDF_LINKS.html","SOURCE_REGISTER_PDF_ROWS.csv","REPO_LINKS.md","GMAIL_PDF_ATTACHMENTS.md")
foreach ($target in $Targets) {
  $dest = Join-Path $target "pdf-download-kit"
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  foreach ($file in $filesToCopy) {
    $src = Join-Path $KitBase $file
    if (Test-Path $src) { Copy-Item $src -Destination (Join-Path $dest $file) -Force }
  }
}

function Test-SkipPath {
  param([string]$Path)
  return ($Path -match "\\node_modules\\|\\.git\\objects\\|\\.next\\|\\dist\\|\\build\\|\\.venv\\|\\venv\\|\\AppData\\")
}

Write-Host "Security scan 1/3: risky filenames..." -ForegroundColor Cyan
$riskyNamePattern = "\\(\.env|\.env\..*|id_rsa|id_ed25519|credentials|secrets|secret|token|tokens|key|keys|firebase|supabase|vercel|openrouter|groq|anthropic|openai)(\.|$|\\)"
Get-ChildItem $DevRoot -Recurse -Force -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName -match $riskyNamePattern -and -not (Test-SkipPath $_.FullName) } |
  Select-Object FullName, Length, LastWriteTime |
  Export-Csv (Join-Path $ClaudeRaw "risky-files.csv") -NoTypeInformation -Encoding utf8

Write-Host "Security scan 2/3: token-looking strings, line contents redacted..." -ForegroundColor Cyan
$patterns = @("ghp_","github_pat_","sk-","OPENAI_API_KEY","ANTHROPIC_API_KEY","GROQ_API_KEY","OPENROUTER_API_KEY","VERCEL_TOKEN","SUPABASE_SERVICE_ROLE","FIREBASE_PRIVATE_KEY","PRIVATE_KEY","CLIENT_SECRET")
$allowedExtensions = @(".md",".txt",".json",".js",".ts",".tsx",".jsx",".env",".yml",".yaml",".toml",".config",".ps1",".sh",".html",".css")
$hits = New-Object System.Collections.Generic.List[object]
Get-ChildItem $DevRoot -Recurse -File -Force -ErrorAction SilentlyContinue |
  Where-Object {
    -not (Test-SkipPath $_.FullName) -and
    $_.Length -lt 2MB -and
    ($allowedExtensions -contains $_.Extension.ToLower() -or $_.Name -like ".env*")
  } | ForEach-Object {
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
$hits | Export-Csv (Join-Path $ClaudeRaw "token-string-hits.csv") -NoTypeInformation -Encoding utf8

Write-Host "Security scan 3/3: embedded GitHub credentials in .git/config..." -ForegroundColor Cyan
$remoteHits = New-Object System.Collections.Generic.List[object]
Get-ChildItem $DevRoot -Recurse -Force -Filter "config" -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName -match "\\.git\\config$" } |
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
$remoteHits | Export-Csv (Join-Path $ClaudeRaw "embedded-credential-remotes.csv") -NoTypeInformation -Encoding utf8

Set-Content -Path (Join-Path $ClaudePrep "00_SECURITY_PRECHECK.md") -Encoding UTF8 -Value @(
  "# Security Precheck",
  "",
  "Date: $(Get-Date -Format ""yyyy-MM-dd HH:mm:ss"")",
  "Checked by: Josh",
  "",
  "## Scans run",
  "",
  "- risky filename scan",
  "- token string scan",
  "- git config credential scan",
  "",
  "## Output files",
  "",
  "- raw-inventory/risky-files.csv",
  "- raw-inventory/token-string-hits.csv",
  "- raw-inventory/embedded-credential-remotes.csv",
  "",
  "## Manual review required",
  "",
  "Open the CSV files locally before uploading anything to AI.",
  "",
  "## Risks found",
  "",
  "Fill this in after manual review.",
  "",
  "## Fixed / removed / redacted",
  "",
  "Fill this in after manual review.",
  "",
  "## Still unsafe",
  "",
  "Fill this in after manual review.",
  "",
  "## Repos excluded from Fable for now",
  "",
  "Fill this in after manual review."
)

Write-Host "Creating local folder inventory..." -ForegroundColor Cyan
Get-ChildItem $DevRoot -Recurse -Depth 3 -Force -ErrorAction SilentlyContinue |
  Where-Object { -not (Test-SkipPath $_.FullName) } |
  Select-Object FullName, Name, Mode, LastWriteTime |
  Export-Csv (Join-Path $ClaudeRaw "local-folders-raw.csv") -NoTypeInformation -Encoding utf8

Write-Host "Creating git status inventory..." -ForegroundColor Cyan
$gitOut = Join-Path $ClaudeRaw "git-status-raw.txt"
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

Write-Host "Exporting GitHub metadata if gh exists..." -ForegroundColor Cyan
if (Get-Command gh -ErrorAction SilentlyContinue) {
  $accounts = @("joshualparris","joshuaparris-max","joshparri")
  foreach ($account in $accounts) {
    gh repo list $account --limit 200 --json name,nameWithOwner,url,visibility,description,isPrivate,updatedAt,pushedAt,primaryLanguage 2>&1 |
      Out-File (Join-Path $ClaudeRaw "github-repos-$account.json") -Encoding utf8
  }
} else {
  "GitHub CLI not installed. Install later from https://cli.github.com/" | Out-File (Join-Path $ClaudeRaw "github-cli-not-installed.txt") -Encoding utf8
}

Write-Host "Creating JoshOS folder audit..." -ForegroundColor Cyan
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$auditTxt = Join-Path $ClaudeRaw "joshos-folder-audit-$stamp.txt"
$auditCsv = Join-Path $ClaudeRaw "joshos-folder-audit-$stamp.csv"
$items = Get-ChildItem $Base -Recurse -Depth 5 -Force -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName -notmatch "\\node_modules\\|\\.git\\objects\\|\\.next\\|\\dist\\|\\build\\" } |
  Select-Object FullName, Name, Mode, Length, LastWriteTime
$items | Export-Csv $auditCsv -NoTypeInformation -Encoding utf8
$items | Format-Table -AutoSize | Out-String -Width 240 | Out-File $auditTxt -Encoding utf8

Write-Host ""
Write-Host "DONE." -ForegroundColor Green
Write-Host "Review this folder before uploading anything to AI:" -ForegroundColor Yellow
Write-Host $ClaudeRaw
Write-Host ""
Write-Host "Important files to review:" -ForegroundColor Yellow
Write-Host (Join-Path $ClaudeRaw "risky-files.csv")
Write-Host (Join-Path $ClaudeRaw "token-string-hits.csv")
Write-Host (Join-Path $ClaudeRaw "embedded-credential-remotes.csv")
Write-Host (Join-Path $ClaudeRaw "git-status-raw.txt")
Write-Host (Join-Path $ClaudeRaw "local-folders-raw.csv")
Write-Host ""
Write-Host "To open PDF links later, open this file in browser if present:" -ForegroundColor Cyan
Write-Host (Join-Path $KitBase "PDF_LINKS.html")
