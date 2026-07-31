# 06_FABLE_SESSION.md

## 12-Day Calendar

Verify the Fable access / pricing window in your Claude account before treating June 22 as a hard deadline.

| Day | Phase | Goal | Done when |
|-----|-------|------|-----------|
| 1 | Phase 1 | Folder structure + context + privacy boundaries | Scripts run, 3 files written |
| 2 | Phase 2 | Secret scan — all 3 scripts run | `00_SECURITY_PRECHECK.md` filled |
| 3 | Phase 3–4 | Canonical goals + seed data format | Both files written |
| 4 | Phase 5 | Inventory scripts run | `local-folders-raw.csv`, `git-status-raw.txt` saved |
| 5 | Phase 5–6 | GitHub CLI export + source register | CSV has 40+ rows |
| 6 | Phase 7 | Repo source cards — hub/work/factory cluster | `repo-cards.md` has first 20 cards |
| 7 | Phase 7–8 | Remaining repo cards + deployment cards | All priority repos carded |
| 8 | Phase 8 | Gmail source cards | `email-cards.md` complete |
| 9 | Phase 7 | Doc cards from audit/TODO/threat model docs | `doc-cards.md` complete |
| 10 | Phase 9 | Human quality gate | `QUALITY_GATE.md` filled, `approved-for-fable/` populated |
| 11 | Phase 10–11 | Architecture draft + assemble Fable input | All input files ready |
| 12 | Phase 12 | Fable session | Output saved to `fable-output/` |

---

## Fable input order

Give Fable these in this order:

1. `00_SECURITY_PRECHECK.md`
2. `01_PERSONAL_CONTEXT.md`
3. `02_PRIVACY_BOUNDARIES.md`
4. `03_CANONICAL_GOALS.md`
5. `04_SOURCE_REGISTER.csv`
6. `05_SEED_DATA_FORMAT.md`
7. approved source cards only
8. `source-cards/QUALITY_GATE.md`
9. `architecture-draft/architecture-draft.md`
10. `architecture-draft/schema-draft.sql`
11. `architecture-draft/first-commit-scope.md`
12. `architecture-draft/risk-register.md`
13. stack constraints
14. final Fable prompt below

---

# Complete Fable Prompt

Copy the contents below verbatim as the Fable session opening message, with source files attached or pasted above it.

