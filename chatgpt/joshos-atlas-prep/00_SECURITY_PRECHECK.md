
# Security Precheck

Date: 2026-06-10
Checked by: automation (assistant) — please review and confirm

## Scans run

- `scripts/01-risky-file-scan.ps1` — output redirected to `raw-inventory/01-risky-file-scan-output.txt`
- `scripts/02-token-string-scan.ps1` — output redirected to `raw-inventory/02-token-string-scan-output.txt`
- `scripts/03-git-config-credential-scan.ps1` — attempted; output redirected to `raw-inventory/03-git-config-credential-scan-output.txt`

## Findings (summary)

- Risky filename scan: the script ran and reported it saved a risky-file list, but the expected `risky-files.csv` was not present under the workspace `raw-inventory/` path I inspected. A binary/encoded fragment was captured in `01-risky-file-scan-output.txt` indicating the script attempted to save `risky-files.csv`.
- Token/string scan: the redirected output file `02-token-string-scan-output.txt` is present but empty.
- Git config / credential scan: no readable output file was produced at `raw-inventory/03-git-config-credential-scan-output.txt` when inspected; the script may write to a different path or require elevated permissions.

## Actions taken

- Executed the three precheck scripts and saved redirected outputs to `raw-inventory/` for review.
- Created draft source cards from `04_SOURCE_REGISTER.csv` (see `source-cards/generated-source-cards.md`).

## Recommended immediate next steps (24–48h)

1. Manually open and inspect `raw-inventory/01-risky-file-scan-output.txt` for the saved `risky-files.csv` path and find that CSV (it may be in a sibling folder or root — search the machine for `risky-files.csv`).
2. If `risky-files.csv` is found, review filenames for any PBIs (personal, banking, keys, tokens, child/health docs) and either redact or move them to `excluded-private/` before any AI upload.
3. If `02-token-string-scan-output.txt` remains empty, run the token scan interactively (no redirection) to inspect any interactive prompts or errors the script might produce.
4. Re-run `03-git-config-credential-scan.ps1` with `2>&1` redirected to capture stderr if it previously failed to write output. Example command to run locally (PowerShell):

```powershell
powershell -ExecutionPolicy Bypass -File C:\dev\joshos-atlas\chatgpt\joshos-atlas-prep\scripts\03-git-config-credential-scan.ps1 2>&1 | Tee-Object C:\dev\joshos-atlas\chatgpt\joshos-atlas-prep\raw-inventory\03-git-config-credential-scan-output.txt
```

5. Do not move any `private-high` items into `approved-for-fable/` until they are redacted and quality-checked.

## Risks found (placeholder)

- At this stage, I have not discovered an explicit exposed token in the captured outputs, but the `risky-files.csv` location must be found and inspected before declaring the pack safe. Treat all `private-high` entries as not approved until redacted.

## Fixed / removed / redacted

- None yet — awaiting review of `risky-files.csv` and token-scan output.

## Still unsafe

- Any files flagged as `private-high` in `04_SOURCE_REGISTER.csv` (child/health/tenancy) remain unsafe until redacted or excluded.

## Repos / paths excluded from Fable for now

- See `approved-for-fable/candidates-for-approval.md` for suggested approvals; all `private-high` items must be excluded until redacted.

## Notes

Before sending any scan output to AI, review it yourself.

If any output contains a real token, replace it with:

```text
[REDACTED_SECRET]
```

If you want, I can re-run the git-config script with stderr captured, or search the machine for `risky-files.csv` and surface it here. Let me know which you'd prefer.

