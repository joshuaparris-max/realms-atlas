import fs from 'fs'
import path from 'path'
import Database from 'better-sqlite3'

const DB_PATH = path.join(process.cwd(), 'db', 'joshos-atlas.db')
const SEED_DIR = path.join(process.cwd(), 'seed-data')

export function ensureDb() {
  if (!fs.existsSync(path.dirname(DB_PATH))) fs.mkdirSync(path.dirname(DB_PATH), { recursive: true })
  const db = new Database(DB_PATH)
  return db
}

export function loadJsonlSeed(filename: string) {
  const p = path.join(SEED_DIR, filename)
  if (!fs.existsSync(p)) throw new Error('seed file not found: ' + p)
  const lines = fs.readFileSync(p, 'utf-8').split(/\r?\n/).filter(Boolean)
  const db = ensureDb()
  const insert = db.prepare('INSERT OR REPLACE INTO sources (id,name,type,location,sensitivity,confidence,notes,created_at,updated_at) VALUES (?,?,?,?,?,?,?,?,?)')
  const tx = db.transaction((rows: any[]) => {
    for (const r of rows) insert.run(r.id, r.name, r.type, r.location || '', r.sensitivity || '', r.confidence || 'medium', r.notes || '', new Date().toISOString(), new Date().toISOString())
  })
  const parsed = lines.map(l => JSON.parse(l))
  tx(parsed)
  db.close()
}
