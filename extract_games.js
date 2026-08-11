const fs = require('fs');
let content = fs.readFileSync('C:/dev/joshos-atlas/data/portals.js', 'utf8');
content = content.replace('const PORTALS =', 'module.exports =');
fs.writeFileSync('C:/dev/joshos-atlas/data/portals_temp.js', content);
const PORTALS = require('./data/portals_temp.js');

console.log(Object.keys(PORTALS[0]));

fs.unlinkSync('C:/dev/joshos-atlas/data/portals_temp.js');
