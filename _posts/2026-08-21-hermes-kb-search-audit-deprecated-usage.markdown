---
title: "Hermes KB Search Audit — Current Usage and Deprecated Functions"
date: 2026-08-21 20:30:00 +0200
description: "Audit report documenting all search functionality in the Hermes agent_scripts package, including deprecated commands, the new search-all command, and the restructured CLI hierarchy."
categories: [self-hosted, python, knowledge-management]
tags: [agent_scripts, search, kb, cli, deprecation, refactor]
layout: post
image: /jekyll-theme-kactus/assets/images/agent-scripts-architecture.svg
---

This audit documents the complete search implementation across the `agent_scripts` package as of commit `abf3d64`. It covers deprecated search calls, their locations, the new command structure, and the retained general search functionality.

## Executive Summary

The knowledge base search has been restructured from a single flat `kb search` command into a three-tier hierarchy:

| Tier | Command | Status | Scope |
|------|---------|--------|-------|
| **Legacy** | `kb search` | **Deprecated** → points to `kb date search` | Date-based KB only |
| **Legacy** | `kb entity-search` | **Deprecated** → points to `kb entity list-notes` | Single entity notes only |
| **Date-based** | `kb date search` | **Active** | Date-based KB articles |
| **Entity-based** | `kb entity search` | **Active** | All entities in KB (cards + notes) |
| **General** | `kb search-all` | **New — Retained** | **Both KB types (unified)** |

The **general search (`kb search-all`)** has been retained and enhanced to work across both date-based and entity-based KBs without requiring the user to know the KB type in advance.

---

## Current Search Architecture

### 1. Low-Level Search Functions (in `agent_scripts/kb.py`)

```python
def search_articles(kb_name: str, query: str, kb_path: str | None = None) -> list[dict]:
    """Search the knowledge base index. Returns list of {title, path, excerpt, ...}."""
    # Uses FTS5 when available, falls back to LIKE
    # Searches: title, tags, url, author, body (if column exists)
    # Returns up to 50 results sorted by article_date DESC, created_at DESC
```

**Key characteristics:**
- Works with the unified `articles` table that stores both date-based articles AND entity cards/notes
- Uses FTS5 virtual table (`articles_fts`) for full-text search when available
- Falls back to `LIKE` queries across `title`, `tags`, `url`, `author`, and `body` columns
- Returns excerpt (200 chars, frontmatter stripped)

```python
def search_kb(kb_name: str, query: str, kb_path: str | None = None) -> list[dict]:
    """General search that works with both date-based and entity-based KBs.
    
    This searches the unified articles table which contains both date-based articles
    and entity-based cards/notes. The KB type is auto-detected.
    """
    return search_articles(kb_name, query, kb_path)
```

**`search_kb` is a thin wrapper** that delegates to `search_articles` — the underlying SQLite schema is identical for both KB types.

### 2. KBManager Search Methods (in `agent_scripts/kb_manager.py`)

```python
def search(self, query: str, limit: int = 50) -> list[SearchResult]:
    """Search the date-based KB."""
    if self.kb_type != KBType.DATE:
        raise ValueError("search() is only available for date-based KBs")
    return self._search_internal(query, limit)

def search_entities(self, query: str, limit: int = 50) -> list[SearchResult]:
    """Search across all entity cards and notes in this KB."""
    if self.kb_type != KBType.ENTITY:
        raise ValueError("search_entities() is only available for entity-based KBs")
    return self._search_internal(query, limit)

def _search_internal(self, query: str, limit: int) -> list[SearchResult]:
    """Internal search implementation shared by date and entity KBs."""
    # Same FTS5 → LIKE fallback logic
    # Returns SearchResult dataclass objects
```

**Key insight:** Both `search()` and `search_entities()` call the **same internal implementation** (`_search_internal`). The only difference is the KB type validation guard.

### 3. CLI Command Structure (in `agent_scripts/cli.py`)