```text
You are Claude Fable 5 acting as a senior product architect, full-stack engineer, privacy engineer, and systems organiser.

Your task is to design and scaffold JoshOS Atlas: a private, local-first command centre for Joshua Parris's apps, GitHub repos, deployments, source documents, privacy risks, and next actions.

You have been given a structured source pack. Read all source files before producing any output.

---

RULES — READ THESE FIRST

1. Do not ask clarifying questions. If uncertain about a decision, state your assumption explicitly and proceed.
2. If a source card has insufficient evidence, mark it LOW CONFIDENCE and continue. Do not stall or invent facts.
3. Format all outputs as structured Markdown with consistent heading levels.
4. Every recommendation must cite its source card ID in brackets, e.g. [repo_001].
5. Every privacy or security risk must include a severity level: P0, P1, P2, or P3.
6. Every action must include: owner (Josh), timeframe, and source card ID.
7. Separate source facts from your interpretation. Use "Source says:" and "Interpretation:" labels where ambiguous.
8. Do not generate legal, medical, tax, financial, or investment advice as if qualified.
9. Do not include secrets, raw private docs, or sensitive child/health/school/family data in code or seed files.
10. Public deployment output must use fake/sample data only.
11. The architecture must allow Gmail and Google Drive ingestion to be added as future modules without structural rework. If your design prevents this, it fails this requirement.

---

STACK CONSTRAINTS

- Local-first Next.js app using the App Router (not Pages Router)
- TypeScript throughout
- SQLite database using better-sqlite3
- No Prisma in the first build
- No Docker in the first build
- No WSL required — must run on Windows natively
- Seed data loads from JSONL files at startup
- Gmail and Drive ingestion are future modules — design the schema to support them without rework
- Public deployment, if added later, uses fake/sample data only

---

PERSONAL CONTEXT

Josh is a Christian husband and dad in Dubbo, NSW. He works across IT/library support, MSP-style tech work, family systems, job/career transition, and personal app building. He is time-poor and a solo developer. He values calm, practical, private-first guidance over clever over-engineering.

He has apps, repos, and deployments spread across three GitHub accounts (joshualparris as canonical, joshuaparris-max as experimental, joshparri as work-specific), Vercel, GitHub Pages, and local folders on a Windows machine. Many repos are duplicated, stale, or broken. Some have privacy risks (child-named apps in public repos). At least one has known exposed credentials flagged as P0.

The system must help him see what matters, what is broken, what is risky, and what to do next. Every recommendation must link to evidence.

---

PRIVACY CONSTRAINTS — HARD LIMITS

These apply to all output including code, seed data, and documentation:

- Never commit or generate .env files, API keys, tokens, or credentials
- Never include child therapy, NDIS, health, school/student, or private family content in any public-facing output
- Child and family-named apps must be flagged for renaming and privatisation, not built upon
- Work-related apps (DCS, Avance) must use sample/fake data — no real staff, student, or institutional data
- Every seed data file uses fake placeholder values for any private-high or local-only sensitivity items

---

YOUR TASKS

Produce output organised into the following sections in this exact order. Use the filename as the Markdown H1 heading for each section.

Section 1 — fable-output/architecture-decision-record.md

Critique the provided architecture draft. Then produce a final Architecture Decision Record covering:
- chosen tech stack with justification
- folder structure for the Next.js app
- how seed data flows from JSONL into SQLite at startup
- how source card IDs link through the data model
- how future Gmail and Drive modules will attach without structural rework
- key decisions made and assumptions recorded

Section 2 — fable-output/canonical-repo-map.md

For every repo in the source register, produce a decision row:

| Repo | Owner | Status | Sensitivity | Duplicate Group | Decision | Reason | Source IDs |
|------|-------|--------|-------------|-----------------|----------|--------|------------|

Decisions must be one of: keep-canonical / keep-active / merge-into / archive / privatise / investigate / rename-and-privatise.

After the table, list the top 10 repos to act on first with a one-line justification each.

Section 3 — fable-output/schema.sql

Produce the complete SQLite schema. Tables required:

- sources (id, name, type, location, sensitivity, confidence, include_now, include_later, notes)
- repos (all repo card fields)
- deployments (all deployment card fields)
- email_threads (all email card fields)
- documents (all doc card fields)
- workspace_folders (all local workspace card fields)
- privacy_risks (id, title, severity, status, affected_source_ids, recommended_action, source_ids, confidence)
- actions (id, title, priority, status, project_id, source_ids, owner, timeframe, confidence)
- weekly_reviews (id, created_at, matters_this_week, ignore_this_week, fix_this_week, finish_this_week, reflect_on, next_action)

Every table must include: created_at, updated_at. Foreign keys where appropriate. Include comments explaining non-obvious fields.

Section 4 — fable-output/privacy-risk-report.md

List every privacy and security risk visible in the source pack. For each:
- Risk ID
- Title
- Severity (P0/P1/P2/P3)
- Description
- Affected sources (source IDs)
- Recommended action
- Owner: Josh
- Timeframe
- Status: open

Sort by severity descending. P0 items first.

Section 5 — fable-output/top-10-actions.md

Produce the 10 highest-priority actions Josh should take, ranked. For each:
- Action ID
- Title
- Priority (P0/P1/P2)
- Why this matters
- Concrete next step
- Source IDs
- Timeframe
- Owner: Josh

The first three actions should be security/privacy remediations if any P0 risks exist.

Section 6 — fable-output/weekly-review-template.md

Produce a reusable weekly review template Josh can fill in. Sections:
- What matters this week (3 items max)
- What to ignore this week
- What to fix (linked to action IDs)
- What to finish (linked to repo/project IDs)
- What to reflect or pray about
- Top next action

Section 7 — fable-output/README.md

Produce a README covering:
- What JoshOS Atlas is
- Prerequisites (Node version, SQLite, better-sqlite3, Windows)
- Setup steps from clone to running locally
- How to import seed data
- How to add a new source card
- Privacy notes
- What is not built yet (Gmail, Drive, public deployment)
- How to extend to Gmail/Drive later

Section 8 — fable-output/scaffold/

Produce a working first scaffold. Files required:

fable-output/scaffold/
  package.json
  tsconfig.json
  next.config.ts
  .gitignore                    ← must exclude .env, *.db, raw-inventory/, excluded-private/
  src/
    app/
      layout.tsx
      page.tsx                  ← redirects to /dashboard
      dashboard/
        page.tsx                ← summary: counts, top actions, top risks
      projects/
        page.tsx                ← repo list with status, sensitivity, duplicate group, recommended action
      sources/
        page.tsx                ← source register table
      actions/
        page.tsx                ← action items ranked by priority
      privacy/
        page.tsx                ← privacy risk list sorted by severity
    lib/
      db.ts                     ← better-sqlite3 initialisation and connection
      seed.ts                   ← JSONL loader: reads approved-for-fable/*.jsonl and inserts into SQLite
      types.ts                  ← TypeScript interfaces matching schema
    components/
      StatusBadge.tsx           ← coloured badge for status/sensitivity/priority
      SourceLink.tsx            ← renders source card ID as a link or tooltip
      RiskBadge.tsx             ← P0/P1/P2/P3 badge with colour
  seed-data/
    repos.jsonl                 ← sample records using fake data — no real private content
    deployments.jsonl
    actions.jsonl
    privacy_risks.jsonl

The scaffold must run locally with npm install && npm run dev with no additional configuration. Seed data must load on first run. No real private data in any seed file.

Section 9 — fable-output/test-plan.md

Produce a test plan covering:
- what to verify manually before committing
- what unit tests to write first (seed loader, schema creation, status badge)
- what integration tests matter (seed → database → page render)
- what privacy tests are required (no secrets in output, no private data in seed files, .gitignore coverage)

Section 10 — fable-output/implementation-plan.md

Produce a 6-week staged implementation plan. Each week:
- Goal
- Specific tasks
- Acceptance criteria
- What not to do yet

Week 1 must be: get the scaffold running locally with seed data.
Week 6 must end with: Gmail or Drive ingestion module designed (not necessarily built).

---

BEGIN

Read all source files. Then produce output section by section in the order above. Do not skip sections. Do not summarise — produce the full content for each section.
```

