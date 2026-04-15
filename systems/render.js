// Rendering system for updating the UI
class RenderSystem {
    constructor() {
        this.elements = {};
        // Don't cache elements here - DOM might not be ready
    }

    cacheElements() {
        if (Object.keys(this.elements).length > 0) return; // Already cached
        
        this.elements = {
            mapDisplay: document.getElementById('map-display'),
            locationDescription: document.getElementById('description-text'),
            nearbyList: document.getElementById('nearby-list'),
            portalsList: document.getElementById('portals-list'),
            eventLog: document.getElementById('event-log'),
            playerPosition: document.getElementById('player-position'),
            discoveryCount: document.getElementById('discovery-count'),
            journalContent: document.getElementById('journal-content')
        };
    }

    renderMap() {
        this.cacheElements();
        const mapData = mapSystem.generateLocalMap(
            gameState.player.x,
            gameState.player.y,
            gameState.player.region
        );
        
        const mapHtml = mapSystem.renderMap(mapData, gameState.player.x, gameState.player.y);
        this.elements.mapDisplay.innerHTML = mapHtml;
    }

    renderLocation() {
        this.cacheElements();
        const region = REGIONS[gameState.player.region];
        const currentRegion = mapSystem.getRegionAt(gameState.player.x, gameState.player.y);
        
        // Update header
        this.elements.playerPosition.textContent = currentRegion.name;
        
        // Update description
        let description = `${currentRegion.description}\n\n${currentRegion.flavor || ''}\n\nPosition: (${gameState.player.x}, ${gameState.player.y})`;
        this.elements.locationDescription.textContent = description.trim();
        
        // Update discovery count
        const discoveredPortals = gameState.player.discoveredPortals.length;
        this.elements.discoveryCount.textContent = `Realms Discovered: ${discoveredPortals}`;
    }

    renderNearby() {
        this.cacheElements();
        const nearbyPortals = getNearbyPortals(gameState.player.x, gameState.player.y, 3);
        const nearbyLandmarks = this.getNearbyLandmarks();
        
        let html = '';
        
        // Add landmarks
        nearbyLandmarks.forEach(landmark => {
            html += `<li>${landmark}</li>`;
        });
        
        // Add portal hints if any are nearby but not discovered
        const undiscoveredPortals = nearbyPortals.filter(p => !gameState.isPortalDiscovered(p.id));
        undiscoveredPortals.slice(0, 2).forEach(portal => {
            const dx = portal.x - gameState.player.x;
            const dy = portal.y - gameState.player.y;
            const dirX = dx === 0 ? '' : (dx > 0 ? 'east' : 'west');
            const dirY = dy === 0 ? '' : (dy > 0 ? 'south' : 'north');
            const dir = [dirY, dirX].filter(Boolean).join('-');
            html += `<li class="hint">A portal shimmer lies ${dir || 'nearby'}.</li>`;
        });
        
        this.elements.nearbyList.innerHTML = html;
    }

    renderPortals() {
        this.cacheElements();
        const nearbyPortals = getNearbyPortals(gameState.player.x, gameState.player.y, 2);
        const discoveredNearby = nearbyPortals.filter(p => gameState.isPortalDiscovered(p.id));
        
        let html = '';
        
        if (discoveredNearby.length === 0) {
            html = '<li class="empty">No portals nearby</li>';
        } else {
            discoveredNearby.forEach(portal => {
                const visited = gameState.isPortalVisited(portal.id);
                const visitedClass = visited ? 'visited' : '';
                const statusClass = portal.status === 'broken' ? 'broken' : 
                                   portal.status === 'sealed' ? 'sealed' : '';
                
                html += `
                    <li class="portal-${portal.portalType} ${visitedClass} ${statusClass}" 
                        data-portal-id="${portal.id}">
                        ${portal.shortLabel}
                        ${visited ? ' ✓' : ''}
                    </li>
                `;
            });
        }
        
        this.elements.portalsList.innerHTML = html;
        
        // Add click handlers
        this.elements.portalsList.querySelectorAll('li[data-portal-id]').forEach(li => {
            li.addEventListener('click', () => {
                const portalId = li.dataset.portalId;
                this.handlePortalClick(portalId);
            });
        });
    }

