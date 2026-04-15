// Game state management
class GameState {
    constructor() {
        this.player = {
            x: 10,
            y: 10,
            region: 'lantern_crossroads',
            discoveredRegions: ['lantern_crossroads'],
            visitedPortals: [],
            discoveredPortals: [],
            journalEntries: [],
            fastTravelPoints: ['lantern_crossroads']
        };
        
        this.discoveredTiles = {};
        this.settings = {
            soundEnabled: false,
            compactMode: false,
            reducedMotion: false
        };
        
        this.loadGame();
        this.applySettings();
    }

    loadGame() {
        const savedData = saveSystem.load() || saveSystem.defaultSave;
        this.player = savedData.player || { ...saveSystem.defaultSave.player };
        this.discoveredTiles = savedData.game?.discoveredTiles || {};
        this.settings = savedData.game?.settings || { ...saveSystem.defaultSave.game.settings };

        // Ensure starting area is revealed even before the global gameState variable exists
        mapSystem.revealTilesAround(this.player.x, this.player.y, 3, this.discoveredTiles);
    }

    saveGame() {
        saveSystem.save();
    }

    resetGame() {
        saveSystem.reset();
        this.loadGame();
    }

    updatePlayerPosition(x, y) {
        this.player.x = x;
        this.player.y = y;
        
        // Update region
        const region = mapSystem.getRegionAt(x, y);
        if (region.id !== this.player.region) {
            this.player.region = region.id;
            if (!this.player.discoveredRegions.includes(region.id)) {
                this.player.discoveredRegions.push(region.id);
            }
        }
        
        this.saveGame();
    }

    discoverPortal(portalId) {
        if (!this.player.discoveredPortals.includes(portalId)) {
            this.player.discoveredPortals.push(portalId);
            this.saveGame();
        }
    }

    visitPortal(portalId) {
        if (!this.player.visitedPortals.includes(portalId)) {
            this.player.visitedPortals.push(portalId);
            this.saveGame();
        }
    }

    addJournalEntry(entry) {
        this.player.journalEntries.push({
            text: entry,
            timestamp: Date.now(),
            location: `${this.player.x}, ${this.player.y}`
        });
        this.saveGame();
    }

    getDiscoveredPortalsCount() {
        return this.player.discoveredPortals.length;
    }

    getVisitedPortalsCount() {
        return this.player.visitedPortals.length;
    }

    getTotalPortalsCount() {
        return PORTALS.length;
    }

    isPortalDiscovered(portalId) {
        return this.player.discoveredPortals.includes(portalId);
    }

    isPortalVisited(portalId) {
        return this.player.visitedPortals.includes(portalId);
    }

    getCompletionPercentage() {
        const discovered = this.getDiscoveredPortalsCount();
        const total = this.getTotalPortalsCount();
        return total > 0 ? Math.round((discovered / total) * 100) : 0;
    }

    // Settings management
    updateSetting(setting, value) {
        this.settings[setting] = value;
        this.saveGame();
        
        // Apply setting changes
        this.applySettings();
    }

    applySettings() {
        // Apply compact mode
        document.body.classList.toggle('compact', this.settings.compactMode);
        
        // Apply reduced motion
        document.body.classList.toggle('reduced-motion', this.settings.reducedMotion);
        
        // Sound setting (placeholder for future implementation)
        if (this.settings.soundEnabled) {
            // Enable sound effects
        } else {
            // Disable sound effects
        }
    }

    // Utility methods
    getCurrentRegion() {
        return REGIONS[this.player.region];
    }

    getNearbyPortals(radius = 3) {
        return getNearbyPortals(this.player.x, this.player.y, radius);
    }

    canMoveTo(x, y) {
        return mapSystem.isValidMove(x, y);
    }
}

// Global game state instance
let gameState;

// Initialize game state when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    gameState = new GameState();
    window.gameState = gameState;

    if (typeof inputSystem !== 'undefined' && inputSystem.checkPortalDiscovery) {
        inputSystem.checkPortalDiscovery();
    }

    if (typeof renderSystem !== 'undefined') {
        renderSystem.updateAll();
        renderSystem.addToEventLog('Welcome to The Atlas of Broken Realms!');
        renderSystem.addToEventLog('Type "help" or click the buttons to get started.');
    }

    saveSystem.startAutoSave();
});