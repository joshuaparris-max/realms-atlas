# Fable Cost and Access Notes

Verify current access and pricing inside your Claude account before running the final Fable session.

Known planning assumptions from the conversation:

- Fable should be used for synthesis, architecture, and long-context reasoning.
- Do not use Fable to scrape or read raw private dumps.
- Use cheaper tools to create source cards.
- Use approved/redacted source cards only.

## Message Batches API note

Anthropic’s Message Batches API is asynchronous and offers 50% pricing compared with standard API pricing, but it is not eligible for Zero Data Retention.

Do not use batch processing for raw private-high, child, health, school, tenancy, financial, or family material.

Use it only for approved, redacted source cards.
