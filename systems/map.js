// Map generation and management system
class MapSystem {
    constructor() {
        this.currentView = 'local'; // 'local', 'region', 'world'
        this.mapSize = { width: 21, height: 21 }; // Local view size
        this.worldBounds = { minX: 0, maxX: 40, minY: 0, maxY: 40 };
    }

    generateLocalMap(centerX, centerY, regionId) {
        const map = [];
        const region = REGIONS[regionId];
        
        for (let y = 0; y < this.mapSize.height; y++) {
            const row = [];
            for (let x = 0; x < this.mapSize.width; x++) {
                const worldX = centerX - Math.floor(this.mapSize.width / 2) + x;
                const worldY = centerY - Math.floor(this.mapSize.height / 2) + y;
                
                const tile = this.getTileAt(worldX, worldY, region);
                row.push(tile);
            }
            map.push(row);
        }
        
        return map;
    }

    getTileAt(x, y, region) {
        // Check if tile is discovered
        const tileKey = `${x},${y}`;
        const isDiscovered = gameState.discoveredTiles[tileKey];
        
        if (!isDiscovered) {
            return { symbol: '?', type: 'unknown', discovered: false };
        }
        
        // Check for portals at this location
        const portal = this.getPortalAt(x, y);
        if (portal) {
            return {
                symbol: TERRAIN_SYMBOLS.portal,
                type: 'portal',
                portal: portal,
                discovered: true
            };
        }
        
        // Generate terrain based on region and position
        return this.generateTerrainTile(x, y, region);
    }

    getPortalAt(x, y) {
        return PORTALS.find(portal => portal.x === x && portal.y === y);
    }

    generateTerrainTile(x, y, region) {
        // Simple terrain generation based on region type
        const regionType = region.terrain;
        let symbol = TERRAIN_SYMBOLS[regionType] || TERRAIN_SYMBOLS.crossroads;
        
        // Add some variation based on position
        const noise = (x * 7 + y * 13) % 100;
        const originX = REGIONS.lantern_crossroads.center.x;
        const originY = REGIONS.lantern_crossroads.center.y;
        
        switch (regionType) {
            case 'crossroads': {
                const dx = x - originX;
                const dy = y - originY;
                const onMainRoad = (Math.abs(dx) <= 8 && dy === 0) || (Math.abs(dy) <= 8 && dx === 0);
                const onRing = Math.abs(dx) === 4 || Math.abs(dy) === 4;
                
                if (onMainRoad) {
                    symbol = TERRAIN_SYMBOLS.road;
                } else if (onRing && Math.abs(dx) <= 8 && Math.abs(dy) <= 8 && noise % 2 === 0) {
                    symbol = TERRAIN_SYMBOLS.road;
                } else if ((Math.abs(dx) === 2 && Math.abs(dy) === 2) || (Math.abs(dx) === 6 && dy === 0) || (dx === 0 && Math.abs(dy) === 6)) {
                    symbol = TERRAIN_SYMBOLS.lantern;
                } else if (noise < 15) {
                    symbol = TERRAIN_SYMBOLS.plains;
                } else if (noise < 30) {
                    symbol = TERRAIN_SYMBOLS.village;
                } else {
                    symbol = TERRAIN_SYMBOLS.crossroads;
                }
                break;
            }
            case 'forest':
                if (noise < 20) symbol = TERRAIN_SYMBOLS.deep_forest;
                else if (noise < 40) symbol = TERRAIN_SYMBOLS.tree;
                else if (noise < 50) symbol = TERRAIN_SYMBOLS.plains;
                break;
            case 'caves':
                if (noise < 30) symbol = TERRAIN_SYMBOLS.cave;
                else if (noise < 45) symbol = TERRAIN_SYMBOLS.ruins;
                break;
            case 'city':
                if (noise < 25) symbol = TERRAIN_SYMBOLS.ruins;
                else if (noise < 50) symbol = TERRAIN_SYMBOLS.tower;
                else if (noise < 60) symbol = TERRAIN_SYMBOLS.road;
                break;
            case 'fantasy':
                if (noise < 20) symbol = TERRAIN_SYMBOLS.ruins;
                else if (noise < 40) symbol = TERRAIN_SYMBOLS.village;
                else if (noise < 50) symbol = TERRAIN_SYMBOLS.road;
                break;
            case 'frontier':
                if (noise < 30) symbol = TERRAIN_SYMBOLS.road;
                else if (noise < 45) symbol = TERRAIN_SYMBOLS.plains;
                break;
            case 'village':
                if (noise < 30) symbol = TERRAIN_SYMBOLS.village;
                else if (noise < 45) symbol = TERRAIN_SYMBOLS.plains;
                break;
            case 'workshop':
                if (noise < 35) symbol = TERRAIN_SYMBOLS.tower;
                else if (noise < 55) symbol = TERRAIN_SYMBOLS.road;
                break;
            case 'library':
                if (noise < 30) symbol = TERRAIN_SYMBOLS.tower;
                else if (noise < 50) symbol = TERRAIN_SYMBOLS.ruins;
                break;
            case 'sky':
                if (noise < 40) symbol = TERRAIN_SYMBOLS.sky;
                else if (noise < 55) symbol = TERRAIN_SYMBOLS.road;
                break;
        }
        
        return {
            symbol: symbol,
            type: regionType,
            discovered: true
        };
    }

