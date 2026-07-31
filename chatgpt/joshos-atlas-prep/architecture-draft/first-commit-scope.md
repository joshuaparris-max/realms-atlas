# First Commit Scope

## Build only this

- local Next.js app
- SQLite database
- manual JSONL source-card importer
- `/dashboard`
- `/projects`
- `/sources`
- `/actions`
- `/privacy`
- static seed data only

## Do not build yet

- Gmail OAuth
- Google Drive sync
- live Vercel API integration
- raw health/child/finance document ingestion
- public deployment with private data

## Acceptance criteria

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

## Extensibility Acceptance Criterion

The first build passes this criterion if and only if:

A developer can add a Gmail ingestion module by creating:

- a new `lib/gmail/` directory
- a new `app/inbox/` page
- new rows in the `email_threads` and `actions` tables

without modifying:

- the existing schema tables
- the seed loader
- the dashboard page
- the privacy risk model
- any existing source card format

If adding Gmail requires structural changes to existing tables or components, the architecture fails this criterion and must be revised before the Fable session.