#### Legacy Commands (Deprecated)
```python
# kb search (legacy) - line 29-32
search_p = kb_sub.add_parser("search", help="Search knowledge base articles (legacy)")
search_p.add_argument("kb_name", help="Knowledge base name to search")
search_p.add_argument("query", help="Search query")
search_p.add_argument("--kb-path", help="Override default KB root directory")

# kb entity-search (legacy) - line 66-70
ent_search_p = kb_sub.add_parser("entity-search", help="List notes for a single entity")
ent_search_p.add_argument("kb_name", help="Knowledge base name")
ent_search_p.add_argument("entity_slug", help="Entity slug")
ent_search_p.add_argument("--kb-path", help="Override default KB root directory")
```

**Handler (lines 161-183):**
```python
if args.kb_command == "search":
    warnings.warn(
        "The 'kb search' command is deprecated. Use 'kb date search' instead.",
        DeprecationWarning,
        stacklevel=2
    )
    results = kb.search_articles(args.kb_name, args.query, args.kb_path)
    # ... print results
```

**Handler (lines 251-264):**
```python
if args.kb_command == "entity-search":
    warnings.warn(
        "The 'kb entity-search' command is deprecated. Use 'kb entity list-notes' instead.",
        DeprecationWarning,
        stacklevel=2
    )
    results = kb.list_entity_notes(args.kb_name, args.entity_slug, args.kb_path)
    # ... print notes (NOT a search — just lists notes for one entity)
```

> **Critical distinction:** The legacy `kb entity-search` command **does not search** — it lists all notes for a single entity. The name is misleading.

#### New General Search (Retained)
```python
# kb search-all (new) - line 34-38
search_all_p = kb_sub.add_parser("search-all", help="Search any knowledge base (auto-detects type)")
search_all_p.add_argument("kb_name", help="Knowledge base name to search")
search_all_p.add_argument("query", help="Search query")
search_all_p.add_argument("--kb-path", help="Override default KB root directory")
```

**Handler (lines 185-203):**
```python
if args.kb_command == "search-all":
    # General search that works across all KB types
    results = kb.search_kb(args.kb_name, args.query, args.kb_path)
    # ... print results (same format as legacy search)
```

#### Date-Based Commands
```python
# kb date search - line 80-83
date_search = date_sub.add_parser("search", help="Search knowledge base articles")
date_search.add_argument("kb_name", help="Knowledge base name to search")
date_search.add_argument("query", help="Search query")
date_search.add_argument("--kb-path", help="Override default KB root directory")
```

**Handler (lines 276-293):**
```python
if args.date_command == "search":
    from agent_scripts.kb_manager import KBManager, KBType
    kb_mgr = KBManager(args.kb_name, KBType.DATE, Path(args.kb_path) if args.kb_path else None)
    results = kb_mgr.search(args.query)
    # ... print SearchResult objects
```

#### Entity-Based Commands
```python
# kb entity search - line 116-119
entity_search = entity_sub.add_parser("search", help="Search across all entities in KB")
entity_search.add_argument("kb_name", help="Knowledge base name to search")
entity_search.add_argument("query", help="Search query")
entity_search.add_argument("--kb-path", help="Override default KB root directory")
```

**Handler (lines 328-347):**
```python
if args.entity_command == "search":
    from agent_scripts.kb_manager import KBManager, KBType
    kb_mgr = KBManager(args.kb_name, KBType.ENTITY, Path(args.kb_path) if args.kb_path else None)
    results = kb_mgr.search_entities(args.query)
    # ... print SearchResult objects
```

#### KB Registry Cross-KB Search
```python
# In agent_scripts/kb_registry.py - line 82+
def search_all(self, query: str, limit: int = 50) -> list[dict]:
    """Cross-KB search across all registered KBs.
    
    Note: This searches KB metadata only (names, paths). For content search,
    use the individual KB's search methods.
    """
```

This searches **KB registry metadata only** (names, paths, types), not article content.

---

## Deprecated Search Calls — Complete Inventory

### Deprecation Warnings Emitted

