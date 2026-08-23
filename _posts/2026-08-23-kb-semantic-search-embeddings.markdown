---
layout: post
title: "Adding Semantic Search to My Knowledge Base — bge-small, sqlite-vec, Two Nasty Bugs, and a Performance Rabbit Hole"
date: 2026-08-23 21:30:00 +0200
description: "How I wired local sentence embeddings into my agent's SQLite-backed knowledge bases: fastembed + sqlite-vec, schema v3 migration across 8 live databases, a latent FTS5 trigger corruption bug, an autocommit fsync trap, and why the backfill was genuinely CPU-bound."
categories: [self-hosted, python, knowledge-management]
tags: [agent_scripts, embeddings, sqlite-vec, fastembed, fts5, rag, hybrid-search]
image: /jekyll-theme-kactus/assets/images/2026-08-23-kb-semantic-search-embeddings.svg

---

My [Hermes agent scripts]({{ site.baseurl }}/2026/08/21/hermes-kb-search-audit-deprecated-usage/) package maintains several SQLite-backed knowledge bases (date-based article collections and entity cards/notes) searched via FTS5 keyword matching. Keyword search works, but it fails exactly when you'd want it most: "first computer program" doesn't match an article that says *algorithm intended for a machine*. This post documents the full build of local embedding-based and hybrid search — requirements, design decisions, the bugs found along the way, and an honest accounting of the performance work.

Everything runs **locally**: no API keys, no network calls at query time, no vector database service. Just SQLite files.

## Requirements and Design Decisions

The work followed a research document evaluating storage options (Chroma, Qdrant, pgvector, sqlite-vec). The winning combination, given the constraint that everything must stay inside the existing per-KB `.index.db` SQLite files:

| Decision | Choice | Why |
|----------|--------|-----|
| Embedding backend | `fastembed` (ONNX Runtime) | No PyTorch, CPU-first, deterministic downloads |
| Model | `BAAI/bge-small-en-v1.5` | 33M params, 384-dim, strong retrieval quality for its size |
| Vector storage | `sqlite-vec` (`vec0` virtual tables) | Lives inside the existing DB file; loadable extension |
| Chunking | Recursive markdown-aware, ~320-token chunks | Headings → paragraphs → sentences; 64-token overlap |
| Fusion | Reciprocal Rank Fusion, k=60 | Rank-based; no score-scale calibration needed between BM25 and cosine |

One requirement changed mid-design. The original plan was opt-in embeddings: an `[embeddings]` extra in `pyproject.toml`, `--semantic` flags that degrade gracefully when dependencies were missing. I flipped it: **embeddings are mandatory infrastructure**. All dependencies became required, every knowledge base gets vectors, and the only graceful degradation left is when an embedding computation *fails at write time* — more on that below.

Two hard rules shaped the whole build:

1. **A write must never fail because embedding failed.** If the model can't load or inference crashes, the article is still persisted; its chunks are marked pending and healed later.
2. **Existing KBs must migrate transparently**, including databases created before schema versioning existed.

## Architecture

```
markdown file ──► frontmatter parse ──► articles table ──► FTS5 (keyword)
└────► chunk_text() ──► article_chunks ──► fastembed ──► chunks_vec (vec0)
```

Three new modules/pieces:

**`kb_embeddings.py`** (new): the recursive markdown chunker, a lazily-instantiated `Embedder` wrapping `fastembed.TextEmbedding`, float32 serialization helpers, sqlite-vec extension loading, and two exception types (`EmbeddingUnavailableError` for missing deps/models, `EmbeddingIndexError` for index-state problems). The model loads in ~4.6s cold and is cached process-wide.

**Schema v3** in `kb_manager.py`:

```sql
CREATE TABLE IF NOT EXISTS kb_meta (
key TEXT PRIMARY KEY,
value TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS article_chunks (
id INTEGER PRIMARY KEY AUTOINCREMENT,
article_id INTEGER NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
chunk_index INTEGER NOT NULL,
content TEXT NOT NULL,
content_hash TEXT NOT NULL,
heading_path TEXT,
embedded_at REAL,
embedding_model TEXT,
UNIQUE(article_id, chunk_index)
);
```

plus a lazily-created virtual table once the first embedding lands:

```sql
CREATE VIRTUAL TABLE IF NOT EXISTS chunks_vec USING vec0(
embedding float[384]
);
```

The `chunks_vec.rowid` mirrors `article_chunks.id`, so KNN joins back to articles trivially. `kb_meta` records `embedding_model` and `embedding_dim` per database — queries embed with whatever model the index was built with, so a future model swap can't silently corrupt results.

