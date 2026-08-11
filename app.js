let PORTALS = [];

// Main application entry point
document.addEventListener('DOMContentLoaded', () => {
    // Fetch portal data from portals.json (the single source of truth)
    fetch('portals.json')
        .then(response => response.json())
        .then(data => {
            // Flatten portals from regions for the game map
            data.regions.forEach(region => {
                if (region.portals) {
                    region.portals.forEach(p => {
                        // Reconstruct original structure needed for the map
                        PORTALS.push({
                            id: p.id,
                            title: p.name,
                            url: p.live,
                            region: p.region,
                            subArea: p.subArea,
                            x: p.x,
                            y: p.y,
                            portalType: p.portalType,
                            status: p.mapStatus || 'active',
                            description: p.desc,
                            shortLabel: p.shortLabel,
                            tags: p.tags,
                            flavourText: p.flavourText,
                            discovered: p.discovered,
                            visited: p.visited
                        });
                    });
                }
            });
            window.PORTALS = PORTALS;
            
            // Initialize game state now that data is ready
            if (typeof initGame === 'function') {
                initGame();
            }

            if (typeof renderSystem !== 'undefined') {
                renderSystem.updateAll();
            }
            
            // Add welcome message
            setTimeout(() => {
                renderSystem.addToEventLog('The map was not made to be read.');
                renderSystem.addToEventLog('It was made to be walked.');
                renderSystem.addToEventLog('');
                renderSystem.addToEventLog('At dawn you stand at the Lantern Crossroads, where nine roads leave the same hill in nine impossible directions.');
            }, 500);
            
            // Add some atmospheric events
            setTimeout(() => {
                renderSystem.addToEventLog('A wind moves across the page.');
                renderSystem.addToEventLog('The Atlas awakens.');
            }, 2000);
        })
        .catch(err => {
            console.error("Failed to load portals.json", err);
            document.body.innerHTML = '<div style="color:white;padding:20px;">Failed to load map data. Please try again.</div>';
        });
});

// Global helper functions for the render system
function addToEventLog(message) {
    renderSystem.addToEventLog(message);
}

// Debug function (can be called from console)
window.debugGameState = () => {
    console.log('Current Game State:', gameState);
    console.log('Discovered Portals:', gameState.player.discoveredPortals);
    console.log('Visited Portals:', gameState.player.visitedPortals);
    console.log('Journal Entries:', gameState.player.journalEntries);
};

// Export stable helpers for debugging
window.saveSystem = saveSystem;
window.mapSystem = mapSystem;
window.renderSystem = renderSystem;
window.inputSystem = inputSystem;