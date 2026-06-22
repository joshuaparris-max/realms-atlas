# Status — realms-atlas

## What works now
- Immersive ASCII overworld map (existing `index.html`) — explore, discover, journal.
- **New: Portal Index** (`launcher.html`) — a reliable list/fallback view of all portals with:
  - status badges (Live / Prototype / Needs repair / Idea)
  - search + category filters (game / wellbeing / tools / utility / fun)
  - Open + Code links per portal
- **New: "The Revived Isles"** region (`portals.json`) listing all 12 revived repos with live links.
- Map and list cross-link to each other.

## Next steps
- Migrate the map to read from `portals.json` so there's one source of truth.
- Automated link-checker to flag dead `live` URLs and flip them to "repair".
- An About/Journal screen describing the portfolio.
