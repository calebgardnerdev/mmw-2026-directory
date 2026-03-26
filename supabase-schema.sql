-- CMG Events — Supabase Schema
-- Project: CMG Events (ipncdjcqgxbkprhcekfb)
-- Run this in the SQL Editor at supabase.com/dashboard
-- Supports multiple event series: mmw-2026, art-basel-2026, mmw-2027, etc.
-- Created: 2026-03-26

-- Going lists: stores each user's event picks
-- device_id is a random UUID generated client-side and stored in localStorage
-- This lets anonymous users have persistent lists without auth
CREATE TABLE going_lists (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  device_id TEXT NOT NULL,
  event_series TEXT NOT NULL DEFAULT 'mmw-2026',
  event_id TEXT NOT NULL, -- format: "Event Name||2026-03-26"
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(device_id, event_series, event_id)
);

-- Submitted events: user-submitted events pending review
CREATE TABLE submitted_events (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  event_series TEXT NOT NULL DEFAULT 'mmw-2026',
  name TEXT NOT NULL,
  date DATE NOT NULL,
  start_time TEXT,
  end_time TEXT,
  venue TEXT NOT NULL,
  artists TEXT,
  category TEXT DEFAULT 'Club Night',
  is_free BOOLEAN DEFAULT false,
  ticket_url TEXT,
  rsvp_url TEXT,
  submitter_name TEXT,
  submitter_device_id TEXT,
  status TEXT DEFAULT 'pending', -- 'pending', 'approved', 'rejected'
  reviewed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for fast queries
CREATE INDEX idx_going_device_series ON going_lists(device_id, event_series);
CREATE INDEX idx_going_event ON going_lists(event_series, event_id);
CREATE INDEX idx_submitted_series_status ON submitted_events(event_series, status);

-- Row Level Security
ALTER TABLE going_lists ENABLE ROW LEVEL SECURITY;
ALTER TABLE submitted_events ENABLE ROW LEVEL SECURITY;

-- Going lists: anyone can insert/read/delete their own (matched by device_id)
CREATE POLICY "Anyone can insert going picks"
  ON going_lists FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can read going picks"
  ON going_lists FOR SELECT USING (true);

CREATE POLICY "Users can delete their own picks"
  ON going_lists FOR DELETE USING (true);

-- Submitted events: anyone can insert, anyone can read approved, auth reads all
CREATE POLICY "Anyone can submit events"
  ON submitted_events FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can read approved events"
  ON submitted_events FOR SELECT USING (status = 'approved' OR status = 'pending');

-- Authenticated users (Caleb) can update status
CREATE POLICY "Auth users can update submitted events"
  ON submitted_events FOR UPDATE USING (auth.role() = 'authenticated');

-- View: attendance counts per event (how many people are "going")
CREATE OR REPLACE VIEW event_attendance AS
SELECT event_series, event_id, COUNT(DISTINCT device_id) as going_count
FROM going_lists
GROUP BY event_series, event_id;
