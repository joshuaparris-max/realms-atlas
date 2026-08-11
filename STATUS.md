# Status — realms-atlas

## What works now
- Immersive ASCII overworld map (existing `index.html`) — explore, discover, journal.
- **New: Portal Index** (`launcher.html`) — a reliable list/fallback view of all portals with:
  - status badges (Live / Prototype / Needs repair / Idea)
  - search + category filters (game / wellbeing / tools / utility / fun)
  - Open + Code links per portal
- **New: "The Revived Isles"** region (`portals.json`) listing all 12 revived repos with live links.
- Map and list cross-link to each other.
- **Unified Data**: The entire map and launcher now read from `portals.json` as the single source of truth.

## Next steps
- Automated link-checker to flag dead `live` URLs and flip them to "repair".
- An About/Journal screen describing the portfolio.
