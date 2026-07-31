# Fable Session Prompt

## How to use this file

1. Open a new Claude Fable 5 conversation (claude.ai, select Fable 5 model)
2. Attach or paste your approved source files ABOVE this prompt
3. Copy everything below the line and paste it as your first message
4. Do not modify the prompt — Fable should receive it verbatim

Attach these files in this order before the prompt:
1. `00_SECURITY_PRECHECK.md`
2. `01_PERSONAL_CONTEXT.md`
3. `02_PRIVACY_BOUNDARIES.md`
4. `03_CANONICAL_GOALS.md`
5. `04_SOURCE_REGISTER.csv`
6. `05_SEED_DATA_FORMAT.md`
7. All approved source cards from `approved-for-fable/`
8. `source-cards/QUALITY_GATE.md`
9. `architecture-draft/architecture-draft.md`
10. `architecture-draft/schema-draft.sql`
11. `architecture-draft/first-commit-scope.md`

---

## THE PROMPT (copy from here)

---

You are Claude Fable 5 acting as a senior product architect, full-stack engineer, privacy engineer, and systems organiser.

Your task is to design and scaffold JoshOS Atlas: a private, local-first command centre for Joshua Parris's apps, GitHub repos, deployments, source documents, privacy risks, and next actions.

You have been given a structured source pack. Read all source files before producing any output.

---

RULES — READ THESE FIRST

1. Do not ask clarifying questions. If uncertain about a decision, state your assumption explicitly and proceed.
2. If a source card has insufficient evidence, mark it LOW CONFIDENCE and continue. Do not stall or invent facts to fill gaps.
3. Format all outputs as structured Markdown with consistent heading levels.
4. Every recommendation must cite its source card ID in brackets, e.g. [repo_001].
5. Every privacy or security risk must include a severity level: P0, P1, P2, or P3.
6. Every action must include: owner (Josh), timeframe, and source card ID.
7. Separate source facts from your interpretation. Use "Source says:" and "Interpretation:" labels where ambiguous.
8. Do not generate legal, medical, tax, financial, or investment advice as if qualified.
9. Do not include secrets, raw private docs, or sensitive child/health/school/family data in code or seed files.
10. Public deployment output must use fake/sample data only.
11. The architecture must allow Gmail and Google Drive ingestion to be added as future modules without structural rework. If your design prevents this, it fails a core requirement.

---

STACK CONSTRAINTS

- Local-first Next.js app using the App Router (not Pages Router)
- TypeScript throughout
- SQLite database using better-sqlite3
- No Prisma in the first build
- No Docker in the first build
- No WSL required — must run on Windows natively
- Seed data loads from JSONL files in seed-data/ at startup
- Gmail and Drive ingestion are future modules — design the schema and folder structure to support them without rework
- Public deployment, if added later, uses fake/sample data only

---

PERSONAL CONTEXT

Josh is a Christian husband and dad in Dubbo, NSW. He works across IT/library support, MSP-style tech work, family systems, job/career transition, and personal app building. He is time-poor and a solo developer. He values calm, practical, private-first guidance over clever over-engineering.

He has apps, repos, and deployments spread across three GitHub accounts:
- joshualparris (canonical going forward)
- joshuaparris-max (experimental)
- joshparri (work-specific)

Many repos are duplicated, stale, or broken. Several have privacy risks (child-named apps in public repos). At least one has known exposed credentials flagged as P0.

The system must help him see what matters, what is broken, what is risky, and what to do next. Every recommendation must link to evidence.

---

PRIVACY CONSTRAINTS — HARD LIMITS

These apply to all output including code, seed data, comments, and documentation:

- Never generate or include .env files, API keys, tokens, or credentials
- Never include child therapy, NDIS, health, school/student, or private family content in any output
- Child and family-named apps (Sleepy, SylviePhonetics, SylvieApp) must be flagged for renaming and privatisation — not built upon or expanded
- Work-related apps (DCS, Avance) must use sample/fake data — no real staff, student, or institutional data
- Every seed data file uses fake placeholder values for private-high or local-only sensitivity items

---

YOUR TASKS

Produce output organised into the following sections in this exact order.
Use the filename as the Markdown H1 heading for each section.
Do not skip sections. Do not summarise — produce the full content for each section.

---

SECTION 1 — fable-output/architecture-decision-record.md

Critique the provided architecture draft. Then produce a final Architecture Decision Record covering:
- Chosen tech stack with justification
- Folder structure for the Next.js app (full tree)
- How seed data flows from JSONL files into SQLite at startup
- How source card IDs link through the data model end-to-end
- How future Gmail and Drive modules will attach without structural rework (be specific about which tables and interfaces they will use)
- All key decisions made and assumptions recorded

---

SECTION 2 — fable-output/canonical-repo-map.md

For every repo in the source register, produce a decision table:

| Repo | Account | Sensitivity | Duplicate Group | Decision | Reason | Source IDs |
|------|---------|-------------|-----------------|----------|--------|------------|

Valid decisions: keep-canonical / keep-active / merge-into:[repo-id] / archive / privatise-now / investigate / rename-and-privatise

After the table, list:
- Top 10 repos to act on first (ranked, with one-line justification each)
- Top 5 deployments to disable or investigate

---

SECTION 3 — fable-output/schema.sql

Produce the complete SQLite schema. Required tables:

- sources (id, name, type, location, sensitivity, confidence, include_now, include_later, notes)
- repos (all repo card fields)
- deployments (all deployment card fields)
- email_threads (all email card fields)
- documents (all doc card fields)
- workspace_folders (all local workspace card fields)
- privacy_risks (id, title, severity, status, affected_source_ids, recommended_action, source_ids, confidence)
- actions (id, title, priority, status, project_id, source_ids, owner, timeframe, confidence)
- weekly_reviews (id, created_at, matters_this_week, ignore_this_week, fix_this_week, finish_this_week, reflect_on, next_action)

