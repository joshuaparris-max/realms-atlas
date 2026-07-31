# JoshOS Atlas Prep Folder

**Version:** v6 + Complete Addendum  
**Plan score:** 95/100  
**Created:** June 2026  
**Purpose:** All preparation materials for the JoshOS Atlas Fable 5 session

---

## What this folder is

Everything you need to prepare for, execute, and recover from the Fable 5 synthesis session that will design and scaffold JoshOS Atlas — your private local-first command centre.

---

## Start here tonight

Run the PowerShell script from Phase 1 in the master plan, then open:

1. `01_PERSONAL_CONTEXT.md` — add your context
2. `02_PRIVACY_BOUNDARIES.md` — read and confirm the rules
3. Stop. That is night one.

---

## File index

| File | Purpose | When |
|------|---------|------|
| `00_SECURITY_PRECHECK.md` | Record of secret scan results | After Day 2 |
| `01_PERSONAL_CONTEXT.md` | Who Josh is and what Atlas is for | Night 1 |
| `02_PRIVACY_BOUNDARIES.md` | Hard privacy rules for all AI sessions | Night 1 |
| `03_CANONICAL_GOALS.md` | GitHub account decisions | Day 3 |
| `04_SOURCE_REGISTER.csv` | Complete source inventory (60+ rows) | Day 5 |
| `05_SEED_DATA_FORMAT.md` | JSONL format for seed data | Day 3 |
| `06_FABLE_PROMPT.md` | **THE FABLE PROMPT — use on Day 12** | Day 12 |
| `07_CALENDAR_AND_CHECKLIST.md` | 12-day plan with daily checklists | Reference throughout |
| `08_FALLBACK_PLAN.md` | What to do if Fable session goes wrong | Day 12 if needed |
| `09_MODEL_ROUTING_GUIDE.md` | Which AI for which task | Reference throughout |
| `10_PLAN_ITERATION_HISTORY.md` | How this plan evolved (v1–v6) | Reference |

---

## Folder structure

```
joshos-atlas-prep/
  scripts/                    ← PowerShell scripts (run these in order)
    01-risky-file-scan.ps1
    02-token-string-scan.ps1
    03-git-config-credential-scan.ps1
    04-local-folder-inventory.ps1
    05-git-status-inventory.ps1
    06-github-metadata-export.ps1
  raw-inventory/              ← Script outputs (review before sharing with AI)
  source-cards/               ← Generated source cards (review in quality gate)
    repo-cards.md
    deployment-cards.md
    email-cards.md
    doc-cards.md
    local-workspace-cards.md
    privacy-risk-cards.md
    open-action-cards.md
    QUALITY_GATE.md
  approved-for-fable/         ← Cards approved for Fable input
  excluded-private/           ← Excluded/sensitive cards (never in Fable input)
  architecture-draft/         ← Draft architecture (Sonnet/ChatGPT generates Day 11)
    architecture-draft.md
    schema-draft.sql
    first-commit-scope.md
    risk-register.md
  fable-output/               ← Fable session output (10 sections)
    architecture-decision-record.md
    canonical-repo-map.md
    schema.sql
    privacy-risk-report.md
    top-10-actions.md
    weekly-review-template.md
    README.md
    scaffold/                 ← Working Next.js scaffold from Fable
  seed-data/                  ← SAMPLE seed data (fake data only — never real)
```

---

## The 12-day plan in one line

**Secret scan → privacy boundaries → source cards → quality gate → architecture draft → Fable session → local dashboard**

See `07_CALENDAR_AND_CHECKLIST.md` for the day-by-day breakdown.

---

## Critical rules

1. **Run Scripts 1–3 before anything else.** Secret scan before all AI processing.
2. **Review all script output yourself** before sharing with any AI.
3. **Replace real tokens with `[REDACTED_SECRET]`** before any AI sees the file.
4. **Low-confidence cards do not go to Fable** unless manually approved in QUALITY_GATE.md.
5. **Child names, health data, credentials** never go in approved-for-fable/.
6. **The Fable prompt is in `06_FABLE_PROMPT.md`** — use it verbatim on Day 12.

---

## Links referenced in this project

### GitHub accounts
- https://github.com/joshualparris (canonical)
- https://github.com/joshuaparris-max (experimental)
- https://github.com/joshparri (work-specific)

### Key deployments
- https://josh-hub-two.vercel.app/dashboard
- https://josh-hub-96no.vercel.app/apps
- https://appfactory-inky.vercel.app/
- https://lifehubdashboard.vercel.app/
- https://clearcore.vercel.app/

### Tools
- https://claude.ai (Fable 5 session)
- https://cli.github.com/ (GitHub CLI — needed for Script 6)
- https://www.anthropic.com/claude/fable (Fable 5 info)

### Fable 5 pricing (verify in your account)
- List price: $10/M input, $50/M output
- Batch API: $5/M input, $25/M output
- Cached input: ~$1/M
- Free window (unverified): reportedly through June 22 — **check your billing page**
