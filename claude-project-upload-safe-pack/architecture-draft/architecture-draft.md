# Architecture Draft

Generate this on Day 11 using Sonnet 4.6 or ChatGPT.
Feed all approved source cards + source register.
Fable will critique and finalise this.

## Tech Stack Proposal

- Framework: Next.js 14 (App Router)
- Language: TypeScript
- Database: SQLite via better-sqlite3
- Styling: Tailwind CSS
- No Prisma, no Docker, no WSL requirement
- Runs on Windows natively

## Proposed Folder Structure

```
joshos-atlas/
  package.json
  tsconfig.json
  next.config.ts
  tailwind.config.ts
  .gitignore
  seed-data/
  src/
    app/
      layout.tsx
      page.tsx
      dashboard/page.tsx
      projects/page.tsx
      sources/page.tsx
      actions/page.tsx
      privacy/page.tsx
    lib/
      db.ts
      seed.ts
      types.ts
    components/
      StatusBadge.tsx
      SensitivityBadge.tsx
      RiskBadge.tsx
      SourceLink.tsx
```

## Open Questions for Fable

- Which dashboard layout best fits 40+ repos?
- How should duplicate groups be visualised?
- How should the Gmail module attach later without schema changes?
