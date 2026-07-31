# Seed Data Format

Use JSONL (JSON Lines). Each line is one complete JSON object.
Files live in `seed-data/` and are loaded by `src/lib/seed.ts` at startup.

## Required fields on every record

Every seed record must include:

| Field | Description |
|-------|-------------|
| `id` | Unique string ID, e.g. `repo_001` |
| `type` | Record type (see types below) |
| `sensitivity` | Sensitivity level (see taxonomy) |
| `source_ids` | Array of source IDs this record is derived from |
| `confidence` | `high` / `medium` / `low` |

**Low-confidence records are excluded from the Fable input unless Josh manually approves them.**

## Sensitivity values

- `public-safe`
- `private-low`
- `private-medium`
- `private-high`
- `local-only`
- `do-not-upload`

## Repo record

```jsonl
{"id":"repo_001","type":"repo","name":"JoshHub","owner":"joshualparris","url":"https://github.com/joshualparris/JoshHub","visibility":"unknown","purpose":"Personal app hub/dashboard","stack":"Next.js/Tailwind/unknown","deployment_urls":["https://josh-hub-two.vercel.app/dashboard"],"status":"investigate","sensitivity":"private-low","duplicate_group":"hub-dashboard","recommended_action":"make canonical after review","source_ids":["doc_app_audit_2026"],"confidence":"medium"}
```

## Deployment record

```jsonl
{"id":"deploy_001","type":"deployment","name":"JoshHub dashboard","url":"https://josh-hub-two.vercel.app/dashboard","linked_repo":"repo_001","platform":"vercel","status":"unknown","sensitivity":"private-low","source_ids":["doc_app_links_2026"],"confidence":"medium"}
```

## Action record

```jsonl
{"id":"action_001","type":"action","title":"Decide canonical JoshHub repo","priority":"P1","status":"open","project_id":"repo_001","source_ids":["doc_app_audit_2026"],"owner":"Josh","timeframe":"this week","confidence":"high"}
```

## Privacy risk record

```jsonl
{"id":"risk_001","type":"privacy_risk","title":"Child names appear in public app/repo/deployment names","severity":"P0","status":"open","affected_sources":["repo_sleepy","repo_sylviephonetics","repo_sylvieapp"],"recommended_action":"Privatise repos, rename to neutral names, de-index public deployments","source_ids":["doc_family_public_threat_model","doc_sylvie_privacy_audit"],"confidence":"high"}
```

## Document card record

```jsonl
{"id":"doc_001","type":"document","name":"App Audit 2026","file":"__@App Audit 2026.docx","doc_type":"audit","sensitivity":"private-medium","key_facts":["JoshHub identified as likely canonical hub","Multiple duplicate dashboard apps exist","Public child-named repos flagged as risk"],"action_items":["Consolidate hub apps","Privatise child-named repos"],"date":"2026","source_ids":["doc_app_audit_2026"],"confidence":"high"}
```

## Email thread card record

```jsonl
{"id":"email_001","type":"email_thread","thread":"AppFactory CI failure","date_range":"2026-01 to 2026-06","category":"ci-failure","sensitivity":"private-medium","summary":"AppFactory CI pipeline has been failing on the copilot-polish branch","key_facts":["Feature branch: feature/copilot-appfactory-polish-and-next-mvp","Repeated failures suggest broken test or missing dependency"],"open_actions":["Fix AppFactory CI"],"related_project":"repo_appfactory","source_ids":["email_github_ci_failures"],"confidence":"medium"}
```

## Workspace card record

```jsonl
{"id":"workspace_001","type":"workspace","path":"C:\\dev\\JoshHub_1","likely_repo":"repo_joshhub","git_remote":"https://github.com/joshualparris/JoshHub","git_status":"dirty","dirty_files":[],"secrets_risk":"unknown","duplicate_risk":"medium","recommended_action":"Confirm as canonical JoshHub source; clean dirty files","source_ids":["doc_computer3_audit"],"confidence":"medium"}
```

## Seed data rules

1. All seed files use fake/placeholder values for `private-high` or `local-only` items.
2. No real API keys, tokens, health data, child content, or school data in any seed file.
3. Seed files are committed to the repo only if they contain no private data.
4. Private seed data lives in `excluded-private/` and is never committed.