    handlePortalClick(portalId) {
        const portal = getPortalById(portalId);
        if (!portal) return;
        
        // Mark as visited
        if (!gameState.isPortalVisited(portalId)) {
            gameState.visitPortal(portalId);
            this.addJournalEntry(`Entered ${portal.title} for the first time.`);
            saveSystem.save();
        }
        
        // Show portal entry message
        this.addToEventLog(`Entering ${portal.title}...`);
        
        // Open in new tab
        setTimeout(() => {
            window.open(portal.url, '_blank', 'noopener,noreferrer');
        }, 500);
        
        // Re-render to show visited status
        this.renderPortals();
    }

    getNearbyLandmarks() {
        const landmarks = [];
        const currentRegion = mapSystem.getRegionAt(gameState.player.x, gameState.player.y);
        
        // Add region-specific landmarks
        switch (currentRegion.id) {
            case 'lantern_crossroads':
                landmarks.push('Ancient stone lanterns');
                landmarks.push('Nine branching roads');
                break;
            case 'whispering_forest':
                landmarks.push('Ancient oak grove');
                landmarks.push('Moss-covered standing stones');
                landmarks.push('Whispering wind through the leaves');
                break;
            case 'nullstone_caverns':
                landmarks.push('Echoing cave entrances');
                landmarks.push('Silent underground lakes');
                landmarks.push('Strange glowing fungi');
                break;
            case 'infinite_city':
                landmarks.push('Brass towers reaching impossible heights');
                landmarks.push('Elevators that reorganize themselves');
                landmarks.push('Paperwork that moves on its own');
                break;
            case 'scholars_reach':
                landmarks.push('Towering libraries');
                landmarks.push('Floating candles');
                landmarks.push('Maps that redraw themselves');
                break;
            case 'sword_coast_marches':
                landmarks.push('Roadside taverns');
                landmarks.push('Ancient keeps');
                landmarks.push('Quest boards covered in postings');
                break;
            case 'makers_strand':
                landmarks.push('Humming workshops');
                landmarks.push('Signal towers');
                landmarks.push('Classrooms filled with curious devices');
                break;
            case 'hearthlands':
                landmarks.push('Cozy village hearths');
                landmarks.push('Healing springs');
                landmarks.push('Baking aromas on the wind');
                break;
            case 'boundary_road_frontier':
                landmarks.push('Dust-covered wagons');
                landmarks.push('Courier waystations');
                landmarks.push('Vague horizons');
                break;
            case 'outer_sky':
                landmarks.push('Uncertain ground beneath your feet');
                landmarks.push('Stars visible during the day');
                landmarks.push('Bridges to nowhere');
                break;
        }
        
        return landmarks;
    }

    addToEventLog(message) {
        this.cacheElements();
        const p = document.createElement('p');
        p.textContent = message;
        p.className = 'fade-in';
        
        this.elements.eventLog.appendChild(p);
        this.elements.eventLog.scrollTop = this.elements.eventLog.scrollHeight;
        
        // Limit log entries
        while (this.elements.eventLog.children.length > 20) {
            this.elements.eventLog.removeChild(this.elements.eventLog.firstChild);
        }
    }

    addJournalEntry(entry) {
        gameState.player.journalEntries.push({
            text: entry,
            timestamp: Date.now(),
            location: `${gameState.player.x}, ${gameState.player.y}`
        });
        
        this.renderJournal();
    }

    renderJournal() {
        this.cacheElements();
        let html = '';
        
        if (gameState.player.journalEntries.length === 0) {
            html = '<p>Your journal is empty. Discover portals to fill its pages.</p>';
        } else {
            gameState.player.journalEntries.forEach(entry => {
                const date = new Date(entry.timestamp).toLocaleDateString();
                html += `<p><strong>${date}</strong> - ${entry.text}</p>`;
            });
        }
        
        this.elements.journalContent.innerHTML = html;
    }

    updateAll() {
        this.cacheElements();
        if (typeof gameState === 'undefined' || !gameState || !gameState.player) return;
        this.renderMap();
        this.renderLocation();
        this.renderNearby();
        this.renderPortals();
        this.renderJournal();
    }

    showModal(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.remove('hidden');
        }
    }

    hideModal(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.add('hidden');
        }
    }
}

// Global render system instance
const renderSystem = new RenderSystem();