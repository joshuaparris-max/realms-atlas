# First Commit Scope

## What the first version includes

- Local Next.js app with SQLite
- JSONL seed data loader
- /dashboard, /projects, /sources, /actions, /privacy pages
- StatusBadge, SensitivityBadge, RiskBadge, SourceLink components
- README with setup steps

## What it does NOT include

- Gmail OAuth or inbox ingestion
- Google Drive sync
- Live Vercel API
- Public deployment with real data

## Acceptance criteria

- [ ] npm install && npm run dev works with no errors
- [ ] Seed data loads from seed-data/*.jsonl on first run
- [ ] All 5 pages render
- [ ] Top repos visible in /projects with status, sensitivity, duplicate group
- [ ] P0 risks highlighted in /privacy
- [ ] Actions ranked by priority in /actions
- [ ] .gitignore covers .env*, *.db, raw-inventory/, excluded-private/
- [ ] No real private data in seed files
- [ ] README explains setup from clone to running

## Extensibility Acceptance Criterion

The first build passes if a Gmail module can be added by creating:
- src/lib/gmail/ directory
- src/app/inbox/ page
- New tables in existing schema

WITHOUT modifying existing tables, seed.ts, dashboard, or privacy model.