---

# Fallback Plan

## Scenario 1 — Scaffold runs but has errors

Don't re-run Fable. Save the scaffold exactly as produced. Open Claude Code with Sonnet and give it only the broken files plus the error message.

Ask:

```text
Make this run locally. Preserve the architecture.
```

Fable's architecture is the source of truth. Sonnet fixes the code.

## Scenario 2 — Architecture is wrong or contradicts stack constraints

Don't re-run the full prompt. Extract only:

- the architecture-decision-record section
- your stack constraints block
- the specific contradiction

Run a targeted Fable pass:

```text
Revise only Section 1 — architecture-decision-record. Constraints are unchanged. Do not regenerate scaffold or other sections.
```

## Scenario 3 — Repo decisions are missing or wrong

Fix the source cards first. Then run a targeted pass:

```text
Update only Section 2 — canonical-repo-map.md based on these corrected cards: [paste corrected cards]. Do not regenerate other sections.
```

## Scenario 4 — Output is cut off mid-section

Don't restart. Paste the last complete heading from the output and say:

```text
Continue from Section [N] — [filename]. Do not repeat previous sections.
```

Keep the same conversation thread so context is preserved.

## Scenario 5 — Fable access is not included / costs are a concern

Do not run the full prompt at list price.

Do this instead:

1. Compress all source cards.
2. Remove any field with value `unknown` or `investigate`.
3. Replace those fields with `"needs_review": true`.
4. Use only approved, redacted source cards.
5. Split into two passes if needed.

### Pass A

Sections 1–5:

- architecture
- schema
- repo map
- privacy
- actions

### Pass B

Sections 6–10:

- templates
- README
- scaffold
- tests
- implementation plan

### Batch API note

Anthropic’s Message Batches API is asynchronous and has 50% pricing, but is not eligible for Zero Data Retention. Do **not** use it for raw private-high, child, health, school, tenancy, financial, or family material. Only use approved, redacted source cards.

---

# Extensibility Acceptance Criterion

Add this to `architecture-draft/first-commit-scope.md`:

```markdown
## Extensibility Acceptance Criterion

The first build passes this criterion if and only if:

A developer can add a Gmail ingestion module by creating:
- a new `lib/gmail/` directory
- a new `app/inbox/` page
- new rows in the `email_threads` and `actions` tables

WITHOUT modifying:
- the existing schema tables
- the seed loader
- the dashboard page
- the privacy risk model
- any existing source card format

If adding Gmail requires structural changes to existing tables or components, the architecture fails this criterion and must be revised before the Fable session.
```
