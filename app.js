// Main application entry point
document.addEventListener('DOMContentLoaded', () => {
    // Systems are initialized in gameState.js.

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