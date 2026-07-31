# Minimum Open Action Cards

## action_001 - Rebuild clean Claude/Fable upload pack

Priority: P0
Owner: Josh
Status: in-progress
Timeframe: before Fable run
Source IDs: fable_audit, privacy_boundaries, source_register

Why this matters:
- The earlier safe pack contained private-high/local-only files.

Concrete next step:
- Upload only claude-project-upload-clean-pack.zip.
- Remove old unsafe uploads from Claude Project.

## action_002 - Complete security precheck manual sign-off

Priority: P0
Owner: Josh
Status: open
Timeframe: before Fable run
Source IDs: 00_SECURITY_PRECHECK.md, token-string-hits.csv, risky-files.csv

Why this matters:
- Token/path scans found hits that need human classification.

Concrete next step:
- Review token-string-hits.csv and risky-files.csv locally.
- Do not upload those CSVs raw.
- Fill in 00_SECURITY_PRECHECK.md.

## action_003 - Keep private-high source rows gated

Priority: P1
Owner: Josh
Status: open
Timeframe: before Fable run
Source IDs: 04_SOURCE_REGISTER.csv

Why this matters:
- Fable can know that private-high sources exist without receiving raw contents.

Concrete next step:
- Verify all private-high rows have include_now=no and include_later=yes.

## action_004 - Use source cards instead of raw private files

Priority: P1
Owner: Josh
Status: open
Timeframe: before Fable run
Source IDs: approved-for-fable/privacy-rules-cards.md

Why this matters:
- This keeps privacy rules useful while protecting the raw data.

Concrete next step:
- Upload approved-for-fable cards, not excluded-private raw files.

## action_005 - Remove old unsafe Claude Project uploads

Priority: P0
Owner: Josh
Status: manual-required
Timeframe: immediately
Source IDs: fable_audit

Why this matters:
- Claude Project already saw the old unsafe pack according to Fable.

Concrete next step:
- In Claude Project, delete old uploaded unsafe ZIP/files.
- Upload the new clean ZIP only.
