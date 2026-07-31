# Privacy Risk Cards

<!--
HOW TO USE THIS FILE

Generate these from:
- family_public_information_threat_model.pdf
- sylvie_child_privacy_osint_audit.pdf
- elias_child_privacy_osint_audit.pdf
- TODO_MASTER.md (security section)
- Script 3 output (embedded credentials)

These cards feed directly into Section 4 of the Fable prompt (privacy-risk-report).
-->

## Privacy Risk Card Template

```
## Privacy Risk Card: [risk-title]

Source ID: risk_XXX
Title: [short descriptive title]
Severity: [P0 / P1 / P2 / P3]
Description: [what the risk is and why it matters]
Affected sources: [list of source IDs]
Recommended action: [specific step]
Owner: Josh
Timeframe: [24 hours / this week / this month]
Status: open
Evidence/source IDs: [doc_family_public_threat_model, etc.]
Confidence: [high / medium / low]
```

## Severity guide

| Level | Meaning | Example |
|-------|---------|---------|
| P0 | Immediate — real harm possible now | Child name in public repo/deployment |
| P1 | Urgent — fix within days | Exposed API key in committed file |
| P2 | Important — fix this week | Public repo with private app logic |
| P3 | Low — fix when convenient | Stale public deployment of abandoned app |

---

<!-- PASTE GENERATED CARDS BELOW THIS LINE -->

## Privacy Risk Card: Child names in public repos and deployments

Source ID: risk_001
Title: Child names (Sylvie, Elias) appear in public repo names and live deployment URLs
Severity: P0
Description: At least three repos (SylviePhonetics, SylvieApp, Sleepy) and their corresponding GitHub Pages deployments are publicly accessible and contain a child's name. This creates a searchable, permanent public record linking a child's name to a parent's GitHub identity.
Affected sources: repo_sylviephonetics, repo_sylvieapp, repo_sleepy, deploy_sleepy_ghpages, deploy_sylviephonetics_ghpages
Recommended action: Immediately change all three repos to private. Rename to neutral names. Remove or redirect GitHub Pages deployments.
Owner: Josh
Timeframe: 24 hours
Status: open
Evidence/source IDs: doc_family_public_threat_model, doc_sylvie_privacy_audit, doc_elias_privacy_audit
Confidence: high
