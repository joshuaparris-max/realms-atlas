-- JoshOS Atlas Draft Schema
-- Fable will produce the final version

CREATE TABLE IF NOT EXISTS sources (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  location TEXT,
  sensitivity TEXT NOT NULL,
  confidence TEXT NOT NULL,
  include_now INTEGER DEFAULT 1,
  notes TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS repos (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  owner TEXT NOT NULL,
  url TEXT,
  visibility TEXT,
  purpose TEXT,
  stack TEXT,
  deployment_urls TEXT,
  last_activity TEXT,
  local_folder_path TEXT,
  status TEXT,
  sensitivity TEXT NOT NULL,
  duplicate_group TEXT,
  recommended_action TEXT,
  next_action TEXT,
  source_ids TEXT,
  confidence TEXT NOT NULL,
  needs_review INTEGER DEFAULT 0,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS deployments (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  url TEXT NOT NULL,
  platform TEXT,
  linked_repo_id TEXT REFERENCES repos(id),
  status TEXT,
  sensitivity TEXT NOT NULL,
  recommended_action TEXT,
  source_ids TEXT,
  confidence TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS privacy_risks (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  severity TEXT NOT NULL,
  description TEXT,
  affected_source_ids TEXT,
  recommended_action TEXT,
  owner TEXT DEFAULT 'Josh',
  timeframe TEXT,
  status TEXT DEFAULT 'open',
  source_ids TEXT,
  confidence TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS actions (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  priority TEXT NOT NULL,
  status TEXT DEFAULT 'open',
  description TEXT,
  concrete_next_step TEXT,
  project_id TEXT,
  source_ids TEXT,
  owner TEXT DEFAULT 'Josh',
  timeframe TEXT,
  confidence TEXT NOT NULL,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS weekly_reviews (
  id TEXT PRIMARY KEY,
  week_of TEXT NOT NULL,
  matters_this_week TEXT,
  ignore_this_week TEXT,
  fix_this_week TEXT,
  finish_this_week TEXT,
  reflect_on TEXT,
  next_action TEXT,
  notes TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now'))
);
