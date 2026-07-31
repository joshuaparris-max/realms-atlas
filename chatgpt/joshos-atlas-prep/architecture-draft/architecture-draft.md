# Architecture Draft — JoshOS Atlas

## Purpose

Provide a concrete, implementable architecture for the first Windows-local build of JoshOS Atlas. This document defines folder layout, seed import flow, data model boundaries, and extension points for Gmail/Drive ingestion.

## Chosen stack

- Next.js (App Router) + TypeScript
- SQLite via `better-sqlite3`
- Tailwind CSS
- No Prisma, no Docker in first build

## Folder structure (first-commit)

```
app/
	dashboard/
	projects/
	sources/
	actions/
	privacy/
lib/
	db.ts
	seed-loader.ts
	github/
	gmail/   <-- future
	drive/   <-- future
seed-data/
db/
scripts/
architecture-draft/
fable-output/
source-cards/
approved-for-fable/
excluded-private/
```

## Seed import approach

- `lib/seed-loader.ts` loads `seed-data/*.jsonl` on startup.
- Each JSON line is parsed and inserted into normalized tables inside a single transaction.
- Records with `sensitivity` `private-high` or `local-only` are rejected unless explicitly allowed via a redaction flag.

## How source IDs link end-to-end

- `04_SOURCE_REGISTER.csv` provides canonical `source_id`s.
- Seed records include `source_ids` arrays referencing those IDs.
- In the DB, `sources.id` is the authoritative key and other tables store `source_ids` JSON or join tables for many-to-many relationships.

## Gmail / Drive extension plan

- Future modules create importer functions that transform raw Gmail/Drive artifacts into `email_threads` and `documents` rows.
- They only call the existing data import APIs; schema changes are not required for basic ingestion.

## Risks and assumptions

- Assumes developer runs on Windows and can run PowerShell scripts for inventory.
- Sensitive materials must be redacted or excluded before sending to Fable.

## Next steps

1. Finalise `schema-draft.sql` in this folder.
2. Create `first-commit-scope.md` and `risk-register.md`.
3. Implement minimal scaffold in `fable-output/scaffold/` and test seed import with a small JSONL export of approved items.
