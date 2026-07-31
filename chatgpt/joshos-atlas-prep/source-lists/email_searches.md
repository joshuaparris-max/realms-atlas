# Gmail Search Queries

Do not ingest the whole mailbox.

Create source cards from selected threads only.

## GitHub / deployment / CI

```text
from:notifications@github.com newer_than:180d
```

```text
subject:("Run failed" OR "Deploy" OR "invited you") newer_than:180d
```

Include:

- AppFactory CI failures
- WorkApp GitHub Pages failure
- HealthLens failure
- DCSCompanion invite
- campaign-copilot invite
- SylvieApp invite
- WhirringWilderness invite
- AshFallen invite
- AvancePD invite
- AvanceProfessionalDevelopment invite

## Property / rental / mould

```text
("Mould in shed" OR "101 Boundary Road" OR NCAT OR newtaas OR drea) newer_than:180d
```

Include only source-card summaries unless doing a private tenancy module.

## Job / career

```text
(NAB OR SEEK OR "Customer Advisor" OR "Application update" OR "application received" OR "Dubbo") newer_than:180d
```

Include:

- NAB Customer Advisor 2 emails
- Coles/Woolworths/SEEK updates
- DCS/Avance/Marathon/ABS job material if relevant

## AI/tooling

```text
(Claude OR "Claude Code" OR Anthropic OR Codex OR Copilot OR OpenRouter OR Bolt) newer_than:365d
```

## Health/admin — private only

```text
(HeartBug OR Holter OR GP OR pathology OR sertraline OR optometrist OR Medicare OR Medibank OR Frank) newer_than:365d
```

## Kids/therapy/NDIS — private only

```text
(Sylvie OR Elias OR NDIS OR OT OR speech OR therapy OR paediatrician OR Peppercorn OR Gidgee OR PsychSolutions) newer_than:365d
```
