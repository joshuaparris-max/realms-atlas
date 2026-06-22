# The Atlas of Broken Realms

A text-based adventure game that serves as a portal to explore Josh's entire portfolio of web applications and games.

## Overview

This is not just a launcher—it's a complete playable game where you explore a fantasy overworld map, discover regions, and find portals that open Josh's projects in new browser tabs. The game tracks your discoveries, maintains a journal, and provides a cohesive narrative experience.

## Features

- **Explorable World Map**: Move around a large fantasy world with fog-of-war discovery
- **Regional Themes**: 9 distinct regions, each with unique atmosphere and portals
- **Portal System**: 60+ portals to Josh's apps and games, categorized by type and status
- **Persistent Save**: LocalStorage-based save system with auto-save
- **Multiple Input Methods**: Text commands, buttons, and keyboard shortcuts
- **Journal System**: Track discoveries and visited realms
- **Responsive Design**: Works on desktop and mobile

## How to Play

1. **Movement**: Use arrow keys, WASD, or click the direction buttons
2. **Exploration**: Move around to reveal the map and discover portals
3. **Portals**: Click on discovered portals in the sidebar or use "enter [portal name]"
4. **Commands**: Type commands like "look", "map", "journal", or "help"
5. **Progress**: Your discoveries are automatically saved

## World Regions

- **Lantern Crossroads** (Starting Hub)
- **Whispering Forest** (Wilds & Adventure Games)
- **Nullstone Caverns** (Dark & Mystery Games)
- **The Infinite City** (Productivity & Meta Apps)
- **Scholar's Reach** (Lore & RPG Tools)
- **Sword Coast Marches** (Classic Fantasy Games)
- **Maker's Strand** (Educational & Tech Tools)
- **Hearthlands** (Wellness & Lifestyle Apps)
- **Boundary Road Frontier** (Travel & Utility Apps)
- **Outer Sky** (Experimental & Far Realms)

## Portal Types

- **Stable Portals**: Fully functional, polished projects
- **Echo Portals**: Alternate versions or mirrors
- **Broken Portals**: Projects with known issues
- **Sealed Portals**: Not yet accessible
- **Hidden Portals**: Secret discoveries

## Technical Details

### Architecture
- **Frontend**: Plain HTML/CSS/JavaScript (no frameworks)
- **Persistence**: LocalStorage with JSON serialization
- **Deployment**: Static hosting (GitHub Pages, Vercel, etc.)
- **Dependencies**: None required

### File Structure
```
/
├── index.html          # Main HTML structure
├── styles.css          # Game styling and themes
├── app.js             # Main application logic
├── data/
│   ├── regions.js     # World region definitions
│   └── portals.js     # Portal catalog
└── systems/
    ├── save.js        # Save/load system
    ├── map.js         # Map generation and management
    ├── render.js      # UI rendering system
    ├── input.js       # Input handling
    └── gameState.js   # Game state management
```

## Adding New Portals

To add a new portal to the game:

1. Edit `data/portals.js`
2. Add a new object to the `PORTALS` array with these properties:
   ```javascript
   {
       id: 'unique-id',
       title: 'Display Name',
       url: 'https://example.com',
       region: 'region_id',
       subArea: 'Location Description',
       x: 10, y: 15,  // Coordinates in world
       portalType: 'stable', // stable, echo, broken, sealed, hidden
       status: 'active',     // active, broken, etc.
       description: 'Long description',
       shortLabel: 'Short name',
       tags: ['tag1', 'tag2'],
       flavourText: 'Atmospheric description',
       discovered: false,
       visited: false
   }
   ```

## Deployment

### GitHub Pages
1. Push to a GitHub repository
2. Go to Settings → Pages
3. Select "Deploy from a branch"
4. Choose main/master branch
5. The game will be available at `https://username.github.io/repository-name/`

### Vercel
1. Connect your GitHub repository
2. Vercel will auto-deploy
3. Get a URL like `https://your-project.vercel.app`

### Other Static Hosts
- Netlify
- GitLab Pages
- Any static file server

## Browser Compatibility

Works in all modern browsers with JavaScript enabled:
- Chrome 60+
- Firefox 55+
- Safari 12+
- Edge 79+

## Contributing

This game is designed to be easily extensible. To add new regions, portals, or features:

1. **New Regions**: Add to `data/regions.js` and update `REGION_CONNECTIONS`
2. **New Portals**: Add to `data/portals.js` array
3. **New Features**: Extend the system classes in `/systems/`
4. **UI Changes**: Modify `styles.css` and `index.html`

## Purpose

`realms-atlas` is a **portfolio gateway**: a single, playful entry point that ties Josh's
many web apps and games together as a fantasy overworld. Rather than a flat list of links,
each project is a "portal" placed in a themed region, discovered through exploration. It
doubles as a fun showcase piece and a practical launcher.

## Portal & link validation notes

- Portals are defined in [`data/portals.js`](data/portals.js) — currently **61 portals**.
- Each portal has a `portalType` that signals link health:
  - `stable` (42) — expected to work
  - `echo` (16) — alternate version or mirror of another project
  - `broken` (2) — known to be down or non-functional
  - `sealed` (1) — intentionally not yet accessible
- Because portals open external deployments (Vercel, GitHub Pages, itch.io), links can rot
  over time. Treat `portalType` as the source of truth and update it as deployments change.
- To re-validate, open `data/portals.js` and check each `url`. Mark anything dead as
  `portalType: 'broken'` so it renders accordingly instead of silently failing.

## Portal status (known)

A few linked deployments are known to be unreliable and are/should be flagged `broken`:

- **Parris Dubbo Mover** — client loads but its API/backend is down.
- **ClearCore** / **Forbidden Quests** — observed returning blank pages.

The strongest, reliably-working portals include JoshHub, the Parris Tech apps, LifeHub
Dashboard, Null, Mystery Depths, StarHaven, and Wild2.

## Fallback behaviour

- The portal **sidebar list** always shows discovered portals as plain clickable entries,
  so the experience degrades gracefully even if the ASCII map view is hard to read.
- A `<noscript>` block explains the project and points to this README when JavaScript is
  disabled.

## Known issues

- The ASCII/text map can be dense on small screens — use the sidebar portal list instead.
- Link rot: external portals may go offline; statuses need periodic review (see above).
- No automated link-checker yet (see Future improvements).

## Future improvements

- A small automated link-checker script to flag dead `url`s and auto-suggest `broken`.
- Optional grid/graphical map layer on top of the ASCII view.
- A simple "list all portals" view for quick scanning without exploration.

## License

This project is part of Josh's portfolio and is shared for demonstration purposes.

## Credits

Created by Josh as a meta-exploration game for his web development portfolio. All linked projects are also created by Josh unless otherwise noted.
## Portal Index (list view) & The Revived Isles

Alongside the immersive map, there is now a plain, reliable **Portal Index** at
[`launcher.html`](launcher.html): a searchable, filterable list of every portal with honest
**status badges** (Live / Prototype / Needs repair / Idea) and direct *Open* + *Code* links.
It reads from [`portals.json`](portals.json) — the single place to edit portal data.

A special region, **The Revived Isles**, collects the 12 small repos revived as working MVPs
(games, wellbeing tools, trackers) with their live links. The map and the list cross-link.

See [STATUS.md](STATUS.md) for current state and next steps.