| Command | Warning Message | Replacement |
|---------|-----------------|-------------|
| `kb search` | `"The 'kb search' command is deprecated. Use 'kb date search' instead."` | `kb date search` |
| `kb add` | `"The 'kb add' command is deprecated. Use 'kb date add' instead."` | `kb date add` |
| `kb reindex` | `"The 'kb reindex' command is deprecated. Use 'kb date reindex' instead."` | `kb date reindex` / `kb entity reindex` / `kb admin reindex` |
| `kb init-entity` | `"The 'kb init-entity' command is deprecated. Use 'kb entity init' instead."` | `kb entity init` |
| `kb card` | `"The 'kb card' command is deprecated. Use 'kb entity update-card' instead."` | `kb entity update-card` |
| `kb note` | `"The 'kb note' command is deprecated. Use 'kb entity add-note' instead."` | `kb entity add-note` |
| `kb entity-search` | `"The 'kb entity-search' command is deprecated. Use 'kb entity list-notes' instead."` | `kb entity list-notes` |

### Files Referencing Deprecated Search Functions

#### 1. `agent_scripts/cli.py` — Primary CLI handler
- Lines 161-183: Legacy `kb search` handler with deprecation warning
- Lines 251-264: Legacy `kb entity-search` handler with deprecation warning
- Lines 185-203: New `kb search-all` handler (no deprecation)

#### 2. `agent_scripts/kb.py` — Legacy function implementations
- Lines 425-506: `search_articles()` — core search logic (FTS5 + LIKE fallback)
- Lines 509-515: `search_kb()` — thin wrapper for general search (RETAINED)
- Lines 370-397: `list_entity_notes()` — used by deprecated `entity-search`

#### 3. `agent_scripts/kb_manager.py` — KBManager class
- Lines 395-408: `search()` — date-based KB search
- Lines 624-637: `search_entities()` — entity-based KB search
- Lines 798-854: `_search_internal()` — shared implementation
- Lines 951-967: `search_articles()` — legacy wrapper function

#### 4. `agent_scripts/__init__.py` — Public exports
```python
from .kb import add_note, init_entity, list_entity_notes, reindex_kb, search_articles, update_card
# ...
"search_articles",  # exported for external use
```

#### 5. Tests — Verification of deprecated and new commands
- `test_cli.py` lines 71-90: `test_kb_search_legacy` — tests deprecated `kb search`
- `test_cli.py` lines 159-182: `test_kb_entity_search_legacy` — tests deprecated `kb entity-search`
- `test_cli.py` lines 200-216: `test_kb_date_search` — tests new `kb date search`
- `test_cli.py` lines 297-318: `test_kb_entity_search` — tests new `kb entity search`
- `test_cli.py` lines 393-434: `test_kb_search_all` — tests new `kb search-all`
- `test_kb_manager.py` lines 613-626: `test_legacy_search_articles` — tests legacy wrapper
- `test_kb_manager.py` lines 133-159: `test_search_date_kb` — tests KBManager.search()
- `test_kb_manager.py` lines 338-369: `test_search_entities` — tests KBManager.search_entities()

---

## Unified Search Implementation Detail

All search paths ultimately converge on the same SQLite query pattern:

### FTS5 Path (Preferred)
```sql
SELECT a.title, a.file_path, a.tags, a.url, a.author, a.article_date, a.entity_slug
FROM articles a
JOIN articles_fts f ON a.id = f.rowid
WHERE articles_fts MATCH ?
ORDER BY a.article_date DESC, a.created_at DESC
LIMIT 50
```

### LIKE Fallback Path
```sql
SELECT title, file_path, tags, url, author, article_date, entity_slug
FROM articles
WHERE title LIKE ? OR tags LIKE ? OR url LIKE ? OR author LIKE ? OR body LIKE ?
ORDER BY article_date DESC, created_at DESC
LIMIT 50
```

The `articles` table schema:
```sql
CREATE TABLE articles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    tags TEXT,
    url TEXT,
    author TEXT,
    article_date TEXT,
    knowledge_base TEXT,
    file_path TEXT NOT NULL UNIQUE,
    created_at TEXT NOT NULL,
    entity_slug TEXT,
    mtime REAL,
    body TEXT
)
```

**The `entity_slug` column is the key** — it allows the unified table to store both:
- Date-based articles (`entity_slug` = `""` or `NULL`)
- Entity cards (`entity_slug` = slug, e.g. `"emma-stone"`)
- Entity notes (`entity_slug` = slug, e.g. `"emma-stone"`)

