# START HERE — JoshOS Atlas

Do this first. Do not do the whole plan tonight.

## Night-one goal

Finish only:

1. Create the prep folder on your Windows machine
2. Write short personal context
3. Write privacy boundaries
4. Stop

## Step 1 — Copy this folder

Unzip this package somewhere easy, for example:

```text
C:\joshos-atlas-prep
```

If you unzip somewhere else, update paths in scripts before running them.

## Step 2 — Read these files first

```text
00_SECURITY_PRECHECK.md
01_PERSONAL_CONTEXT.md
02_PRIVACY_BOUNDARIES.md
03_CANONICAL_GOALS.md
05_SEED_DATA_FORMAT.md
06_FABLE_SESSION.md
```

## Step 3 — Do not upload private docs yet

Do not upload:

- health records
- child therapy or NDIS docs
- school/student/staff data
- raw tenancy evidence photos
- bank statements
- family/marriage notes
- `.env` or API keys

## Step 4 — Run security scans before inventory

Only after reading the safety files, run scripts in this order:

```powershell
powershell -ExecutionPolicy Bypass -File C:\joshos-atlas-prep\scripts\01-risky-file-scan.ps1
powershell -ExecutionPolicy Bypass -File C:\joshos-atlas-prep\scripts\02-token-string-scan.ps1
powershell -ExecutionPolicy Bypass -File C:\joshos-atlas-prep\scripts\03-git-config-credential-scan.ps1
```

Review outputs yourself before sending anything to AI.
