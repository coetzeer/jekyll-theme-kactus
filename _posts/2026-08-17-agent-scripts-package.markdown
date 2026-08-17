---
title: "The agent_scripts Package — Weather and Knowledge Base Tools for Hermes"
date: 2026-08-17 10:00:00 +0200
description: "How agent_scripts wraps Open-Meteo weather lookups and a SQLite-backed markdown knowledge base into a single Python package with a CLI, plus the daily weather report script."
categories: [self-hosted, python, knowledge-management]
tags: [agent_scripts, open-meteo, sqlite, jekyll, markdown, kb]
layout: post
image: /jekyll-theme-kactus/assets/images/agent-scripts-architecture.svg
---

![agent_scripts architecture diagram](/jekyll-theme-kactus/assets/images/agent-scripts-architecture.svg)

I've been building a small Python package called **agent_scripts** to handle routine lookups and knowledge-base work for the Hermes agent. Rather than scattering one-off scripts around the repo, I wanted a single installable package with a clean CLI that does three things well: fetches weather without an API key, stores and searches markdown articles in a SQLite-backed knowledge base, and supports a lightweight entity-directory model for tracking things like people or places over time.

This post walks through what's in the package, how the pieces fit together, and the daily weather report script that uses both modules.

## What's in the package

The package lives at `~/Documents/agent_scripts/` and installs into a dedicated venv. Its `pyproject.toml` declares a single dependency — `httpx >= 0.27` — and exposes one entry point:

```ini
[project.scripts]
hermes = "agent_scripts.cli:main"
```

After `pip install -e .`, everything is available under the `hermes` command.

## Weather: Open-Meteo without an API key

The `weather` module wraps Open-Meteo's geocoding and forecast APIs. The public surface is one function:

```python
from agent_scripts.weather import get_weather
print(get_weather("Dublin"))
```

Internally, `get_weather` calls the geocoding API to resolve the city name to coordinates, then fetches the current weather for those coordinates. The response is formatted as a simple text block with temperature, wind speed, and a human-readable condition derived from Open-Meteo's weather code map.

What's worth noting is the resilience: `geocode` raises a `ValueError` if the city isn't found, and the caller catches that. The code table in `weather_description` covers the full Open-Meteo current-weather range, so "Thunderstorm with heavy hail" doesn't silently fall back to an unknown code.

## Knowledge base: markdown files plus a SQLite index

The `kb` module is the larger piece. Articles are plain markdown files with optional YAML frontmatter, stored in a `YYYY/MM/DD` directory structure under a KB root. A SQLite database at `.index.db` in the KB root enables fast search without indexing the filesystem on every query.

### Adding articles

```bash
cat report.md | hermes kb add research_notes
```

`add_article` reads from stdin, parses frontmatter, writes the file under today's date path, and inserts or updates a row in the `articles` table. The table uses `file_path` as a unique key with an `ON CONFLICT DO UPDATE` clause, so re-adding the same article updates metadata without creating a duplicate.

### Searching

```bash
hermes kb search research_notes "interest rate"
```

`search_articles` runs a `LIKE` query across title, tags, url, and author columns, returning up to 50 results sorted by article date descending. Each result includes a 200-character excerpt with frontmatter stripped.

### Reindexing

```bash
hermes kb reindex research_notes
```

`reindex_kb` drops and recreates the `articles` table, then walks every `.md` file under the KB directory. It handles both legacy date-based articles and the newer entity-directory structure. Entity slugs are inferred from the file path when frontmatter doesn't provide them.

### Entity directories

The knowledge base also supports an "entity" model — a structured directory per entity (e.g. a person, company, or project) with a `card.md` and a `notes/` folder:

```
research_notes/
  entities/
    emma-stone/
      card.md
      index.md
      notes/
        note-2026-08-16-summer-film-festival.md
```

The CLI exposes four subcommands for this:

| Command | Purpose |
|---------|---------|
| `hermes kb init-entity <kb> <slug>` | Create `card.md` and `index.md` |
| `hermes kb card <kb> <slug>` | Replace `card.md` from stdin |
| `hermes kb note <kb> <slug>` | Append a dated note |
| `hermes kb entity-search <kb> <slug>` | List notes for one entity |

Cards and notes are both indexed in the same `articles` table, so `kb search` finds them alongside date-based articles.

## The daily weather report script

The `scripts/` directory contains `daily_weather.py`, which ties both modules together. It loops over five cities — Dublin, London, Wivenhoe, Seattle, and Texas — calls `get_weather` for each, and renders a markdown table. Texas is handled specially: the geocoder resolves it to the nearest matched location, which the report notes explicitly.

The script writes the report into the `daily_wather` knowledge base under today's date path with frontmatter for title, date, and tags. It uses the same slug-collision logic as `kb.add_article`, so rerunning it on the same day appends a `-1`, `-2` suffix instead of overwriting.

This script is wired into a cron job that runs every morning at 7am, producing a fresh article in the KB without any manual intervention.

## The CLI structure

`cli.py` uses `argparse` with subparsers. The two top-level commands are `weather` and `kb`, with `kb` having its own subparsers for `add`, `search`, `reindex`, `init-entity`, `card`, `note`, and `entity-search`. Everything returns an exit code of 0 on success and prints to stdout, so it composes cleanly in pipes and scripts.

## Why I built it this way

The alternative was either ad-hoc curl calls in shell scripts or pulling in a full framework. The package sits in the middle: small enough to read in one sitting, typed with `py.typed`, and uses stdlib `sqlite3` for persistence so there's no daemon to run. The frontmatter parser falls back to a regex-based approach if `PyYAML` is missing, which makes it tolerant of stripped-down environments.

The trade-off is that the SQLite search uses `LIKE` rather than FTS5. For a personal KB with a few thousand articles that's fine; if the index grows much beyond that, `fts5` would be the next step.
