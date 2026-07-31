# Fallback Plan — What To Do If The Fable Session Goes Wrong

## Core rule

A Fable session that produces broken code is NOT a failure.
Broken code can be fixed by Sonnet/Claude Code in minutes.
A Fable session only truly fails if it ignores privacy rules or invents source facts.

---

## Scenario 1 — Scaffold runs but has errors

**Symptom:** `npm install && npm run dev` fails with TypeScript errors, missing imports, or runtime crashes.

**Do not:** Re-run the full Fable prompt.

**Do:**
1. Save the scaffold exactly as produced — it is still the architectural source of truth
2. Open Claude Code (Sonnet 4.6)
3. Feed it only: the broken file(s) + the exact error message
4. Say: "Make this run locally. Preserve the architecture and file structure. Do not refactor."
5. Apply the fix, test, repeat until `npm run dev` works

---

## Scenario 2 — Architecture contradicts stack constraints

**Symptom:** Fable designed with Prisma, Docker, Pages Router, or requires WSL.

**Do not:** Re-run the full prompt.

**Do:**
1. Extract only: Section 1 (architecture-decision-record), your stack constraints block, and the specific contradiction
2. Run a targeted Fable pass (new conversation):
   > "Revise only Section 1 — architecture-decision-record. Stack constraints are unchanged (App Router, TypeScript, better-sqlite3, no Prisma, no Docker, Windows native). Do not regenerate scaffold or other sections. Record your reasoning."
3. Apply the revised architecture before handing scaffold work to Sonnet

---

## Scenario 3 — Repo decisions are missing or wrong

**Symptom:** canonical-repo-map.md has wrong owners, missing repos, or decisions that don't match your source cards.

**Do not:** Re-run the full prompt.

**Do:**
1. Fix the specific source cards that were wrong
2. Run a targeted pass:
   > "Update only Section 2 — canonical-repo-map.md based on these corrected cards: [paste corrected cards only]. Do not regenerate other sections."

---

## Scenario 4 — Output is cut off mid-section

**Symptom:** Response ends abruptly before all 10 sections are complete.

**Do not:** Start a new conversation.

**Do:**
1. In the same conversation thread, paste the last complete H1 heading from the output
2. Say: "Continue from Section [N] — [filename]. Do not repeat previous sections."
3. Repeat until all sections are complete
4. Keep the same thread so context is preserved

---

## Scenario 5 — Privacy rules were ignored

**Symptom:** Fable includes child names, health data, school data, or real credentials in seed files or code.

**This is an actual failure.**

**Do:**
1. Do not commit or save the output with private data in it
2. Manually remove the offending content from seed files
3. Re-run a targeted pass for the affected section only, with explicit emphasis:
   > "Regenerate only Section 8 seed-data files. Rules: all seed data must use fake placeholder values. No child names, no real health data, no credentials. Sensitivity private-high or local-only items use [SAMPLE_DATA] placeholders only."

---

## Scenario 6 — Fable access is not free / cost concern

**Symptom:** The free/included access window has expired or was not confirmed.

**Do:**
1. Compress all source cards by removing fields with value "unknown" → `"needs_review": true` (reduces input tokens ~20–30%)
2. Use Batch API (`claude-fable-5` with batch flag) — halves price to $5/$25 per million tokens
3. Split into two focused passes:
   - **Pass A** — Sections 1–5: architecture, schema, repo map, privacy report, top 10 actions
   - **Pass B** — Sections 6–10: templates, README, scaffold, test plan, implementation plan
4. Use prompt caching: after Pass A, Pass B context hits are ~$1/M instead of $10/M
5. Estimated total cost with these optimisations: ~$8–15 USD for both passes

---

## Definition of success

The Fable session succeeds if it produces:
- [ ] A working local-first app direction
- [ ] A canonical map of repos and deployments with decisions
- [ ] A privacy/security risk triage list with P0 items
- [ ] A top 10 action list with specific next steps
- [ ] A clear first commit scope
- [ ] A scaffold that Sonnet/Claude Code can finish if needed
- [ ] An architecture that allows Gmail and Drive ingestion as future modules without structural rework

The Fable session fails only if:
- It ignores privacy boundaries
- It invents source facts without marking them as assumptions
- It cannot cite source IDs for recommendations
- It produces no usable architecture
- It produces no usable next actions

Broken code alone is not failure.
