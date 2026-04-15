// Input handling system
class InputSystem {
    constructor() {
        this.commandHistory = [];
        this.historyIndex = -1;
        this.setupEventListeners();
    }

    setupEventListeners() {
        // Command input
        const commandField = document.getElementById('command-field');
        const submitBtn = document.getElementById('submit-cmd');
        
        submitBtn.addEventListener('click', () => this.processCommand());
        commandField.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                this.processCommand();
            } else if (e.key === 'ArrowUp') {
                e.preventDefault();
                this.navigateHistory(-1);
            } else if (e.key === 'ArrowDown') {
                e.preventDefault();
                this.navigateHistory(1);
            }
        });
        
        // Quick action buttons
        document.querySelectorAll('.action-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const cmd = btn.dataset.cmd;
                this.executeCommand(cmd);
            });
        });
        
        // Map controls
        document.getElementById('local-map-btn').addEventListener('click', () => {
            this.setMapView('local');
        });
        document.getElementById('region-map-btn').addEventListener('click', () => {
            this.setMapView('region');
        });
        document.getElementById('world-atlas-btn').addEventListener('click', () => {
            this.setMapView('world');
        });
        
        // Modal controls
        document.querySelectorAll('.close').forEach(closeBtn => {
            closeBtn.addEventListener('click', () => {
                const modal = closeBtn.closest('.modal');
                renderSystem.hideModal(modal.id);
            });
        });
        
        // Settings
        document.getElementById('reset-game')?.addEventListener('click', () => {
            if (confirm('Are you sure you want to reset the game? This cannot be undone.')) {
                this.resetGame();
            }
        });
        
        // Keyboard shortcuts
        document.addEventListener('keydown', (e) => {
            this.handleGlobalKeydown(e);
        });
        
        // Journal button
        document.querySelector('[data-cmd="journal"]')?.addEventListener('click', () => {
            renderSystem.showModal('journal-modal');
        });
    }

    processCommand() {
        const commandField = document.getElementById('command-field');
        const command = commandField.value.trim().toLowerCase();
        
        if (command) {
            this.executeCommand(command);
            this.commandHistory.push(command);
            this.historyIndex = this.commandHistory.length;
            commandField.value = '';
        }
    }

    executeCommand(command) {
        const parts = command.split(' ');
        const action = parts[0];
        const args = parts.slice(1);
        
        renderSystem.addToEventLog(`> ${command}`);
        
        switch (action) {
            case 'north':
            case 'n':
                this.movePlayer(0, -1);
                break;
            case 'south':
            case 's':
                this.movePlayer(0, 1);
                break;
            case 'east':
            case 'e':
                this.movePlayer(1, 0);
                break;
            case 'west':
            case 'w':
                this.movePlayer(-1, 0);
                break;
            case 'look':
            case 'l':
                this.lookAround();
                break;
            case 'map':
            case 'm':
                this.showMap();
                break;
            case 'region':
            case 'r':
                this.showRegion();
                break;
            case 'atlas':
            case 'a':
                this.showAtlas();
                break;
            case 'enter':
                this.enterPortal(args.join(' '));
                break;
            case 'journal':
            case 'j':
                renderSystem.showModal('journal-modal');
                break;
            case 'help':
            case 'h':
            case '?':
                this.showHelp();
                break;
            case 'settings':
                renderSystem.showModal('settings-modal');
                break;
            case 'reset':
                if (confirm('Are you sure you want to reset the game?')) {
                    this.resetGame();
                }
                break;
            default:
                renderSystem.addToEventLog("I don't understand that command. Type 'help' for available commands.");
        }
    }

    movePlayer(dx, dy) {
        if (typeof gameState === 'undefined' || !gameState || !gameState.player) {
            renderSystem.addToEventLog('The Atlas is still waking. Refresh the page once.');
            return;
        }

        const newX = gameState.player.x + dx;
        const newY = gameState.player.y + dy;
        
        if (mapSystem.isValidMove(newX, newY)) {
            gameState.player.x = newX;
            gameState.player.y = newY;
            
            // Update region if changed
            const newRegion = mapSystem.getRegionAt(newX, newY);
            if (newRegion.id !== gameState.player.region) {
                gameState.player.region = newRegion.id;
                if (!gameState.player.discoveredRegions.includes(newRegion.id)) {
                    gameState.player.discoveredRegions.push(newRegion.id);
                    renderSystem.addToEventLog(`You discover ${newRegion.name}!`);
                    renderSystem.addJournalEntry(`Discovered ${newRegion.name}.`);
                }
            }
            
            // Reveal tiles around new position
            mapSystem.revealTilesAround(newX, newY);
            
            // Check for portal discoveries
            this.checkPortalDiscovery();
            
            // Save game
            saveSystem.save();
            
            // Update display
            renderSystem.updateAll();
            
            renderSystem.addToEventLog(`You move ${dx !== 0 ? (dx > 0 ? 'east' : 'west') : (dy > 0 ? 'south' : 'north')}.`);
        } else {
            renderSystem.addToEventLog("You cannot go that way.");
        }
    }

    checkPortalDiscovery() {
        const nearbyPortals = getNearbyPortals(gameState.player.x, gameState.player.y, 2);
        
        nearbyPortals.forEach(portal => {
            if (!gameState.isPortalDiscovered(portal.id)) {
                gameState.discoverPortal(portal.id);
                
                renderSystem.addToEventLog(`You discover a portal: ${portal.title}!`);
                renderSystem.addJournalEntry(`Discovered portal to ${portal.title} in ${portal.subArea}.`);
            }
        });
    }

    lookAround() {
        if (typeof gameState === 'undefined' || !gameState || !gameState.player) return;
        const currentRegion = mapSystem.getRegionAt(gameState.player.x, gameState.player.y);
        renderSystem.addToEventLog(`You are in ${currentRegion.name}. ${currentRegion.flavor}`);
    }

    showMap() {
        renderSystem.addToEventLog("You consult your map. The world unfolds before you.");
        // Map is always visible, so just focus attention on it
    }

    showRegion() {
        const region = REGIONS[gameState.player.region];
        renderSystem.addToEventLog(`Current region: ${region.name} - ${region.description}`);
    }

    showAtlas() {
        const discoveredCount = gameState.player.discoveredPortals.length;
        const totalPortals = PORTALS.length;
        renderSystem.addToEventLog(`Atlas shows ${discoveredCount} of ${totalPortals} known portals discovered.`);
    }

    enterPortal(portalName) {
        const nearbyPortals = getNearbyPortals(gameState.player.x, gameState.player.y, 2);
        const portal = nearbyPortals.find(p => 
            p.title.toLowerCase().includes(portalName.toLowerCase()) ||
            p.shortLabel.toLowerCase().includes(portalName.toLowerCase())
        );
        
        if (portal) {
            renderSystem.handlePortalClick(portal.id);
        } else {
            renderSystem.addToEventLog("No such portal nearby.");
        }
    }

    showHelp() {
        const helpText = `
Available commands:
• north/south/east/west (or n/s/e/w) - Move in that direction
• look (l) - Examine your surroundings
• map (m) - View your map
• region (r) - Show current region info
• atlas (a) - Show atlas statistics
• enter [portal name] - Enter a nearby portal
• journal (j) - View your journal
• help (h) - Show this help
• settings - Open settings

You can also use the buttons or arrow keys to move.`;
        
        renderSystem.addToEventLog(helpText);
    }

    setMapView(view) {
        mapSystem.setView(view);

        // Update button states
        document.querySelectorAll('#map-controls button').forEach(btn => {
            btn.classList.remove('active');
        });

        const viewButtonIds = {
            local: 'local-map-btn',
            region: 'region-map-btn',
            world: 'world-atlas-btn'
        };
        document.getElementById(viewButtonIds[view])?.classList.add('active');

        renderSystem.addToEventLog(`Switched to ${view} map view.`);
        renderSystem.renderMap();
    }

    navigateHistory(direction) {
        if (this.commandHistory.length === 0) return;
        
        this.historyIndex += direction;
        
        if (this.historyIndex < 0) {
            this.historyIndex = -1;
            document.getElementById('command-field').value = '';
        } else if (this.historyIndex >= this.commandHistory.length) {
            this.historyIndex = this.commandHistory.length;
            document.getElementById('command-field').value = '';
        } else {
            document.getElementById('command-field').value = this.commandHistory[this.historyIndex];
        }
    }

    handleGlobalKeydown(e) {
        // Arrow key movement
        switch (e.key) {
            case 'ArrowUp':
                if (e.target.tagName !== 'INPUT' && e.target.tagName !== 'TEXTAREA') {
                    e.preventDefault();
                    this.movePlayer(0, -1);
                }
                break;
            case 'ArrowDown':
                if (e.target.tagName !== 'INPUT' && e.target.tagName !== 'TEXTAREA') {
                    e.preventDefault();
                    this.movePlayer(0, 1);
                }
                break;
            case 'ArrowLeft':
                if (e.target.tagName !== 'INPUT' && e.target.tagName !== 'TEXTAREA') {
                    e.preventDefault();
                    this.movePlayer(-1, 0);
                }
                break;
            case 'ArrowRight':
                if (e.target.tagName !== 'INPUT' && e.target.tagName !== 'TEXTAREA') {
                    e.preventDefault();
                    this.movePlayer(1, 0);
                }
                break;
            case 'w':
            case 'W':
                if (e.target.tagName !== 'INPUT' && e.target.tagName !== 'TEXTAREA') {
                    e.preventDefault();
                    this.movePlayer(0, -1);
                }
                break;
            case 'a':
            case 'A':
                if (e.target.tagName !== 'INPUT' && e.target.tagName !== 'TEXTAREA') {
                    e.preventDefault();
                    this.movePlayer(-1, 0);
                }
                break;
            case 's':
            case 'S':
                if (e.target.tagName !== 'INPUT' && e.target.tagName !== 'TEXTAREA') {
                    e.preventDefault();
                    this.movePlayer(0, 1);
                }
                break;
            case 'd':
            case 'D':
                if (e.target.tagName !== 'INPUT' && e.target.tagName !== 'TEXTAREA') {
                    e.preventDefault();
                    this.movePlayer(1, 0);
                }
                break;
        }
    }

    resetGame() {
        saveSystem.reset();
        location.reload();
    }
}

// Global input system instance
const inputSystem = new InputSystem();