Rules:
- Every table must include created_at and updated_at
- Use foreign keys where appropriate
- Include SQL comments explaining non-obvious fields
- Design to support Gmail and Drive tables being added later without schema changes to existing tables

---

SECTION 4 — fable-output/privacy-risk-report.md

List every privacy and security risk visible in the source pack.

For each risk:
- Risk ID
- Title
- Severity (P0 / P1 / P2 / P3)
- Description
- Affected source IDs
- Recommended action
- Owner: Josh
- Timeframe
- Status: open

Sort by severity descending. P0 items must come first.
P0 items must include a specific remediation step Josh can take within 24 hours.

---

SECTION 5 — fable-output/top-10-actions.md

Produce the 10 highest-priority actions Josh should take, ranked 1–10.

For each:
- Action ID
- Title
- Priority (P0 / P1 / P2)
- Why this matters (2–3 sentences)
- Concrete next step (specific and actionable)
- Source IDs
- Timeframe
- Owner: Josh

Rules:
- The first 1–3 actions must be security/privacy remediations if any P0 risks exist
- Actions must be achievable by a solo developer
- Do not list vague goals — each action must have a specific first step

---

SECTION 6 — fable-output/weekly-review-template.md

Produce a reusable weekly review template Josh fills in each week.

Sections:
- Week of: [date]
- What matters this week (3 items max, linked to action IDs)
- What to ignore this week (noise list)
- What to fix (linked to action IDs, with specific next step)
- What to finish (linked to repo/project IDs)
- What to reflect or pray about (personal/faith section — not productivity)
- Top next action (one thing only)
- Notes

---

SECTION 7 — fable-output/README.md

Produce a README covering:
- What JoshOS Atlas is and why it exists
- Prerequisites (Node version, Windows, SQLite, better-sqlite3)
- Setup steps: clone → install → seed → run (exact commands)
- How to import seed data (JSONL format, location, command)
- How to add a new source card manually
- Privacy notes (what is not committed, what stays local)
- What is not built yet (Gmail, Drive, public deployment)
- How to extend to Gmail/Drive later (which files to create, which tables already exist)

---

SECTION 8 — fable-output/scaffold/

Produce a working first scaffold. Required files:

```
fable-output/scaffold/
  package.json                  ← Next.js 14, TypeScript, better-sqlite3, tailwindcss
  tsconfig.json
  next.config.ts
  tailwind.config.ts
  postcss.config.js
  .gitignore                    ← must exclude: .env*, *.db, raw-inventory/, excluded-private/, approved-for-fable/
  src/
    app/
      layout.tsx                ← root layout with nav: Dashboard / Projects / Sources / Actions / Privacy
      page.tsx                  ← redirects to /dashboard
      dashboard/
        page.tsx                ← summary cards: repo count, open actions, P0 risks, broken deployments
      projects/
        page.tsx                ← repo list with status badge, sensitivity badge, duplicate group, recommended action, source links
      sources/
        page.tsx                ← source register table: id, name, type, sensitivity, include_now
      actions/
        page.tsx                ← action items ranked by priority with source ID links
      privacy/
        page.tsx                ← privacy risk list sorted by severity with P0/P1/P2/P3 badges
    lib/
      db.ts                     ← better-sqlite3 init, connection singleton, createTables()
      seed.ts                   ← JSONL loader: reads seed-data/*.jsonl, maps to tables, inserts on first run
      types.ts                  ← TypeScript interfaces matching every schema table
    components/
      StatusBadge.tsx           ← coloured badge for repo status values
      SensitivityBadge.tsx      ← coloured badge for sensitivity levels
      RiskBadge.tsx             ← P0/P1/P2/P3 coloured badge
      SourceLink.tsx            ← renders source_id as tooltip or link
  seed-data/
    repos.jsonl                 ← 5–10 sample records using FAKE data only
    deployments.jsonl           ← 5 sample records using FAKE data only
    actions.jsonl               ← 5 sample records using FAKE data only
    privacy_risks.jsonl         ← 3 sample records using FAKE data only
```

Rules for scaffold:
- Must run with `npm install && npm run dev` on Windows with no extra config
- Seed data loads automatically on first run if database is empty
- No real private data in any seed file — use clearly fake placeholder values
- Nav must be present on all pages
- Every repo row must show: name, status, sensitivity, duplicate_group, recommended_action, source_ids

---

SECTION 9 — fable-output/test-plan.md

Produce a test plan covering:
- Manual checks before first commit (checklist format)
- First unit tests to write: seed loader, schema creation, StatusBadge render
- First integration tests: seed → database → page renders without error
- Privacy tests required: no secrets in output, .gitignore covers all private paths, no child/health data in seed files
- How to run tests (commands)

---

SECTION 10 — fable-output/implementation-plan.md

Produce a 6-week staged implementation plan.

For each week:
- Goal (one sentence)
- Tasks (specific, not vague)
- Acceptance criteria (testable)
- What NOT to do yet

Constraints:
- Week 1 goal: scaffold runs locally with seed data
- Week 3 goal: all priority repos are carded and visible in the dashboard
- Week 5 goal: privacy risks are tracked and P0 items have been actioned
- Week 6 goal: Gmail ingestion module is designed (architecture and schema), not necessarily built

---

BEGIN

Read all source files. Then produce output section by section in the order above.
Do not skip sections. Do not ask questions. Make decisions and record your assumptions.
