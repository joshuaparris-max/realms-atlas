# Podcast Integration TODO

**Decision:** Add.  
**Status:** ✅ Core one-click podcast bank added 13 September 2026.  
**Deployment QA:** ✅ GitHub Pages deployment repaired and verified successful 13 September 2026.
**Topic bank:** fantasy worldbuilding, RPG settings, mythology, cartography, storytelling, fantasy literature.

## TODO
- [x] Use the shared 25-episode D&D/RPG bank for worldbuilding/fantasy learning.
- [x] Add a collapsed bottom dock: **🗺️ Listen to a different worldbuilding podcast**.
- [x] One tap selects/loads another episode; persist recent selections and avoid immediate repeats.
- [x] Use Spotify embed/deep links without assuming autoplay.
- [x] Shared tags cover maps, cultures, story craft, RPG settings and fantasy themes.
- [x] Collapse when standard HTML audio/video begins and while the user is typing commands.
- [x] Keep atlas/exploration interactions primary through the collapsed dock design.
- [x] Shared dock supplies mobile/a11y, reduced-motion and persistence behaviour; app-specific tests can be added later.
- [x] Remove malformed unused gitlinks that prevented GitHub Pages from checking out the repository.

## Implementation
`index.html` loads JoshHub's shared `dnd` catalogue through `podcast-dock-universal.js`.

## Deployment incident and fix
GitHub Pages checkout failed because the repository contained two unused gitlink entries, `OS-clone` and `fable`, without matching `.gitmodules` URLs. They were removed from `main`. The next Pages workflow run completed successfully.

This is now part of the release rule: a podcast integration is not marked working until the production deployment can check out, build, deploy, and render the actual app end-to-end.
