# JoshOS Atlas PDF Download Kit

This kit contains links and helper scripts for downloading/organising JoshOS Atlas source PDFs.

## Target folders

- `C:\dev\joshos-atlas\chatgpt\joshos-atlas-prep`
- `C:\dev\joshos-atlas\joshos-atlas-prep\joshos-atlas-prep claude`

## Contents

- `PDF_LINKS.csv` — main list of Drive PDF links
- `PDF_LINKS.md` — readable version with notes
- `PDF_LINKS.html` — clickable local HTML page
- `REPO_LINKS.md` — repo links for JoshOS Atlas source pack
- `GMAIL_PDF_ATTACHMENTS.md` — Gmail attachments that need manual download
- `download-helpers/00_create_targets_and_copy_link_kit.ps1`
- `download-helpers/01_open_drive_links_in_browser.ps1`
- `download-helpers/02_try_direct_download_to_targets.ps1`

## Recommended use

1. Extract this ZIP anywhere, e.g. `Downloads`.
2. Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\download-helpers\00_create_targets_and_copy_link_kit.ps1
```

3. Open core Drive links in your browser:

```powershell
powershell -ExecutionPolicy Bypass -File .\download-helpers\01_open_drive_links_in_browser.ps1 -FilterIncludeNow yes
```

4. For each PDF that opens in Drive, click Download and save it into the matching `pdfs\...` subfolder under both target folders.

## Why direct download may fail

Most of these are private Google Drive files. PowerShell `Invoke-WebRequest` usually cannot access them unless the file is publicly shared. The browser opener is more reliable because it uses your signed-in Google session.

## Privacy warning

Do not upload raw private-high or local-only files to Fable/Claude unless you intentionally approve it. Use source cards for child, health, tenancy, work/school, and family material.
