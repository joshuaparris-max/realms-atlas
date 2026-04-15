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

## License

This project is part of Josh's portfolio and is shared for demonstration purposes.

## Credits

Created by Josh as a meta-exploration game for his web development portfolio. All linked projects are also created by Josh unless otherwise noted.