This is why `search_kb()` works for both KB types without modification — it's the same table.

---

## Usage Examples

### Legacy (Deprecated — Shows Warning)
```bash
# Date-based KB search
hermes kb search my_kb "query"

# Entity notes listing (NOT search)
hermes kb entity-search my_kb entity-slug
```

### New Date-Based
```bash
hermes kb date search my_kb "query"
```

### New Entity-Based
```bash
# Search across ALL entities in KB (cards + notes)
hermes kb entity search my_kb "query"

# List notes for ONE entity
hermes kb entity list-notes my_kb entity-slug
```

### General Search (Retained — Works for Both)
```bash
# Auto-detects KB type, searches unified articles table
hermes kb search-all my_kb "query"
```

### Python API
```python
from agent_scripts import kb, kb_manager

# Legacy wrapper (deprecated)
results = kb.search_articles("my_kb", "query")

# New general search (retained)
results = kb.search_kb("my_kb", "query")

# KBManager (type-specific)
date_kb = KBManager("my_kb", KBType.DATE)
results = date_kb.search("query")

entity_kb = KBManager("my_kb", KBType.ENTITY)
results = entity_kb.search_entities("query")
```

---

## Migration Guide

| Old Command | New Command | Notes |
|-------------|-------------|-------|
| `hermes kb search kb "q"` | `hermes kb date search kb "q"` | Date-based KBs |
| `hermes kb search kb "q"` | `hermes kb entity search kb "q"` | Entity-based KBs |
| `hermes kb search kb "q"` | `hermes kb search-all kb "q"` | **Recommended** — works for both |
| `hermes kb entity-search kb slug` | `hermes kb entity list-notes kb slug` | Lists notes only, not a search |

---

## Test Coverage

All 89 tests pass (`pytest agent_scripts/tests/ -v`):

- **Legacy tests:** 2 tests for deprecated commands (`test_kb_search_legacy`, `test_kb_entity_search_legacy`)
- **Date-based tests:** 1 test (`test_kb_date_search`)
- **Entity-based tests:** 1 test (`test_kb_entity_search`)
- **General search test:** 1 test (`test_kb_search_all`) — verifies both KB types
- **KBManager tests:** 2 tests (`test_search_date_kb`, `test_search_entities`)
- **Legacy wrapper test:** 1 test (`test_legacy_search_articles`)

---

## Files Modified in Recent Refactor

| File | Changes |
|------|---------|
| `agent_scripts/cli.py` | Added `search-all` subcommand; deprecated legacy `search` and `entity-search` |
| `agent_scripts/kb.py` | Added `search_kb()` function (line 509-515); `search_articles()` unchanged |
| `agent_scripts/kb_manager.py` | Core search logic in `_search_internal()` shared by both types |
| `agent_scripts/tests/test_cli.py` | Added `test_kb_search_all` |

---

## Recommendations

1. **Keep `kb search-all` as the primary user-facing search** — it works regardless of KB type
2. **Remove deprecation warnings in a future major version** — after sufficient migration period
3. **Consider adding `kb search-all --all-kbs`** — cross-KB search using `KBRegistry.search_all()` (currently metadata-only)
4. **Document the unified `articles` table** — it's the key architectural decision enabling general search

---

## Appendix: Search Call Graph

```
User invokes CLI
       │
       ├── kb search (legacy)
       │       └── kb.search_articles() → _search_internal() [DATE KB only]
       │
       ├── kb entity-search (legacy)
       │       └── kb.list_entity_notes() → NOT a search
       │
       ├── kb search-all (NEW, RETAINED)
       │       └── kb.search_kb() → search_articles() → _search_internal() [BOTH types]
       │
       ├── kb date search
       │       └── KBManager.search() → _search_internal() [DATE KB only]
       │
       └── kb entity search
               └── KBManager.search_entities() → _search_internal() [ENTITY KB only]

_search_internal() → SQLite FTS5 MATCH → fallback LIKE → SearchResult[]
```

The **unified `articles` table with `entity_slug` column** is the architectural enabler that makes `search-all` work seamlessly across both KB types.