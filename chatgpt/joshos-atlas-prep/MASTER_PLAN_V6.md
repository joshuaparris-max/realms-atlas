# JoshOS Atlas v6 — Single Authoritative Master Plan

## Purpose

Build **JoshOS Atlas**: a private, local-first command centre for Josh’s apps, GitHub repos, deployments, source documents, privacy risks, and next actions.

The first useful win is not:

> AI reads everything.

The first useful win is:

> Here are all my apps and repos. These ones matter. These are broken. These are risky. These should be merged, archived, fixed, renamed, or made private. Every recommendation links to evidence.

## Core principle

Fable 5 is not the scraper.

Fable 5 should receive a clean, safe, quality-checked source pack and then do the high-value work:

- architecture
- canonicalisation
- privacy reasoning
- repo triage
- schema design
- first scaffold
- staged implementation planning

Use cheaper tools for extraction and source-card generation.

---

# Master build order

1. Create prep folder
2. Write minimal personal/privacy context
3. Run secret scan
4. Decide canonical account goals
5. Define seed data format
6. Run repo/workspace inventory
7. Build source register
8. Generate source cards
9. Human quality gate
10. Draft architecture
11. Assemble Fable input
12. Run one structured Fable pass
13. Recover/repair output if needed
14. Build local dashboard
15. Add Gmail/Drive integrations later

---

# Phase 1 — Night-one start

## Goal

Finish only:

- prep folder
- empty files
- short personal context
- privacy boundaries

Do not upload private documents tonight.

## Personal context

Use `01_PERSONAL_CONTEXT.md`.

## Privacy boundaries

Use `02_PRIVACY_BOUNDARIES.md`.

Stop after this on night one.

---

# Phase 2 — Security precheck

## Script note

Scripts 1 and 2 are complementary.

- Script 1 finds risky filenames.
- Script 2 finds risky strings inside ordinary files.
- Script 3 finds embedded credentials in Git remotes.

No single script is enough.

Review outputs manually before sharing with any AI. If a file contains a real token, replace it with:

```text
[REDACTED_SECRET]
```

Fill `00_SECURITY_PRECHECK.md` after reviewing scan results.

---

# Phase 3 — Canonical goals

Use `03_CANONICAL_GOALS.md`.

---

# Phase 4 — Seed data format

Use `05_SEED_DATA_FORMAT.md`.

---

# Phase 5 — Inventory scripts

Run only after the security precheck:

```powershell
powershell -ExecutionPolicy Bypass -File C:\joshos-atlas-prep\scripts\04-local-folder-inventory.ps1
powershell -ExecutionPolicy Bypass -File C:\joshos-atlas-prep\scripts\05-git-status-inventory.ps1
powershell -ExecutionPolicy Bypass -File C:\joshos-atlas-prep\scripts\06-github-metadata-export.ps1
```

Script 6 requires GitHub CLI installed and authenticated.

---

# Phase 6 — Expanded source register

Use `04_SOURCE_REGISTER.csv`.

Add rows as new sources are discovered.

---

# Phase 7 — Source cards

Create source cards from approved sources only.

Templates are in:

```text
source-cards/
```

---

# Phase 8 — Gmail source cards

Do not ingest the whole mailbox.

Use selected thread cards only.

Email searches are listed in:

```text
source-lists/email_searches.md
```

---

# Phase 9 — Human quality gate

Use:

```text
source-cards/QUALITY_GATE.md
```

Rule:

> Uncertain cards do not go to Fable.

If a card is low-confidence, move it to `excluded-private/` or rewrite it before approval.

---

# Phase 10 — Architecture draft

Create:

```text
architecture-draft/architecture-draft.md
architecture-draft/schema-draft.sql
architecture-draft/first-commit-scope.md
architecture-draft/risk-register.md
```

The draft must include:

- Next.js folder structure
- SQLite schema
- JSONL seed import approach
- source card data model
- privacy risk data model
- action ranking model
- first dashboard wireframe
- first commit scope
- risks and assumptions
- future Gmail ingestion module shape
- future Google Drive ingestion module shape
- explicit statement that future Gmail/Drive ingestion must not require structural rework

---

# Phase 11 — Stack constraints

Use the stack constraints in `06_FABLE_SESSION.md`.

---

# Phase 12 — Final Fable pass

Use `06_FABLE_SESSION.md`.

---

# Phase 13 — Fable output recovery

Use the fallback plan in `06_FABLE_SESSION.md`.

---

# Phase 14 — Cost fallback

Use the cost fallback plan in `06_FABLE_SESSION.md`.

Important: Anthropic’s Message Batches API is asynchronous, offers 50% pricing, and is **not eligible for Zero Data Retention**. Do not use batch processing for raw private-high, child, health, school, tenancy, financial, or family material. Only use approved, redacted source cards.

---

# Phase 15 — 12-day calendar

Use `checklists/12_DAY_CALENDAR.md`.

---

# Phase 16 — First build acceptance criteria

The first working version is complete when:

- app runs locally on Windows
- seed JSONL imports successfully
- top projects display
- duplicate projects are grouped
- broken deployments are flagged
- privacy risks are visible
- action items are ranked
- every recommendation links to source IDs
- README explains setup
- schema exists
- test plan exists
- no secrets are committed
- no raw private child/health/school/family docs are committed
- architecture supports future Gmail and Drive ingestion without structural rework

If the architecture cannot support Gmail and Drive ingestion later without structural rework, the Fable pass fails this criterion even if the first local dashboard runs.
