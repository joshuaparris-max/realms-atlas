// Save/Load system for localStorage persistence
const SAVE_KEY = 'atlasOfBrokenRealms_save';

class SaveSystem {
    constructor() {
        this.defaultSave = {
            player: {
                x: 10,
                y: 10,
                region: 'lantern_crossroads',
                discoveredRegions: ['lantern_crossroads'],
                visitedPortals: [],
                discoveredPortals: [],
                journalEntries: [],
                fastTravelPoints: ['lantern_crossroads']
            },
            game: {
                discoveredTiles: {},
                settings: {
                    soundEnabled: false,
                    compactMode: false,
                    reducedMotion: false
                }
            }
        };
    }

    save() {
        try {
            const saveData = {
                player: gameState.player,
                game: {
                    discoveredTiles: gameState.discoveredTiles,
                    settings: gameState.settings
                },
                timestamp: Date.now()
            };
            localStorage.setItem(SAVE_KEY, JSON.stringify(saveData));
            this.logEvent('Game saved successfully');
            return true;
        } catch (error) {
            console.error('Save failed:', error);
            this.logEvent('Save failed');
            return false;
        }
    }

    load() {
        try {
            const savedData = localStorage.getItem(SAVE_KEY);
            if (!savedData) {
                this.logEvent('No save data found, starting fresh');
                return this.defaultSave;
            }

            const parsed = JSON.parse(savedData);
            
            // Merge with defaults to handle missing properties
            const merged = this.deepMerge(this.defaultSave, parsed);
            
            this.logEvent('Game loaded successfully');
            return merged;
        } catch (error) {
            console.error('Load failed:', error);
            this.logEvent('Load failed, using defaults');
            return this.defaultSave;
        }
    }

    reset() {
        try {
            localStorage.removeItem(SAVE_KEY);
            this.logEvent('Game reset successfully');
            return true;
        } catch (error) {
            console.error('Reset failed:', error);
            return false;
        }
    }

    deepMerge(target, source) {
        const result = { ...target };
        
        for (const key in source) {
            if (source[key] && typeof source[key] === 'object' && !Array.isArray(source[key])) {
                result[key] = this.deepMerge(target[key] || {}, source[key]);
            } else {
                result[key] = source[key];
            }
        }
        
        return result;
    }

    logEvent(message) {
        console.log(`[SaveSystem] ${message}`);
        if (typeof addToEventLog === 'function') {
            addToEventLog(message);
        }
    }

    // Auto-save functionality
    startAutoSave(intervalMinutes = 5) {
        this.autoSaveInterval = setInterval(() => {
            this.save();
        }, intervalMinutes * 60 * 1000);
    }

    stopAutoSave() {
        if (this.autoSaveInterval) {
            clearInterval(this.autoSaveInterval);
            this.autoSaveInterval = null;
        }
    }

    // Export save data as JSON string
    exportSave() {
        const saveData = localStorage.getItem(SAVE_KEY);
        return saveData || JSON.stringify(this.defaultSave);
    }

    // Import save data from JSON string
    importSave(jsonString) {
        try {
            const parsed = JSON.parse(jsonString);
            localStorage.setItem(SAVE_KEY, JSON.stringify(parsed));
            this.logEvent('Save data imported successfully');
            return true;
        } catch (error) {
            console.error('Import failed:', error);
            this.logEvent('Save data import failed');
            return false;
        }
    }
}

// Global save system instance
const saveSystem = new SaveSystem();