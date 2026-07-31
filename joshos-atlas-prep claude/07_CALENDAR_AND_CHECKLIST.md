# 12-Day Calendar and Daily Checklists

## Important first

Before relying on the June 22 deadline, verify in your Claude account:
→ claude.ai → Settings → Billing → look for Fable 5 access status

If the free window is confirmed, Day 12 = June 21.
If not confirmed, use Batch API pricing ($5/$25 per million tokens instead of $10/$50).

---

## 12-Day Plan

| Day | Date | Phase | Goal | Done when |
|-----|------|-------|------|-----------|
| 1 | Jun 10 | Phase 1 | Folder + context + privacy | PowerShell run, 3 files written |
| 2 | Jun 11 | Phase 2 | Secret scan — all 3 scripts | `00_SECURITY_PRECHECK.md` filled |
| 3 | Jun 12 | Phase 3–4 | Canonical goals + seed format | Both files written |
| 4 | Jun 13 | Phase 5 | Inventory scripts run | CSV + git-status + GitHub JSON saved |
| 5 | Jun 14 | Phase 6 | Source register completed | CSV has 60+ rows, reviewed |
| 6 | Jun 15 | Phase 7 | Repo cards — hub/work/factory | First 20 repo cards written |
| 7 | Jun 16 | Phase 7–8 | Remaining repo cards + deployment cards | All priority repos carded |
| 8 | Jun 17 | Phase 8 | Gmail source cards | `email-cards.md` complete |
| 9 | Jun 18 | Phase 7 | Doc cards from audit docs | `doc-cards.md` complete |
| 10 | Jun 19 | Phase 9 | Human quality gate | `QUALITY_GATE.md` filled; approved-for-fable/ populated |
| 11 | Jun 20 | Phase 10–11 | Architecture draft + assemble Fable input | All 11 input files ready and reviewed |
| **12** | **Jun 21** | **Phase 12** | **Fable session** | **Output saved to fable-output/** |

---

## Day 1 Checklist (Tonight)

**Time needed: 30–45 minutes**

- [ ] Run the folder creation PowerShell script from `Phase 1`
- [ ] Verify all folders and placeholder files exist in `C:\joshos-atlas-prep\`
- [ ] Open `01_PERSONAL_CONTEXT.md` — add any personal notes beyond the template
- [ ] Open `02_PRIVACY_BOUNDARIES.md` — read through; add anything specific to your situation
- [ ] **Stop here.** Do not start secret scans or uploading docs tonight.

---

## Day 2 Checklist (Security Precheck)

**Time needed: 45–60 minutes**

- [ ] Save Script 1 (`01-risky-file-scan.ps1`) to scripts folder
- [ ] Run Script 1 — review `risky-files.csv` manually before opening in any AI
- [ ] Save Script 2 (`02-token-string-scan.ps1`) to scripts folder
- [ ] Run Script 2 — review `token-string-hits.txt` manually
- [ ] Save Script 3 (`03-git-config-credential-scan.ps1`) to scripts folder
- [ ] Run Script 3 — review `embedded-credential-remotes.txt` manually
- [ ] Replace any real tokens with `[REDACTED_SECRET]`
- [ ] Fill in `00_SECURITY_PRECHECK.md` with findings
- [ ] List any repos that are NOT safe to include in Fable pack yet

---

## Day 3 Checklist (Canonical Goals + Seed Format)

**Time needed: 30 minutes**

- [ ] Open `03_CANONICAL_GOALS.md` — confirm the three-account decision is correct for your situation
- [ ] Add any specific repos you already know should be archived or merged
- [ ] Open `05_SEED_DATA_FORMAT.md` — read through the JSONL examples
- [ ] Confirm the required fields make sense for your data

---

## Day 4 Checklist (Inventory Scripts)

**Time needed: 30–45 minutes**

- [ ] Save Script 4 (`04-local-folder-inventory.ps1`) and run it
- [ ] Save Script 5 (`05-git-status-inventory.ps1`) and run it
- [ ] Check if GitHub CLI is installed: `gh --version`
  - If yes: save Script 6 and run it
  - If no: manually export repo list from GitHub web UI into `raw-inventory/github-repos-manual.md`
- [ ] Open `raw-inventory/` and confirm all files look reasonable (no secrets visible)

---

## Day 5 Checklist (Source Register)

**Time needed: 45 minutes**

- [ ] Open `04_SOURCE_REGISTER.csv` — the template has 60+ rows already
- [ ] Add any missing repos or deployments you know about
- [ ] Correct any wrong sensitivity levels
- [ ] Add local workspace folder rows from Script 4 output
- [ ] Mark any rows as `include_now: no` that are not safe yet

---

## Day 6 Checklist (First Repo Cards — Hub/Work/Factory)

**Time needed: 60–90 minutes using ChatGPT or Sonnet**

Priority repos to card first:
- JoshHub, LifeHub, Parris-Life-Dashboard, ClearCore (hub cluster)
- AppFactory
- DCSPrep, DCSCompanion (redact school data)
- WorkApp
- HealthLens (architecture only — no raw health data)

For each, use the repo card format from Phase 7.
Feed: README + package.json + folder tree (no node_modules, no .env, no .git)

- [ ] Open `source-cards/repo-cards.md`
- [ ] Add a card for each priority repo above
- [ ] Set confidence level for each card
- [ ] Mark any card that needs Josh review

---

## Day 7 Checklist (Remaining Repo Cards + Deployment Cards)

**Time needed: 60–90 minutes**

- [ ] Card remaining repos: ParrisTech cluster, NFC apps, games/creative cluster
- [ ] Child-named repos: card as `private-high` with status `rename-and-privatise` — no content analysis
- [ ] Open `source-cards/deployment-cards.md`
- [ ] Card all known Vercel and GitHub Pages deployments from source register
- [ ] Note broken deployments from CI failure emails

---

## Day 8 Checklist (Gmail Source Cards)

**Time needed: 45–60 minutes**

Use the Gmail search queries from Phase 8.

- [ ] Export GitHub CI failure threads → card in `email-cards.md`
- [ ] Export GitHub invite emails → card in `email-cards.md`
- [ ] Export property/mould threads → mark `private-high`, summarise only
- [ ] Export job search threads → card with career admin context
- [ ] Export AI tooling emails → card for subscription/tool context
- [ ] Do NOT card health, NDIS, or child therapy emails yet

---

## Day 9 Checklist (Doc Cards)

**Time needed: 45 minutes**

- [ ] Card `__@App Audit 2026.docx` → `doc-cards.md`
- [ ] Card `TODO_MASTER.md` → `doc-cards.md`
- [ ] Card `Computer 3 Audit iMac Retina.txt` → `doc-cards.md`
- [ ] Card `github_repo_audit_22_may_2026.pdf` → `doc-cards.md`
- [ ] Card privacy threat model docs as `private-high` rules-only summary
- [ ] Create `privacy-risk-cards.md` from threat model + OSINT audit findings
- [ ] Create `open-action-cards.md` from TODO_MASTER backlog

---

## Day 10 Checklist (Quality Gate)

**Time needed: 60 minutes — this is the most important human step**

- [ ] Open every card file in `source-cards/`
- [ ] For each card, ask: Is this accurate? Is it redacted enough? Is it useful?
- [ ] Open `source-cards/QUALITY_GATE.md`
- [ ] Move approved cards to `approved-for-fable/`
- [ ] Move excluded cards to `excluded-private/`
- [ ] Mark any card needing redaction before moving
- [ ] Confirm: no private-high raw content in approved-for-fable/
- [ ] Confirm: no child names, health data, or credentials in any approved card

---

## Day 11 Checklist (Architecture Draft + Final Assembly)

**Time needed: 90 minutes**

Use Sonnet 4.6 or ChatGPT for the architecture draft.

- [ ] Feed all approved source cards + source register to Sonnet/ChatGPT
- [ ] Ask for: Next.js folder structure, SQLite schema draft, JSONL seed import plan, first commit scope
- [ ] Save outputs to `architecture-draft/`
- [ ] Confirm seed data format in architecture matches `05_SEED_DATA_FORMAT.md`
- [ ] Assemble the 11 input files in order (see `06_FABLE_PROMPT.md`)
- [ ] Do a final check: no secrets, no private-high raw content in any input file
- [ ] Verify Fable 5 is available in your Claude account
- [ ] You are ready for Day 12

---

## Day 12 Checklist (Fable Session)

**Time needed: Allow 30–60 minutes for the session to run**

- [ ] Open claude.ai — select Fable 5 model
- [ ] Attach source files in the order listed in `06_FABLE_PROMPT.md`
- [ ] Paste the prompt from `06_FABLE_PROMPT.md`
- [ ] Let it run — do not interrupt unless it stalls
- [ ] Save ALL output immediately to the corresponding files in `fable-output/`
- [ ] If output is cut off: paste the last heading and say "Continue from Section [N]"
- [ ] After session: review output against acceptance criteria in `architecture-draft/first-commit-scope.md`
- [ ] Flag any sections that need Sonnet/Claude Code repair

---

## If the free window is gone (cost fallback)

1. Compress cards: remove fields with value "unknown" → replace with `"needs_review": true`
2. Use Batch API: halves cost to $5/$25 per million tokens (results within 24 hours)
3. Split into two passes if needed:
   - Pass A (Sections 1–5): architecture, schema, repo map, privacy, actions
   - Pass B (Sections 6–10): templates, README, scaffold, tests, implementation plan
4. Use prompt caching: once you've run Pass A, subsequent calls with the same context cost ~$1/M input instead of $10/M
