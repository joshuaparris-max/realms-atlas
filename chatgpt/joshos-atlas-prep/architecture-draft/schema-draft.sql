-- Schema draft for JoshOS Atlas (SQLite)

PRAGMA foreign_keys = ON;

CREATE TABLE sources (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT,
  location TEXT,
  sensitivity TEXT,
  confidence TEXT,
  include_now INTEGER DEFAULT 0,
  include_later INTEGER DEFAULT 0,
  notes TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- repos table
CREATE TABLE repos (
  id TEXT PRIMARY KEY,
  name TEXT,
  owner TEXT,
  url TEXT,
  visibility TEXT,
  purpose TEXT,
  stack TEXT,
  deployment_urls TEXT, -- JSON array of URLs
  status TEXT,
  sensitivity TEXT,
  source_ids TEXT, -- JSON array of related source IDs
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- deployments
CREATE TABLE deployments (
  id TEXT PRIMARY KEY,
  name TEXT,
  url TEXT,
  platform TEXT,
  status TEXT,
  sensitivity TEXT,
  linked_repo TEXT,
  source_ids TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(linked_repo) REFERENCES repos(id)
);

-- email_threads
CREATE TABLE email_threads (
  id TEXT PRIMARY KEY,
  subject TEXT,
  participants TEXT,
  snippet TEXT,
  sensitivity TEXT,
  source_ids TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- documents
CREATE TABLE documents (
  id TEXT PRIMARY KEY,
  title TEXT,
  path_or_url TEXT,
  doc_type TEXT,
  sensitivity TEXT,
  source_ids TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- workspace_folders
CREATE TABLE workspace_folders (
  id TEXT PRIMARY KEY,
  name TEXT,
  path TEXT,
  sensitivity TEXT,
  source_ids TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- privacy_risks
CREATE TABLE privacy_risks (
  id TEXT PRIMARY KEY,
  title TEXT,
  severity TEXT,
  status TEXT,
  affected_source_ids TEXT, -- JSON array
  recommended_action TEXT,
  source_ids TEXT,
  confidence TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- actions
CREATE TABLE actions (
  id TEXT PRIMARY KEY,
  title TEXT,
  priority TEXT,
  status TEXT,
  project_id TEXT,
  source_ids TEXT,
  owner TEXT,
  timeframe TEXT,
  confidence TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(project_id) REFERENCES repos(id)
);

-- weekly_reviews
CREATE TABLE weekly_reviews (
  id TEXT PRIMARY KEY,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  matters_this_week TEXT,
  ignore_this_week TEXT,
  fix_this_week TEXT,
  finish_this_week TEXT,
  reflect_on TEXT,
  next_action TEXT,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Notes:
-- Many fields use JSON-encoded text (e.g., source_ids, deployment_urls) to avoid heavy JOINs in the first iteration.
-- This schema includes the required tables and timestamps and is designed to accept Gmail/Drive imports into `email_threads` and `documents` without changes.
