# Privacy Rules Cards

## privacy_rules_001 - Private-high raw files must not enter Fable

Source type: rules-only card
Sensitivity: private-high
Confidence: high

Source says:
- Child, NDIS, health, tenancy/legal, school/student/staff, financial, family-private, and OSINT/privacy files must not be raw-uploaded to Fable.

Interpretation:
- These files may be represented by source IDs, filenames, and rules-only summaries.
- Fable may reason about privacy process and risk classes, but not raw contents.

Recommended action:
- Keep raw files in excluded-private/source-pdfs-private-review.
- Create source cards that describe only safe metadata, risk class, and allowed handling.

Affected source examples:
- family_public_information_threat_model.pdf
- joshua_parris_public_osint_audit.pdf
- Joshua_Parris_OSINT_Audit.pdf
- sylvie_child_privacy_osint_audit.pdf
- elias_child_privacy_osint_audit.pdf
- NDIS/Sylvie reports
- Mould/tenancy/legal report

Fable allowed use:
- Use these sources to create privacy rules, gating decisions, and rename/privatise recommendations.

Fable forbidden use:
- Do not summarise personal contents.
- Do not quote private details.
- Do not generate public seed data from these files.
