# Seed Data Format

Use JSONL.

Each line is one object.

## Required fields

Every seed record must include:

- `id`
- `type`
- `sensitivity`
- `source_ids`
- `confidence`

Confidence values:

- `high`
- `medium`
- `low`

Low-confidence records are not approved for Fable unless Josh manually approves them.

## Repo record

```json
{"id":"repo_001","type":"repo","name":"JoshHub","owner":"joshualparris","url":"https://github.com/joshualparris/JoshHub","visibility":"unknown","purpose":"Personal app hub/dashboard","stack":"Next.js/Tailwind/unknown","deployment_urls":["https://josh-hub-two.vercel.app/dashboard"],"status":"investigate","sensitivity":"private-low","duplicate_group":"hub-dashboard","recommended_action":"make canonical after review","source_ids":["doc_app_audit_2026"],"confidence":"medium"}
```

## Deployment record

```json
{"id":"deploy_001","type":"deployment","name":"JoshHub dashboard","url":"https://josh-hub-two.vercel.app/dashboard","linked_repo":"repo_001","platform":"vercel","status":"unknown","sensitivity":"private-low","source_ids":["doc_app_links_2026"],"confidence":"medium"}
```

## Action record

```json
{"id":"action_001","type":"action","title":"Decide canonical JoshHub repo","priority":"P1","status":"open","project_id":"repo_001","source_ids":["doc_app_audit_2026"],"owner":"Josh","timeframe":"this week","confidence":"high"}
```

## Privacy risk record

```json
{"id":"risk_001","type":"privacy_risk","title":"Child names appear in public app/repo/deployment names","severity":"P0","status":"open","affected_sources":["repo_sylvie_app","repo_elias_app"],"recommended_action":"Privatise, rename, or de-index public surfaces","source_ids":["doc_family_public_threat_model"],"confidence":"high"}
```

## Extensibility acceptance criterion

The seed data format must support future Gmail and Google Drive ingestion without structural rework.

A developer should be able to add a Gmail ingestion module by creating:

- a new `lib/gmail/` directory
- a new `app/inbox/` page
- new rows in `email_threads` and `actions`

without modifying:

- the existing source-card format
- the privacy risk model
- the dashboard data model
- the seed loader contract
