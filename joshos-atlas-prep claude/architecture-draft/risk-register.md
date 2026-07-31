# Risk Register

| Risk ID | Title | Likelihood | Impact | Mitigation |
|---------|-------|-----------|--------|------------|
| tech_001 | better-sqlite3 install fails on Windows | Medium | High | Test install before Fable session |
| tech_002 | Fable generates Pages Router instead of App Router | Low | Medium | Stack constraints explicit in prompt |
| privacy_001 | Fable ignores privacy constraints | Low | High | Explicit rules in prompt; manual review of output |
| privacy_002 | Quality gate missed private content | Medium | High | Day 10 checklist; double-check before upload |
| scope_001 | Fable session cut off before all 10 sections | Medium | Medium | Fallback: continue from last heading in same thread |
| scope_002 | Free Fable window expired | Medium | Medium | Batch API; split into two passes |
| data_001 | Source cards have wrong sensitivity labels | Medium | High | Human quality gate on Day 10 |
