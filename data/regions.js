// World regions data
const REGIONS = {
    lantern_crossroads: {
        id: 'lantern_crossroads',
        name: 'Lantern Crossroads',
        description: 'The central hub where nine roads leave the same hill in nine impossible directions.',
        flavor: 'Lanterns hang from ancient posts, their flames dancing in colors that don\'t exist in ordinary light.',
        color: '#e94560',
        terrain: 'crossroads',
        size: { width: 21, height: 21 },
        center: { x: 10, y: 10 }
    },
    
    whispering_forest: {
        id: 'whispering_forest',
        name: 'Whispering Forest',
        description: 'Ancient forest where the trees murmur secrets and wild magic flows through the air.',
        flavor: 'The wind carries voices that sound like memories of choices not yet made.',
        color: '#2e8b57',
        terrain: 'forest',
        size: { width: 25, height: 25 },
        center: { x: 5, y: 10 }
    },
    
    nullstone_caverns: {
        id: 'nullstone_caverns',
        name: 'Nullstone Caverns',
        description: 'Dark caves beneath the world, filled with echoes and silent chambers.',
        flavor: 'The stone absorbs sound, but sometimes you hear what others have forgotten.',
        color: '#2f4f4f',
        terrain: 'caves',
        size: { width: 20, height: 20 },
        center: { x: 10, y: 15 }
    },
    
    infinite_city: {
        id: 'infinite_city',
        name: 'The Infinite City',
        description: 'A surreal metropolis of brass towers and impossible elevators.',
        flavor: 'Paperwork magic governs the streets, and every door leads to another office.',
        color: '#daa520',
        terrain: 'city',
        size: { width: 30, height: 30 },
        center: { x: 15, y: 5 }
    },
    
    scholars_reach: {
        id: 'scholars_reach',
        name: 'Scholar\'s Reach',
        description: 'Libraries and observatories where knowledge is both weapon and treasure.',
        flavor: 'The air smells of old books and distant stars.',
        color: '#4b0082',
        terrain: 'library',
        size: { width: 22, height: 22 },
        center: { x: 18, y: 8 }
    },
    
    sword_coast_marches: {
        id: 'sword_coast_marches',
        name: 'Sword Coast Marches',
        description: 'Classic fantasy lands of taverns, keeps, and ancient roads.',
        flavor: 'The scent of ale and adventure hangs in the air.',
        color: '#8b4513',
        terrain: 'fantasy',
        size: { width: 28, height: 28 },
        center: { x: 20, y: 12 }
    },
    
    makers_strand: {
        id: 'makers_strand',
        name: 'Maker\'s Strand',
        description: 'Workshops and classrooms where practical magic meets skilled hands.',
        flavor: 'The hum of devices and the scent of fresh parchment fill the air.',
        color: '#ff6347',
        terrain: 'workshop',
        size: { width: 18, height: 18 },
        center: { x: 12, y: 18 }
    },
    
    hearthlands: {
        id: 'hearthlands',
        name: 'Hearthlands',
        description: 'Cozy villages and healing springs where support and care are the greatest magic.',
        flavor: 'The air smells of baking bread and fresh herbs.',
        color: '#deb887',
        terrain: 'village',
        size: { width: 20, height: 20 },
        center: { x: 8, y: 8 }
    },
    
    boundary_road_frontier: {
        id: 'boundary_road_frontier',
        name: 'Boundary Road Frontier',
        description: 'Open roads and frontier lands where movement defines reality.',
        flavor: 'Dust devils dance on the horizon, and distant wagons creak.',
        color: '#a0522d',
        terrain: 'frontier',
        size: { width: 24, height: 24 },
        center: { x: 15, y: 20 }
    },
    
    outer_sky: {
        id: 'outer_sky',
        name: 'Outer Sky',
        description: 'Sky bridges and star ports where the world thins to dreams.',
        flavor: 'The ground feels uncertain beneath your feet.',
        color: '#191970',
        terrain: 'sky',
        size: { width: 16, height: 16 },
        center: { x: 22, y: 18 }
    }
};

// Terrain symbols for map display
const TERRAIN_SYMBOLS = {
    crossroads: '┼',
    forest: '♠',
    deep_forest: '♣',
    tree: '♣',
    road: '═',
    mountain: '▲',
    cave: '●',
    river: '~',
    sea: '≈',
    city: '□',
    ruins: '▒',
    tower: '▲',
    village: '⌂',
    frontier: '∩',
    sky: '☆',
    plains: '·',
    lantern: '✦',
    portal: '◎',
    player: '◆',
    unknown: '?'
};

// Region connections (for world atlas)
const REGION_CONNECTIONS = {
    lantern_crossroads: ['whispering_forest', 'nullstone_caverns', 'infinite_city', 'scholars_reach', 'sword_coast_marches', 'makers_strand', 'hearthlands', 'boundary_road_frontier', 'outer_sky'],
    whispering_forest: ['lantern_crossroads'],
    nullstone_caverns: ['lantern_crossroads'],
    infinite_city: ['lantern_crossroads'],
    scholars_reach: ['lantern_crossroads'],
    sword_coast_marches: ['lantern_crossroads'],
    makers_strand: ['lantern_crossroads'],
    hearthlands: ['lantern_crossroads'],
    boundary_road_frontier: ['lantern_crossroads'],
    outer_sky: ['lantern_crossroads']
};