# Plan Iteration History

A record of how this plan evolved across 6 iterations between Claude and ChatGPT, with honest rankings.

---

## Rankings Summary

| Version | Score | Primary Failure | Primary Strength |
|---------|-------|-----------------|-----------------|
| v1 | 48/100 | No sequence, no safety, no structure | Tiered model routing insight |
| v2 | 71/100 | Wrong sequence, no scripts, no output folder | Privacy as architecture, canonicalisation |
| v3 | 83/100 | No scripts, no calendar, no fallback | Unified structure, seed format, quality gate |
| v4 | 79/100 | Incoherent addendum, unsafe scripts | Real scripts, calendar, fallback plan |
| v5 | 91/100 | Fable prompt cut off, no calendar, no fallback | Single document, stack constraints |
| v6 + addendum | 95/100 | Source register had ~5 missing local-folder rows | Complete Fable prompt, calendar, fallback, extensibility |

---

## Key improvements at each iteration

### v1 → v2 (+23 points)
- Privacy elevated from a bullet point to an architecture concern
- Canonicalisation added as a first-class goal
- Acceptance criteria added
- Quality gate concept introduced
- Three GitHub accounts identified

### v2 → v3 (+12 points)
- Secret scan added as Phase -1
- fable-output/ folder structure defined upfront
- Seed data format defined with JSONL examples
- QUALITY_GATE.md as a formal artefact
- Fable prompt with source ID citation and severity levels
- Confidence gating on source cards

### v3 → v4 (−4 points — regression)
- Scripts added (major positive)
- Calendar added (major positive)
- Fallback plan added (major positive)
- BUT: document split into v3 + addendum = structural incoherence
- Scripts had unsafe edge cases (.git/config scan missing)
- Self-rated 95/100 — was actually 79/100

### v4 → v5 (+12 points)
- Single unified document (major repair)
- Stack constraints as explicit Fable input (new)
- .git/config credential scan added
- Script complementarity noted
- Correct phase sequence throughout
- BUT: Fable prompt cut off; calendar dropped; fallback dropped

### v5 → v6 (+2 points on base, then +4 with addendum)
- Script complementarity note explicit
- Script 4 depth caveat added
- Expanded source register (40+ rows)
- Phase structure matches master build order
- BUT: Fable prompt still cut off in base document; source register truncated
- With addendum: Fable prompt complete, calendar restored, fallback restored, extensibility criterion added

---

## Consistent failure patterns

**ChatGPT pattern:** Adds new sections rather than rewriting the whole document. Creates regressions when integrating feedback alongside new content. Rates its own work too highly (called v4 "95/100" when it was 79/100).

**Most persistent gap:** The Fable prompt was absent or truncated in v5 and v6 — the most important single artefact in the entire plan. Corrected in the final addendum.

---

## What made v6 + addendum work

1. One unified base document (not two documents)
2. Correct sequence: secret scan → boundaries → goals → seed format → inventory → cards → quality gate → architecture → Fable
3. All three security scripts present and complementary
4. Complete 40+ row source register
5. Complete Fable prompt with all 10 output sections defined
6. 12-day calendar with day-by-day checklists
7. Fallback plan for 6 failure scenarios
8. Extensibility acceptance criterion embedded in first-commit-scope

---

## Lessons for using AI to plan complex projects

1. **Be harsh with AI self-assessments.** AI tools rate their own work too generously. An 80/100 from an AI is probably 65/100 in reality.
2. **Regressions happen when adding and not rewriting.** Every time a plan was patched rather than rewritten, something important was dropped.
3. **The most important artefact is the prompt, not the plan.** Six iterations produced one incomplete Fable prompt. The plan is preparation; the prompt is the actual work.
4. **Sequence is the whole design.** A plan with the right steps in the wrong order is worse than a shorter plan with the right order.
5. **Quality gates cannot be automated.** The human review of source cards before the Fable session is the single most important step and cannot be delegated to AI.
