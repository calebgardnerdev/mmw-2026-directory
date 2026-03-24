# MMW 2026 — Event Directory

**Live site:** [mmw-2026-directory.vercel.app](https://mmw-2026-directory.vercel.app)

A curated, searchable event directory for Miami Music Week 2026 (March 24–29). 176 events across 6 days, filterable by category and day. Built and maintained by Caleb Gardner / CMG Inc.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Vanilla HTML/CSS/JS (single-file app) |
| Styling | CSS custom properties, Inter font (Google Fonts) |
| Hosting | Vercel (Hobby plan, free) |
| Analytics | GoatCounter (privacy-friendly, no cookies) |
| PWA | Web App Manifest + Apple mobile meta tags |
| OG Images | Custom generator HTML + Playwright screenshot pipeline |
| Domain | `mmw-2026-directory.vercel.app` (Vercel alias) |

## Architecture

```
mmw-directory/
  index.html          ← Entire app (HTML + CSS + JS + event data)
  manifest.json       ← PWA manifest
  icon-512.jpeg       ← App icon (512x512)
  og.jpeg             ← Social share image (1200x630)
  og-generator.html   ← Source file for generating og.jpeg
  og-v1/v2/v3.jpeg    ← Previous OG image iterations
  .vercel/            ← Vercel project config
  .gitignore          ← Git ignore rules
```

### Single-File Architecture

The entire application lives in `index.html` — no build step, no bundler, no dependencies. This includes:

- **HTML structure** (lines 1–200): Header, search bar, filter chips, day tabs, event grid, footer
- **CSS** (lines 25–160): Dark theme, responsive grid (1/2/3 columns), card system, category colors, animations
- **Event data** (line 203+): `EVENTS` array — 176 JSON objects with all event metadata
- **JavaScript** (lines 400–629): Rendering, search, filtering, live-now detection, featured artist highlighting

### Data Model

Each event in the `EVENTS` array has these fields:

| Field | Type | Required | Description |
|---|---|---|---|
| `name` | string | yes | Event name |
| `date` | string | yes | ISO date (YYYY-MM-DD) |
| `start` | string | yes | Start time (HH:MM, 24hr) |
| `end` | string | no | End time (HH:MM, 24hr) |
| `venue` | string | yes | Venue name and optional address |
| `artists` | string | yes | Comma-separated artist names |
| `category` | string | yes | One of: Conference, Pool Party, Showcase, Club Night, Festival, Industry, Flagship, Sunrise/Afterparty, Closing Party |
| `free` | boolean | no | If true, shows "Free RSVP" badge |
| `rsvpUrl` | string | no | Link for free RSVP |
| `ticketUrl` | string | no | Link to buy tickets |
| `donateUrl` | string | no | Donation link (used for Femme House) |
| `radiate` | boolean | no | If true, shows Radiate badge with tooltip |
| `multi` | string | no | Multi-day series name (e.g., "Factory Town") |
| `dayOf` | number | no | Day N of multi-day series |
| `totalDays` | number | no | Total days in series |
| `credit` | string | no | Subtle grey italic attribution line |
| `hidden` | string | no | Invisible search terms for discoverability |

### Key Features

- **Day tabs** — Sticky navigation: All / Tue / Wed / Thu / Fri / Sat / Sun with event counts
- **Category filters** — Single-select chips per day tab (9 categories, color-coded)
- **Search** — Real-time full-text search across name, artists, venue, category, hidden fields
- **Featured artists** — Green all-caps highlighting for key names (configurable in `FEATURED_ARTISTS` array)
- **Linked names** — Artist/brand names link to Instagram profiles (configurable in `LINKED_NAMES` object)
- **Live now** — Red pulsing badge + card border for events happening right now (ET timezone, refreshes every 60s)
- **Free event badges** — Green "Free RSVP" with link
- **Ticket links** — Yellow "Tickets" button (DICE, Tixr, Eventbrite, Shotgun, RA, Posh)
- **Radiate integration** — Orange badge with hover tooltip linking to radiatetheworld.com
- **PWA** — Installable as home screen app on mobile
- **Input sanitization** — HTML chars stripped, 100-char search limit, error boundaries
- **Responsive** — 1 column mobile, 2 columns tablet, 3 columns desktop

### Design System

```
Background:     #050505
Surface:        #111 → #1a1a1a → #222 (elevation levels)
Border:         #2a2a2a
Text:           #e8e8e8 (primary), #999 (secondary), #666 (tertiary)
Accent:         #CCFF00 (lime green)
Font:           Inter (400/500/600/700/800)
Border radius:  14px (cards), 12px (search), 10px (tabs), 6px (badges)
```

Category colors:
- Flagship: `#ff4d6a` (pink-red)
- Conference: `#4da6ff` (blue)
- Industry: `#ff9f43` (orange)
- Club Night: `#c084fc` (purple)
- Pool Party: `#22d3ee` (cyan)
- Sunrise/Afterparty: `#fbbf24` (gold)
- Festival: `#f472b6` (pink)
- Showcase: `#34d399` (green)
- Closing Party: `#ef4444` (red)

---

## Deployment

Hosted on Vercel. **Two commands required** (auto-alias goes to wrong URL):

```bash
# Deploy
vercel deploy --prod --yes

# Alias to custom domain (REQUIRED after every deploy)
vercel alias [DEPLOYMENT_URL] mmw-2026-directory.vercel.app
```

Vercel project name: `mmw-directory`
Account: GitHub-linked (`calebgardnerdevs-projects`), Hobby plan

### OG Image Generation

The social share image is generated from `og-generator.html` using Playwright:

```bash
python3 -c "
from playwright.sync_api import sync_playwright
import time
p = sync_playwright().start()
b = p.chromium.launch()
pg = b.new_page(viewport={'width': 1200, 'height': 630})
pg.goto('file://$(pwd)/og-generator.html')
time.sleep(2)
pg.screenshot(path='og.jpeg', type='jpeg', quality=95)
b.close()
p.stop()
"
```

---

## How to Update Events

1. Edit the `EVENTS` array in `index.html` (starts at line ~203)
2. Add/modify JSON objects following the data model above
3. Update the event count in `manifest.json` description and OG meta tags if the total changes
4. Regenerate OG image if count changes
5. Deploy (see Deployment section)

---

## Analytics

GoatCounter dashboard: [mmw2026.goatcounter.com](https://mmw2026.goatcounter.com)
- Privacy-friendly, no cookies
- Script loaded async in footer

---

## Related Files (outside this directory)

| File | Location | Purpose |
|---|---|---|
| Full audit (1,724 lines) | `~/Desktop/MMW2026_Full_Audit3:23:2026_5am.md` | Cross-referenced 18 source docs against all events |
| Master event research | `../MMW-2026-Master-Event-Research-2026-03-22.md` | Strategic research doc |
| Access map (PRIVATE) | `../MMW-2026-Access-Map-PRIVATE.md` | Contact/access intelligence — DO NOT SHARE |
| Personal schedule | `../vercel-deploy/index.html` | Caleb's personal confirmed/pending/want-to-go |

---

## Contact

Caleb Gardner — [mmw26@rebirthtoearth.com](mailto:mmw26@rebirthtoearth.com) · [@caleb.gardner_](https://instagram.com/caleb.gardner_)
