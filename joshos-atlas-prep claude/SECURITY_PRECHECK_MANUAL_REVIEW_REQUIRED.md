# Security Precheck Manual Review Required

Generated: 2026-06-10 20:32:49

Do not run full Fable until this is completed by Josh.

## Files to review locally

- raw-inventory/risky-files.csv
- raw-inventory/token-string-hits.csv
- raw-inventory/embedded-credential-remotes.csv

## How to classify each hit

Use one of:
- real-secret-rotated
- false-positive
- example-only
- deleted
- excluded-from-fable
- needs-more-work

## Sign-off checklist

- [ ] I reviewed risky-files.csv
- [ ] I reviewed token-string-hits.csv
- [ ] I confirmed embedded-credential-remotes.csv is empty or handled
- [ ] I rotated any real keys/tokens
- [ ] I removed or excluded unsafe files from upload packs
- [ ] I did not upload raw token/path scan CSVs to Fable
- [ ] I updated 00_SECURITY_PRECHECK.md with results

## Result

Security precheck status: NOT SIGNED YET