**Write path**: every `add_article`/`update_card`/note write re-chunks the body and refreshes vectors inside the same logical operation. Failure handling is the interesting part: if the embedder raises, the chunk rows are inserted with `embedded_at IS NULL` (pending) and the exception is swallowed after logging. The next successful write or an explicit backfill heals them. This makes the embedding pipeline *eventually consistent* instead of a write-time liability.

## Search Modes

All three modes share one hydration layer returning `SearchResult` objects (now with a `score` field):

- **keyword** (default) — unchanged FTS5 `MATCH`.
- **semantic** — query → 384-dim vector → vec0 KNN with a candidate depth of `max(limit*3, 50)`, grouped per article by best chunk distance.
- **hybrid** — both of the above, fused with Reciprocal Rank Fusion:

```text
score(d) = Σ_over_rankings 1 / (k + rank_i(d)), k = 60
```

Hybrid degrades to keyword-only ranks when the vector index is absent or empty. Pure semantic search on an empty index raises a clear error telling you to run `kb admin embed` — silently returning nothing would be worse.

CLI-wise: `--semantic` / `--hybrid` flags on every search command (mutually exclusive), plus two admin commands:

```bash
hermes_agent_scripts kb admin embed performers2 [--full] [--model NAME]
hermes_agent_scripts kb admin embed-status performers2
```

`embed` selects incrementally: articles with pending chunks, chunks whose model doesn't match `kb_meta`, or articles with no chunk rows at all. `--full` wipes and rebuilds.

## Bug #1: Latent FTS5 Trigger Corruption (pre-existing)

While reviewing how to keep FTS5 in sync during migration, I found that the v2 sync triggers on the `articles_fts` external-content table used plain DML:

```sql
CREATE TRIGGER articles_fts_update AFTER UPDATE ON articles BEGIN
UPDATE articles_fts SET title=new.title WHERE rowid=old.rowid; -- WRONG
END;
```

For external-content FTS5 tables, direct `UPDATE`/`DELETE` against the virtual table **corrupts the index** — SQLite documents this explicitly. The index stores only term→rowid mappings while the content lives in the source table; blind updates desync them. The failure surfaces later as `database disk image is malformed` during unrelated searches. I reproduced it deterministically in a test: update a row twice through a connection using those triggers, then `INSERT INTO articles_fts(articles_fts) VALUES('integrity-check')` → boom.

The fix is the documented command-style sync protocol:

```sql
CREATE TRIGGER articles_fts_insert AFTER INSERT ON articles BEGIN
INSERT INTO articles_fts(articles_fts, rowid, title, tags, url, author, body)
VALUES ('insert', new.id, new.title, new.tags, new.url, new.author, new.body);
END;

CREATE TRIGGER articles_fts_delete BEFORE DELETE ON articles BEGIN
INSERT INTO articles_fts(articles_fts, rowid, title, tags, url, author, body)
VALUES ('delete', old.id, old.title, old.tags, old.url, old.author, old.body);
END;
```

The update trigger does `'delete'` (old row) + `'insert'` (new row). Because the corrupted indexes were unrecoverable in place, the v3 migration drops and recreates the FTS table with a `'rebuild'` command backfill, and swaps out any legacy triggers it finds. Every existing KB got fresh, correctly-synced FTS indexes as a side effect of upgrading.

This bug shipped months ago and would have bitten eventually — as a mysterious "corrupt database" during some innocent future update. Migrations that touch trigger definitions should always diff against known-good text, not assume presence implies correctness.

## Bug #2: Autocommit fsync-per-statement (mine, immediately)

Time to backfill. The small KBs finished instantly:

| KB | Result |
|----|--------|
| ai_tools | 138 chunks across 23 articles |
| bond_markets | 50 chunks across 8 articles |
| daily_wather | 31 chunks across 11 articles |
| **performers2** | …timed out at 15 minutes |

performers2 has 2911 articles. Checking mid-flight state showed 1733 chunk rows committed — progress, but glacial. The cause: the backfill loop ran with `isolation_level=None` (autocommit), so *every statement* was its own transaction with its own WAL fsync — roughly five durable commits per article, thousands of times over.

Fix: wrap the whole backfill in one explicit transaction and set WAL-appropriate durability:

