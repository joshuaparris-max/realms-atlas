# Model Routing Guide

Which AI to use for which task throughout the JoshOS Atlas build.

## Core principle

Fable 5 is the synthesis engine, not the scraper.
Use cheap models for extraction, Fable only for the hard synthesis pass.

---

## Task Routing Table

| Task | Best tool | Why |
|------|-----------|-----|
| Create folder structure and placeholder files | PowerShell (you) | No AI needed |
| Run secret scans | PowerShell scripts | No AI needed |
| Write personal context and privacy boundaries | You | Needs your judgment |
| Generate repo source cards from README/package.json | ChatGPT (GPT-4o) | Fast, cheap, good at structured extraction |
| Generate doc cards from PDFs/audit docs | Sonnet 4.6 | Good at summarisation, handles PDFs |
| Generate email source cards from thread exports | ChatGPT or Sonnet | Either works |
| Architecture draft (first pass) | Sonnet 4.6 | Cheap, good enough for a draft Fable will critique |
| Second opinion on architecture | ChatGPT | Compare outputs, take the best |
| Human quality gate | You | Critical — cannot be delegated |
| **Full synthesis pass** | **Fable 5** | Long context, hard decisions, scaffold generation |
| Post-Fable scaffold debugging | Claude Code (Sonnet) | Purpose-built for agentic coding |
| React/Next.js component work | Claude Code (Sonnet) | Cheap and fast |
| CSS/styling fixes | Claude Code (Sonnet) | Don't waste Fable on this |
| Quick syntax questions | ChatGPT | Fastest for one-off queries |
| Major architecture additions (Gmail, Drive) | Fable 5 (targeted) | New complex layer needs synthesis |
| Weekly review generation | Sonnet 4.6 | Cheap, repeatable |

---

## ChatGPT's role in this project

ChatGPT is your fast, cheap scratchpad and second-opinion tool.

**Use ChatGPT for:**
- Bulk repo card generation (feed README + package.json, get structured card back)
- Quick architecture second opinions
- Boilerplate generation
- Debugging specific errors
- Comparing approaches

**Do not use ChatGPT for:**
- The full Atlas synthesis (it won't hold the full context reliably)
- Anything involving private-high sensitivity data
- The Fable session (that's Claude Fable 5 only)

---

## Cost reference (June 2026 pricing)

| Model | Input per 1M tokens | Output per 1M tokens |
|-------|--------------------|--------------------|
| Claude Haiku 4.5 | ~$0.25 | ~$1.25 |
| Claude Sonnet 4.6 | ~$3 | ~$15 |
| Claude Opus 4.8 | ~$15 | ~$75 |
| **Claude Fable 5** | **$10** | **$50** |
| Fable 5 (Batch API) | $5 | $25 |
| Fable 5 (cached input) | ~$1 | $50 |

**Example Fable session cost estimate:**
- 200k input tokens + 50k output = $2.00 + $2.50 = ~$4.50 USD
- With prompt caching on repeated context: ~$1.50 + $2.50 = ~$4.00 USD
- With Batch API: ~$1.00 + $1.25 = ~$2.25 USD

---

## When to use Fable again after the first session

Use Fable for a second targeted pass only when:
- Adding Gmail ingestion architecture (new complex module)
- Adding Google Drive PDF privacy model
- Designing the local-only health/family data layer
- Major repo consolidation strategy (if 20+ repos need decisions at once)
- Whole-system review after 3–6 months of building

Do NOT use Fable for:
- React component bugs
- CSS fixes
- Individual page layouts
- Adding one more card to the dashboard
- Anything Sonnet/Claude Code can handle