    revealTilesAround(x, y, radius = 2, discoveredTiles = null) {
        const tileStore = discoveredTiles || (typeof gameState !== 'undefined' && gameState ? gameState.discoveredTiles : null);
        if (!tileStore) return;

        for (let dy = -radius; dy <= radius; dy++) {
            for (let dx = -radius; dx <= radius; dx++) {
                const tileX = x + dx;
                const tileY = y + dy;
                const distance = Math.sqrt(dx * dx + dy * dy);

                if (distance <= radius) {
                    const tileKey = `${tileX},${tileY}`;
                    tileStore[tileKey] = true;
                }
            }
        }
    }

    isValidMove(x, y) {
        // Check world bounds
        if (x < this.worldBounds.minX || x > this.worldBounds.maxX ||
            y < this.worldBounds.minY || y > this.worldBounds.maxY) {
            return false;
        }
        
        // For now, allow movement anywhere within bounds
        // Could add terrain restrictions later
        return true;
    }

    getRegionAt(x, y) {
        // Find which region contains these coordinates
        for (const [regionId, region] of Object.entries(REGIONS)) {
            const centerX = region.center.x;
            const centerY = region.center.y;
            const distance = Math.sqrt(Math.pow(x - centerX, 2) + Math.pow(y - centerY, 2));
            
            // Simple region detection - could be more sophisticated
            if (distance < 15) { // Arbitrary radius
                return region;
            }
        }
        
        return REGIONS.lantern_crossroads; // Default fallback
    }

    renderMap(mapData, playerX, playerY) {
        let output = '';
        
        mapData.forEach((row, y) => {
            row.forEach((tile, x) => {
                const worldX = playerX - Math.floor(this.mapSize.width / 2) + x;
                const worldY = playerY - Math.floor(this.mapSize.height / 2) + y;
                
                let symbol = tile.symbol || TERRAIN_SYMBOLS.unknown || '?';
                
                // Style based on tile type
                let className = 'map-tile';
                if (tile.type === 'unknown') {
                    className += ' unknown';
                } else if (tile.type === 'portal') {
                    className += ` portal ${tile.portal.portalType}`;
                } else {
                    className += ` ${tile.type}`;
                }

                // Add player marker
                if (worldX === playerX && worldY === playerY) {
                    symbol = TERRAIN_SYMBOLS.player;
                    className += ' player';
                }
                
                output += `<span class="${className}" data-x="${worldX}" data-y="${worldY}" title="${tile.type}">${symbol}</span>`;
            });
            output += '\n';
        });
        
        return output;
    }

    setView(viewType) {
        this.currentView = viewType;
        // Could implement different rendering for region/world views
    }

    getView() {
        return this.currentView;
    }
}

// Global map system instance
const mapSystem = new MapSystem();