```python
conn.execute("PRAGMA journal_mode=WAL")
conn.execute("PRAGMA synchronous=NORMAL") # safe under WAL; huge win
...
conn.execute("BEGIN IMMEDIATE")
try:
for article_id, body in rows: # chunk → insert → batch-embed
...
flush()
except Exception:
conn.execute("ROLLBACK")
raise
conn.execute("COMMIT")
```

## The Performance Rabbit Hole

With batching in place, the remainder of performers2 took **10m07s for 1294 chunks** — still absurd. `time` showed `user 17m48s` versus `real 10m07s`: multi-core CPU churn, not I/O waiting. Time to profile properly.

`cProfile` on a controlled copy (wipe chunks for a few articles, rerun):

```
stats: {'articles_scanned': 8, 'chunks_embedded': 50} wall=61.7s
ncalls tottime filename/function
1 59.849 {built-in method onnxruntime...run}
1 0.280 {onnxruntime...initialize_session}
```

One single `session.run()` call consumed **59.8 of 61.7 seconds**. Tokenization was 0.03s. So it really was transformer inference — but 1.2 seconds per ~300-character chunk is 10–30× slower than bge-small should be. Prime suspect: ONNX Runtime spawning intra-op threads per core and spinning. Benchmarked thread counts on 64 real chunks:

| threads | time for 64 chunks | per chunk |
|---------|--------------------|-----------|
| 1 | 37.4s | 584ms |
| 2 | 32.1s | 502ms |
| 4 | 30.3s | 473ms |

Marginal gains — no oversubscription cliff. Hardware checks: x86_64 with AVX2+FMA present, onnxruntime 1.29.0 (current), fastembed 0.8.0. Then the arithmetic landed: bge-small is ~33M parameters, so each ~75-token chunk costs roughly `2 × params × tokens ≈ 5 GFLOP`. On six modest cores achieving realistic ONNX throughput, **~550ms per chunk is simply what this model costs on this machine**. The earlier "70ms" microbenchmark had been short strings, not real chunks. The usual escape hatch — fastembed's int8-quantized `bge-small-en-v1.5-q` — turns out not to exist in fastembed 0.8's supported catalog.

Verdict: not a bug, a hardware budget. And the architecture already contains it:

- Backfills are one-time costs (2963 chunks for performers2, done).
- Routine writes embed incrementally — 1–3 chunks, sub-second to ~2s.
- Query embedding is a single short string, imperceptible inside a search round-trip.
- The transaction batching means even worst-case rebuilds spend their time in compute, not fsyncs.

## Migration Day: Dry Run First

Eight production databases existed across three generations of schema (including one predating the `schema_version` table entirely — the migrator handles version 0 by replaying v1→v2→v3 idempotently). Before touching anything real, every KB was copied to a temp directory and migrated there:

```
daily_wather: v3, articles=11, integrity=ok, triggers replaced
ai_tools: v3, articles=24, integrity=ok, triggers replaced
test_legacy: v3, articles=1, integrity=ok, triggers replaced ← no version table originally
performers2: v3, articles=2911, integrity=ok, triggers replaced
...all 8 green
```

Only after all copies passed `PRAGMA integrity_check` did the real backfills run. Final state of performers2:

```
Chunks total: 2963
Chunks pending: 0
Articles embedded: 2121 / 2122 ← one empty-body article, zero chunks by design
Vectors stored: 2963
```

And the end-to-end payoff, the query that motivated all of this:

```text
$ kb entity search e2e "first computer program" --hybrid
Ada Lovelace ← matched via "algorithm intended for a machine"
```

Keyword search returns nothing for that query. Hybrid finds it.

## Testing

The suite grew to **125 tests, all passing** — 31 new in `test_kb_embeddings.py` (chunker edge cases, hash stability, serialization round-trips, embedder behavior behind a fake provider), plus manager tests for v3 migration/idempotency, write-path resilience (embedding failures leave pending chunks, writes succeed anyway), search-mode validation, RRF ordering, and degradation paths, plus CLI flag tests including mutual exclusion.

## Takeaways

1. **Trigger definitions deserve migrations.** Presence ≠ correctness; diff trigger SQL text against known-good versions.
2. **Autocommit loops are a fsync tax.** Any bulk operation belongs in one transaction; `synchronous=NORMAL` is the right default under WAL.
3. **Profile before blaming threading.** The "obvious" ONNX thread-contention story collapsed under a benchmark; the model just costs half a second per chunk on this box.
4. **Never-block write hooks need a healing story.** Pending-chunk states plus incremental backfill selection turn embedding outages into non-events.
5. **Dry-run migrations against copies.** Eight databases, three schema generations, zero surprises on the real ones.

